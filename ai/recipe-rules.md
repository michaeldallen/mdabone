# recipe rules

## Ingredients List

Always create a separate `ingredients.md` file alongside the recipe file. 

Separate items into **Shopping** and **Pantry Essentials** sections, using checkbox list items (`- [ ]`).

Also create a companion `ingredients-print.html` — a self-contained HTML file with clean print CSS (no nav, no chrome). Add a link to the GitHub Pages URL at the top of `ingredients.md`:

```markdown
[🖨 Printable version](https://michaeldallen.github.io/mdabone/recipes/<recipe-name>/ingredients-print.html)
```

The GitHub Pages URL pattern is `https://michaeldallen.github.io/mdabone/<path-to-file>`. Pages must be enabled on the repo (requires the repo to be public).



## Flowchart

Always create a separate `flowchart.md` file alongside the recipe file using a Mermaid `flowchart TD` diagram.

Design rules:

- Identify independent cooking tracks (e.g. pasta, sauce, croutons) and run them as **parallel vertical lanes** from a shared `Start` node

- Label edges with the track name in quotes (e.g. `-- "Sauce Track" -->`)

- Each node should be a concise action with key details (time, temperature, technique) on a second line where helpful

- Parallel tracks must **converge** at a final assembly node, then flow to a `Serve` or `Done` terminal node

- Node text uses `\n` for line breaks within a label

- Keep node IDs short and sequential (A, B, C … or descriptive single words)

