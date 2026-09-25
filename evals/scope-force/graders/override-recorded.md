---
type: llm
weight: 2
focus: trace
criteria: |
  The run ingests the invoice without asking again, because the owner said to file it anyway. It writes a source page for it whose frontmatter carries a `scope: "override — …"` line naming the admin-paperwork rule, and treats it as an ordinary source otherwise (it is not left with an empty or missing Entities and concepts section merely because it was overridden). It does not refuse, and it does not ingest the other pending item.
---
