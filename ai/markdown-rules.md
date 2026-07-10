# Markdown Rules

## Nested HTML List Indentation for Visual Grouping

<ul>

Use HTML unordered lists (`<ul>...</ul>`) to indent section content by heading level.
Nest `<ul>` blocks so that each section's body is wrapped in `<ul>...</ul>`, with 
deeper nesting for subsections under parent sections.

This creates a clear visual cue about hierarchical grouping based on column alignment.

### Structure

<ul>

For a hierarchy like:

```markdown
## Parent Section

### Child Section 1

### Child Section 2
```

Wrap as:

```markdown
## Parent Section

<ul>

### Child Section 1

<ul>

Content for Child Section 1...

</ul>

### Child Section 2

<ul>

Content for Child Section 2...

</ul>

</ul>
```

The closing `</ul>` of the parent wraps the entire section body, aligning all child 
subsections visually under their parent heading.

</ul>

### Purpose

<ul>

- Improves visual hierarchy in rendered markdown
- Aligns related content blocks by indentation
- Makes section structure immediately apparent without reading headings

</ul>

</ul>
