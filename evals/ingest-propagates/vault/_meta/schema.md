# Wiki schema

Operating manual for this wiki. Claude reads this file before any capture, ingest, query, lint, maintain or dream work.

**Last revised:** 2026-09-01

## 1. What this wiki is for

**Vault id:** wiki-ev0001 — this vault's name that never changes.

**Whose vault this is:** the owner.

**Languages:** English.

A small test vault about distributed systems: how queues, retries and backpressure behave under load.

**Out of scope:**
- admin paperwork — tickets, bookings, invoices, receipts, statements
- credentials and keys
- other people's personal data — CVs, IDs, medical or financial records, private messages, contact files, photos of others

**Questions this wiki exists to answer:** why a queue collapses under load; what backpressure strategies exist and when each applies.

## 2. Layers

- `raw/` — immutable captures. `raw/inbox/` is what is captured and not yet ingested.
- `wiki/` — the compiled pages: `sources/`, `concepts/`, `entities/`, `notes/`.
- `_meta/` — this schema, the log, the templates, the vault lock, the two scripts the skills run.

## 3. Page types

| type | folder | grouped by |
|---|---|---|
| source | `wiki/sources/` | flat |
| concept | `wiki/concepts/` | flat |
| entity | `wiki/entities/` | flat |
| note | `wiki/notes/` | flat |

## 5. Frontmatter

`type`, `title`, `created`, `updated`, `status`; `sources:` on entity, concept and note pages; `raw:` and `asset:` on source pages.

## 6. Linking and citation

Every factual claim carries a source link. Link pages as `[[name]]`, never by path.

## 7. Contradictions

Record a disagreement on both pages involved, with the callout.

## 9. _meta/log.md

Append-only, one entry per operation: `setup`, `capture`, `ingest`, `query`, `lint`, `maintain`, `dream`, `schema`.

## 10. Page style

Short sections, bullets, no preamble. Pages stay under about 800 words.

## 11. Workflow expectations

- **Ingest:** file it and show me the changelog
- **Query:** answer from the wiki first; say plainly when it doesn't know
- **Lint:** the mechanical fixes applied and reported, everything else proposed with a recommendation
- **Maintain:** weekly
- **Dream:** monthly
- **Debug:** off

## 12. Schema history

**Built with:** llm-wiki 3.7.1, on 2026-09-01.

- 2026-09-01 — created at setup.
