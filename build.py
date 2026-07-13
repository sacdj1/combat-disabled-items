#!/usr/bin/env python3
"""Validates and packages the Combat Disabled Items datapack.

Runs every consistency check this project relies on (reference resolution,
JSON validity, macro-function call safety, config-key sync across
load/reset/uninstall, scoreboard objective add/remove sync), then builds
two zips into build/:

  combat-disabled-items-dev.zip      everything, including data/scdi/function/debug/
  combat-disabled-items.zip          the playable release - debug/ stripped out

Usage: python3 build.py
"""
import json
import re
import shutil
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).parent
FUNC_DIR = ROOT / "data/scdi/function"
BUILD_DIR = ROOT / "build"

errors = []


def fail(msg):
    errors.append(msg)


def check_references():
    func_refs, pred_refs, loot_refs, tag_refs = set(), set(), set(), set()

    for p in ROOT.rglob("*.mcfunction"):
        text = p.read_text(encoding="utf-8")
        func_refs.update(re.findall(r"function\s+scdi:([a-z0-9_/]+)", text))
        pred_refs.update(re.findall(r"predicate\s+scdi:([a-z0-9_/]+)", text))
        loot_refs.update(re.findall(r"loot\s+scdi:([a-z0-9_/]+)", text))

    for p in ROOT.rglob("*.json"):
        text = p.read_text(encoding="utf-8")
        func_refs.update(re.findall(r'"function":\s*"scdi:([a-z0-9_/]+)"', text))
        tag_refs.update(re.findall(r'"id":\s*"scdi:([a-z0-9_/]+)"', text))
        func_refs.update(re.findall(r'"values":\s*\[\s*"scdi:([a-z0-9_/]+)"', text))

    for f in sorted(func_refs):
        if not (ROOT / "data/scdi/function" / f"{f}.mcfunction").exists():
            fail(f"missing function target: {f}")
    for f in sorted(pred_refs):
        if not (ROOT / "data/scdi/predicate" / f"{f}.json").exists():
            fail(f"missing predicate target: {f}")
    for f in sorted(loot_refs):
        if not (ROOT / "data/scdi/loot_table" / f"{f}.json").exists():
            fail(f"missing loot_table target: {f}")
    for f in sorted(tag_refs):
        if not (ROOT / "data/scdi/tags/damage_type" / f"{f}.json").exists() and not (
            ROOT / "data/scdi/tags" / f"{f}.json"
        ).exists():
            fail(f"missing tag/other id target: {f}")


def check_json_validity():
    for p in ROOT.rglob("*.json"):
        try:
            json.loads(p.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            fail(f"invalid JSON in {p.relative_to(ROOT)}: {e}")


def check_macro_call_safety():
    """A function with a top-of-line '$' macro command must be invoked with
    a matching 'with <source>' (or inline '{...}') at every call site, or
    Minecraft silently no-ops the ENTIRE function - not just the macro
    line - at every call site that omits it."""
    macro_funcs = set()
    for p in FUNC_DIR.rglob("*.mcfunction"):
        text = p.read_text(encoding="utf-8")
        if re.search(r"^\$", text, re.M):
            name = "scdi:" + str(p.relative_to(FUNC_DIR)).replace(".mcfunction", "").replace("\\", "/")
            macro_funcs.add(name)

    for p in FUNC_DIR.rglob("*.mcfunction"):
        for i, line in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
            for fn in macro_funcs:
                m = re.search(r"function " + re.escape(fn) + r"(?![\w/])", line)
                if m:
                    rest = line[m.end() :]
                    if "with " not in rest and "{" not in rest:
                        fail(f"{p.relative_to(ROOT)}:{i}: calls macro function {fn} without 'with'/inline args: {line.strip()}")


def check_empty_macro_lines():
    """A line starting with '$' with no '$(...)' variable anywhere on it is
    a hard function-load parse error ("No variables in macro"), not a
    no-op - the whole function fails to load, exactly like the missing-
    'with' case check_macro_call_safety catches, just triggered by a typo
    (an accidental leading '$') instead of a missing call-site argument."""
    for p in FUNC_DIR.rglob("*.mcfunction"):
        for i, line in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
            if line.startswith("$") and "$(" not in line:
                fail(f"{p.relative_to(ROOT)}:{i}: line starts with '$' but has no '$(...)' variable - remove the leading '$' or this function fails to load entirely: {line.strip()}")


def check_config_key_sync():
    load_text = (FUNC_DIR / "load.mcfunction").read_text(encoding="utf-8")
    reset_text = (FUNC_DIR / "apply_reset_config.mcfunction").read_text(encoding="utf-8")
    uninstall_text = (FUNC_DIR / "apply_uninstall.mcfunction").read_text(encoding="utf-8")

    load_keys = set(re.findall(r"data storage scdi:config (\w+) run data modify", load_text))
    reset_keys = set(re.findall(r"data modify storage scdi:config (\w+)", reset_text))
    uninstall_keys = set(re.findall(r"data remove storage scdi:config (\w+)", uninstall_text))

    for k in load_keys - reset_keys:
        fail(f"config key '{k}' has a default in load.mcfunction but no reset in apply_reset_config.mcfunction")
    for k in reset_keys - load_keys:
        fail(f"config key '{k}' is reset in apply_reset_config.mcfunction but has no default in load.mcfunction")
    for k in load_keys - uninstall_keys:
        fail(f"config key '{k}' has a default in load.mcfunction but is never removed in apply_uninstall.mcfunction")
    for k in uninstall_keys - load_keys:
        fail(f"config key '{k}' is removed in apply_uninstall.mcfunction but has no default in load.mcfunction")


def check_objective_sync():
    load_text = (FUNC_DIR / "load.mcfunction").read_text(encoding="utf-8")
    uninstall_text = (FUNC_DIR / "apply_uninstall.mcfunction").read_text(encoding="utf-8")

    added = set(re.findall(r"scoreboard objectives add (\S+)", load_text))
    removed = set(re.findall(r"scoreboard objectives remove (\S+)", uninstall_text))

    for o in added - removed:
        fail(f"scoreboard objective '{o}' is added in load.mcfunction but never removed in apply_uninstall.mcfunction")
    for o in removed - added:
        fail(f"scoreboard objective '{o}' is removed in apply_uninstall.mcfunction but never added in load.mcfunction")


def build_zip(dest, exclude_dirs=()):
    dest.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(dest, "w", zipfile.ZIP_DEFLATED) as zf:
        for item in ("data", "pack.mcmeta"):
            base = ROOT / item
            if base.is_file():
                zf.write(base, base.relative_to(ROOT))
                continue
            for p in base.rglob("*"):
                if p.is_dir():
                    continue
                if any(part in exclude_dirs for part in p.relative_to(ROOT).parts):
                    continue
                zf.write(p, p.relative_to(ROOT))


def main():
    check_references()
    check_json_validity()
    check_macro_call_safety()
    check_empty_macro_lines()
    check_config_key_sync()
    check_objective_sync()

    if errors:
        print(f"BUILD FAILED - {len(errors)} problem(s):")
        for e in errors:
            print(" -", e)
        sys.exit(1)

    print("all checks passed")

    if BUILD_DIR.exists():
        shutil.rmtree(BUILD_DIR)

    dev_zip = BUILD_DIR / "combat-disabled-items-dev.zip"
    release_zip = BUILD_DIR / "combat-disabled-items.zip"

    build_zip(dev_zip)
    build_zip(release_zip, exclude_dirs={"debug"})

    print(f"built {dev_zip.relative_to(ROOT)} (full, with debug/)")
    print(f"built {release_zip.relative_to(ROOT)} (release, debug/ stripped)")


if __name__ == "__main__":
    main()
