#!/usr/bin/env bash
# Publish screenshot evidence to a dedicated orphan branch (never merged into code)
# and print markdown-ready image URLs pinned to the evidence commit.
#
# Usage: publish-evidence.sh <evidence-dir> <pr-key>
#   <evidence-dir>  folder with screenshots, e.g. .devflow/todo-due-dates/evidence
#   <pr-key>        subfolder name on the evidence branch, e.g. feat-todo-due-dates
# Env:
#   DEVFLOW_EVIDENCE_BRANCH  branch name (default: devflow-evidence)
#   DEVFLOW_REPO_SLUG        owner/repo override (default: parsed from origin URL)
# Output: one line per image: "<file-name>\t<url>"
set -euo pipefail

src="${1:?evidence dir required}"
key="${2:?pr key required}"
branch="${DEVFLOW_EVIDENCE_BRANCH:-devflow-evidence}"

[ -d "$src" ] || { echo "No evidence dir: $src" >&2; exit 1; }
src="$(cd "$src" && pwd)"

shopt -s nullglob nocaseglob
images=("$src"/*.png "$src"/*.jpg "$src"/*.jpeg "$src"/*.gif "$src"/*.webp)
shopt -u nocaseglob
[ ${#images[@]} -gt 0 ] || { echo "No images in $src" >&2; exit 1; }

slug="${DEVFLOW_REPO_SLUG:-}"
if [ -z "$slug" ]; then
  url="$(git remote get-url origin)"
  slug="$(echo "$url" | sed -E 's#^(git@github\.com:|https://github\.com/|ssh://git@github\.com/)##; s#\.git$##')"
fi

tmp="$(mktemp -d)"
cleanup() { git worktree remove --force "$tmp" >/dev/null 2>&1 || true; rm -rf "$tmp"; git worktree prune; }
trap cleanup EXIT

if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
  git fetch -q origin "$branch"
  git worktree add -q -B "$branch" "$tmp" "origin/$branch"
else
  git worktree add -q --detach "$tmp" HEAD
  (
    cd "$tmp"
    git checkout -q --orphan "$branch"
    git rm -rfq . >/dev/null 2>&1 || true
    git clean -fdxq
    printf '# Evidence\n\nScreenshots referenced from pull requests. Not part of the codebase; never merge this branch.\n' > README.md
    git add README.md
  )
fi

mkdir -p "$tmp/$key"
cp "${images[@]}" "$tmp/$key/"
(
  cd "$tmp"
  git add "$key"
  if ! git diff --cached --quiet; then
    git commit -qm "evidence: $key"
  fi
  git push -q origin "$branch"
)
sha="$(git -C "$tmp" rev-parse HEAD)"

for f in "${images[@]}"; do
  name="$(basename "$f")"
  printf '%s\thttps://github.com/%s/blob/%s/%s/%s?raw=true\n' "$name" "$slug" "$sha" "$key" "$name"
done
