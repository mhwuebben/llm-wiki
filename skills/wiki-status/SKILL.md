---
name: wiki-status
description: Show the state of the LLM wiki in this folder — size, what is pending in raw/inbox, what changed recently, its open questions and when the routines last ran. Read-only; writes nothing. Use when someone asks how their wiki or vault is doing, what is in it, or what to do next with it. Use wiki-gaps for what is missing or what to read next, wiki-lint to check it for problems or repair it, and wiki-maintain to bring it up to date.
---

Report the current state of the wiki in the connected folder. Read, don't write.

1. Confirm this is a wiki: `_meta/schema.md` exists. If not, say so and offer wiki-setup.
2. Gather:
   - page counts by type (sources, concepts, entities, notes, and any the schema adds) and total — counted at any depth, since pages may sit in subfolders — and, for a type the schema groups, how many pages sit in each group
   - what is pending in `raw/inbox/`, grouped into items as wiki-ingest-pending's *Before you start*, step 3, does (empty files aren't items). A file still in `raw/inbox/` that a page's `raw:` or `asset:` already names is an interrupted ingest — or, while an ingest or maintain lease is live, an ingest still running; say which
   - apart from that, any file in `raw/` or `raw/assets/` that no source page's `raw:`, `raw_previous:` or `asset:` covers (usually something filed by hand) — not pending, but not in the wiki either. Ignore dotfiles, a folder's own `README.md`, files a `retired:` line in the log names, and attachments — a binary in `raw/assets/` named after a source's raw stem or embedded by a page or raw file, as lint check 11 defines them
   - the offline backlog, if this session can read it — in a Claude project, the doc `wiki-backlog.md`: how many lines, and how many need a file re-attached (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/offline-backlog.md`)
   - the vault lock: `sh _meta/wiki-lock.sh status`, or read `_meta/wiki-lock.md` — free, held (by what operation, until when, the last progress line), stale (more than a minute past `expires:` — the next writer takes it over) or missing (the next writer creates it)
   - the last five entries in `_meta/log.md`, leaving out `query` entries that only record a gap
   - `## Open questions` and `## Contradictions in play` from `overview.md`
   - when the last lint, the last maintain run and the last dream pass ran: the last `lint` entry; the last entry that names a digest file (`outputs/digest-YYYY-MM-DD.md`), normally a `maintain | digest` entry; and the last `dream` entry with a `scope:` line — a review entry has none and does not count
   - whether a dream report is still awaiting review — the latest `dream` entry that names the report carries an `unreviewed:` line
   - whether a dream pass is due, by the Dream cadence in §11 of the schema — or, where it sets none, once ten or more sources have been ingested since the last dream pass (since setup, if none has run)
3. Report it in under fifteen lines, in this shape:

**Wiki:** {{purpose in a few words}} · {{n}} pages{{ — per group, for a grouped type}} · last activity {{date}}
**Pending:** {{n}} items in raw/inbox {{names}}{{ · interrupted ingest: names}}{{ · n files in raw/ that no source page covers}}{{ · n on the offline backlog}}
**Recently:** {{two or three lines from the log, in plain language}}{{ · running now: operation, last progress time — or stale since expires}}
**Open questions:** {{the two or three live ones}}
**Routines:** last lint {{date}} · last maintain run {{date}} · last dream {{date}}{{ · dream report awaiting review}}{{ · dream pass due}}
**Suggested next:** {{the single most useful next action — wiki-ingest-pending or a wiki-maintain run if items are pending, draining the offline backlog if it has lines (wiki-capture-only), wiki-dream-ingest for a dream report awaiting review, a wiki-dream pass if one is due, or a question worth asking}}

Don't dump the index and don't list every page. If nothing is pending and nothing is stale, say the wiki is in good shape and name one question worth asking it.
