# Contributing

Thank you for reading closely enough to want to improve the manuscript.

## Welcome

- Typos, broken links, and factual errata (wrong dates, misattributions)
- Clarity fixes that do **not** change voice or thesis
- Build-script fixes (`scripts/`)

Open a pull request against `main` with a short description of what you fixed.

## Discuss first

Open an issue before proposing:

- Structural changes (chapter order, new chapters, cuts)
- Voice or tone rewrites
- Substantive argument changes
- Commercial reuse / derivative editions (see [LICENSE](./LICENSE))

## Local build

```bash
brew install pandoc tectonic   # if needed
./scripts/build-ebook.sh
```

Do not commit `dist/` — builds are regenerable.

## Voice

This book is written in a specific voice (clear, first person, dry wit — not hype). Preserve it. When in doubt, match the surrounding paragraphs rather than “improving” them to sound more corporate or more academic.
