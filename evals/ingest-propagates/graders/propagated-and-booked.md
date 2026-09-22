---
type: llm
weight: 2
focus: trace
criteria: |
  The run ingested exactly one pending item (the retry-storms one) into the vault, and it did all of these:
  - wrote a source page under wiki/sources/ for it;
  - propagated it — at least one entity or concept page was created or updated with a claim that links the new source page (an existing page such as backpressure being updated counts);
  - moved the ingested file out of raw/inbox/ into raw/;
  - added or updated a row in index.md and appended an entry to _meta/log.md;
  - left the other pending item (the invoice) untouched in raw/inbox/.
  Fail if it wrote only a source page and nothing else, if it left the file in raw/inbox/, or if it touched the invoice.
---
