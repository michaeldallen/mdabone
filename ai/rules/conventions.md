# Repository Conventions

## Recipe Files
- Printable ingredients filename convention: use `ingredients.html` (not `ingredients-print.html`).
- Ingredients markdown should link to the GitHub Pages URL ending in `/ingredients.html`.
- Main recipe printable link should point to `./ingredients.html`.

## Printable Flowcharts
1. Companion printable flowchart requirement:
Create a companion printable flowchart page for each recipe flowchart.
Use `flowchart.html` as the printable page and `flowchart.svg` as the rendered diagram asset.
Add a printable link at the top of `flowchart.md` using the GitHub Pages URL format:
`https://michaeldallen.github.io/mdabone/recipes/<recipe-name>/flowchart.html`

2. OS setup required for local Mermaid rendering:
When rendering with Mermaid CLI in this Ubuntu codespace, ensure Chromium runtime libraries are installed first.
Run:

```bash
sudo -n apt-get update
sudo -n apt-get install -y libatk1.0-0 libatk-bridge2.0-0 libcups2t64 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2t64
```

3. SVG generation workflow from Mermaid source:
Use the Mermaid block in `flowchart.md` as source of truth, extract it to a temporary `.mmd` file, render to SVG, then remove the temp file.
Run from the recipe directory:

```bash
awk '/^```mermaid/{flag=1;next}/^```/{if(flag){flag=0;exit}}flag' flowchart.md > flowchart.mmd
npx -y @mermaid-js/mermaid-cli -i flowchart.mmd -o flowchart.svg -t neutral -b transparent -w 1400
rm -f flowchart.mmd
```
