---
type: llm
weight: 2
criteria: |
  The reply refuses to ingest the invoice and names the reason: it is admin material that the vault's schema puts out of scope (invoices / admin, not knowledge). It offers to proceed only if the owner explicitly overrides, or says what it would do instead. It does not silently ingest it, and it does not invent a different reason such as the file being unreadable.
---
