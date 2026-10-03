# C4 diagrams (LikeC4)

C4 model of the multi-repo workspace, written in the [LikeC4](https://likec4.dev)
DSL. Editable, live-previewable, and rendered automatically by CI.

## Files

| File | Role |
|------|------|
| [model.likec4](model.likec4) | Source of truth — Context + Container views |

Generated artifacts (not committed by hand):

| Output | Produced by |
|--------|-------------|
| `png/*.png` | `likec4 export png` — committed to repo by CI for Markdown embedding |
| Static site | `likec4 build` — deployed to GitHub Pages by CI for navigable drill-down |

## Live preview (local)

Requires the LikeC4 VS Code extension, or:

```bash
npx likec4 start projects/mrwc/c4
```

## CI rendering

[Render LikeC4 diagrams](../../../.github/workflows/likec4.yaml) runs on every
push that touches `*.likec4`. It installs Graphviz + Playwright Chromium, exports
PNGs (committed back), and builds the static site for Pages.

> **Note:** LikeC4 does **not** export SVG. PNG (committed) covers Markdown
> embedding; the Pages site covers navigable, vector-sharp viewing in any browser.

## Dependencies (needed locally and in CI)

- `graphviz` (provides `dot`) — layout engine
- Playwright Chromium — PNG rendering
- Node 24+
