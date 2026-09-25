---
type: llm
weight: 2
focus: trace
criteria: |
  The run ingests the invoice without asking again, because the owner said to file it anyway. It writes a source page for it whose frontmatter carries a `scope: "override — …"` line naming the admin-paperwork rule, and treats it as an ordinary source otherwise: its source page has an `## Entities and concepts` section like any other (`none` is the right content when the invoice touches no page in this vault — the section is not left out merely because the item was overridden). It does not refuse, and it does not ingest the other pending item.
---
