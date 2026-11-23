#!/usr/bin/env python3
"""Report version pins in the Dockerfile that are behind upstream.

Reads .github/upstream.txt: one pin per line, `ARG_NAME source`, where source is one of
  github:OWNER/REPO                 the latest release (or, with no releases, the highest version tag)
  dockerhub:NS/NAME:PREFIX[:SUFFIX] the highest tag PREFIX<version>SUFFIX on Docker Hub
  pypi:NAME                         the latest release on PyPI
  npm:NAME                          the `latest` dist-tag on npm
Prints one line per pin that is behind (`ARG current latest source`) and exits 0; exits 2 when a source cannot be read.
Dependabot already covers versions written in FROM lines; this covers the ones in ARG values, which it cannot see.
"""
import json
import os
import re
import sys
import urllib.request

VERSION = re.compile(r"^v?(\d+(?:\.\d+)*)$")


def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": "upstream-check", "Accept": "application/json"})
    token = os.environ.get("GITHUB_TOKEN")
    if token and url.startswith("https://api.github.com/"):
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def key(v):
    m = VERSION.match(v)
    return tuple(int(x) for x in m.group(1).split(".")) if m else None


def latest(source):
    kind, _, rest = source.partition(":")
    if kind == "github":
        try:
            return get(f"https://api.github.com/repos/{rest}/releases/latest")["tag_name"]
        except Exception:
            tags = [t["name"] for t in get(f"https://api.github.com/repos/{rest}/tags?per_page=100")]
            tags = [t for t in tags if key(t)]
            return max(tags, key=key)
    if kind == "dockerhub":
        parts = rest.split(":")
        repo, prefix = parts[0], parts[1]
        suffix = parts[2] if len(parts) > 2 else ""
        found = []
        url = f"https://hub.docker.com/v2/repositories/{repo}/tags?page_size=100&name={prefix}"
        for _ in range(5):
            d = get(url)
            for t in d["results"]:
                n = t["name"]
                if n.startswith(prefix) and n.endswith(suffix):
                    v = n[:len(n) - len(suffix)] if suffix else n
                    if key(v):
                        found.append(v)
            url = d.get("next")
            if not url:
                break
        return max(found, key=key)
    if kind == "pypi":
        return get(f"https://pypi.org/pypi/{rest}/json")["info"]["version"]
    if kind == "npm":
        return get(f"https://registry.npmjs.org/{rest}")["dist-tags"]["latest"]
    raise ValueError(f"unknown source {source}")


def main():
    dockerfile = open("Dockerfile").read()
    failed = False
    for line in open(".github/upstream.txt"):
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        arg, source = line.split()
        m = re.search(rf"^ARG {arg}=(\S+)", dockerfile, re.M)
        if not m:
            print(f"::error::{arg} is not an ARG with a default in the Dockerfile", file=sys.stderr)
            failed = True
            continue
        current = m.group(1)
        try:
            new = latest(source)
        except Exception as e:
            print(f"::error::{arg}: could not read {source}: {e}", file=sys.stderr)
            failed = True
            continue
        kc, kn = key(current), key(new)
        if kc and kn and kn > kc:
            print(f"{arg} {current} {new} {source}")
    sys.exit(2 if failed else 0)


if __name__ == "__main__":
    main()
