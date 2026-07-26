#!/usr/bin/env bash
# Build PDF + EPUB of "The Last Application" from the manuscript.
# Requires: pandoc, tectonic (brew install pandoc tectonic).
# Cover: assets/cover.png (canonical — same art as marketing /book/cover.png).
# Output: dist/the-last-application.{pdf,epub}
set -euo pipefail
cd "$(dirname "$0")/.."

OUT=dist
COVER=assets/cover.png
mkdir -p "$OUT"

if [[ ! -f "$COVER" ]]; then
  echo "[build-ebook] missing $COVER — copy the canonical cover there first." >&2
  exit 1
fi

# Chapters in reading order (filenames sort correctly).
FILES=$(ls book/*.md | sort)

META=(
  --metadata title="The Last Application"
  --metadata subtitle="Semantic applications and the end of the rewrite"
  --metadata author="Leroy Ware"
  --metadata date="2026"
  --metadata rights="© 2026 Leroy Ware. All rights reserved."
  --metadata lang="en-US"
)

echo "[build-ebook] EPUB…"
# shellcheck disable=SC2086
pandoc $FILES "${META[@]}" \
  --toc --toc-depth=1 \
  --top-level-division=chapter \
  --epub-cover-image="$COVER" \
  -o "$OUT/the-last-application.epub"

echo "[build-ebook] PDF…"
# shellcheck disable=SC2086
pandoc $FILES "${META[@]}" \
  --toc --toc-depth=1 \
  --top-level-division=chapter \
  --pdf-engine=tectonic \
  --include-in-header=scripts/cover-header.tex \
  --include-before-body=scripts/cover-before.tex \
  -V documentclass=book \
  -V fontsize=11pt \
  -V geometry:margin=1.1in \
  -V mainfont="Palatino" \
  -V monofont="Menlo" \
  -V linkcolor=blue \
  -o "$OUT/the-last-application.pdf"

echo "[build-ebook] done:"
ls -lh "$OUT"
