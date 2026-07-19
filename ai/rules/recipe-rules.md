# recipe rules

## Ingredients List

Always create a separate `ingredients.md` file alongside the recipe file. 

Create an **Ingredients** section, using checkbox list items (`- [ ]`).

Also create a companion `ingredients.html` — a self-contained HTML file with clean print CSS (no nav, no chrome). Add a link to the GitHub Pages URL at the top of `ingredients.md`:

```markdown
[🖨 Printable version](https://michaeldallen.github.io/mdabone/recipes/<recipe-name>/ingredients.html)
```

The GitHub Pages URL pattern is `https://michaeldallen.github.io/mdabone/<path-to-file>`. Pages must be enabled on the repo (requires the repo to be public).



## Flowchart

Always create a separate `flowchart.md` file alongside the recipe file using a Mermaid `flowchart TD` diagram.

Design rules:

- Identify independent cooking tracks (e.g. pasta, sauce, croutons) and run them as **parallel vertical lanes** from a shared `Start` node

- Label edges with the track name in quotes (e.g. `-- "Sauce Track" -->`).  Only label the edges between splitting and converging nodes.

- Each node should be a concise action with key details (time, temperature, technique) on a second line where helpful

- Parallel tracks must **converge** at a final assembly node, then flow to a `Serve` or `Done` terminal node

- Node text uses `\n` for line breaks within a label

- Keep node IDs short and sequential (A, B, C … or descriptive single words)

## Icons 

Use icons/emojis in headings.  

Required icons:

🍳 Cooking Steps
🛒 Ingredients checklist link or section
🖨 Printable ingredients link
📊 Cooking flowchart link or section
🧂 Pantry Essentials section (when present)
🛠 Tools Needed section (when present)
If content is split into companion files, preserve these icons in the main recipe links and in any remaining relevant section headings.