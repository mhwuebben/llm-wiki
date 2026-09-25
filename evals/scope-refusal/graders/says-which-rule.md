---
type: llm
weight: 2
criteria: |
  The run does not ingest the invoice on its own. It names the reason — the invoice matches the admin-paperwork line of the vault's out-of-scope list — and asks the owner once whether to file it anyway or skip it. It does not silently ingest it, does not refuse outright without offering to file it anyway, and does not invent a different reason such as the file being unreadable.
---
