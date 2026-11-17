#!/bin/bash
# Makes a browser Choosy's default by moving it to the top of Choosy's browser list,
# which is the browser its picker highlights first.
#
# usage: choosy-default.sh [--dry-run] [--no-restart] <app name, e.g. Zen>

set -euo pipefail

DOMAIN=com.choosyosx.Choosy
dry_run=false
restart=true

while [[ $# -gt 0 ]]; do
   case "$1" in
   --dry-run) dry_run=true ;;
   --no-restart) restart=false ;;
   -*) echo "unknown option: $1" >&2; exit 2 ;;
   *) break ;;
   esac
   shift
done
APP="${1:?usage: choosy-default.sh [--dry-run] [--no-restart] <app name>}"

reordered=$(mktemp)
trap 'rm -f "$reordered"' EXIT

defaults export "$DOMAIN" - | python3 -I -c '
import plistlib, sys
settings = plistlib.loads(sys.stdin.buffer.read())
app = sys.argv[1].lower()
browsers = settings["browsers"]
matches = [b for b in browsers if b["path"].rsplit("/", 1)[-1].lower() == app + ".app"]
if not matches:
    names = ", ".join(b["path"].rsplit("/", 1)[-1].removesuffix(".app") for b in browsers)
    sys.exit(f"no browser named {sys.argv[1]} in Choosy (have: {names})")
if browsers[: len(matches)] == matches:
    print(f"{sys.argv[1]} is already first", file=sys.stderr)
    sys.exit(0)
settings["browsers"] = matches + [b for b in browsers if b not in matches]
print(" > ".join(b["path"].rsplit("/", 1)[-1].removesuffix(".app") for b in settings["browsers"]), file=sys.stderr)
sys.stdout.buffer.write(plistlib.dumps(settings))
' "$APP" >"$reordered"

# No output means the browser is already first, so skip the Choosy restart
if [[ ! -s "$reordered" ]] || $dry_run; then
   exit 0
fi

# A running Choosy can write its in-memory settings back over the import
if $restart && pgrep -qx Choosy; then
   osascript -e 'quit app "Choosy"'
   while pgrep -qx Choosy; do sleep 0.1; done
fi

defaults import "$DOMAIN" "$reordered"

if $restart; then
   open -g -a Choosy
fi
