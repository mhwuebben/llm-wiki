---
name: wiki-capture-and-ingest
description: Capture new items and ingest exactly those, in one pass — use when someone hands over one or more links, files, notes, pasted texts or screenshots — or a whole folder to import — and wants them in the wiki now. Runs wiki-capture-only for each item, then wiki-ingest-pending with just the new items as its argument; everything else already waiting in raw/inbox stays pending. Use wiki-capture-only instead when they only want it saved, parked or clipped for later, and wiki-ingest-pending for items already waiting in raw/inbox.
---

# Wiki Capture and Ingest

New items, all the way in — and only those. What to capture is whatever the request hands over: one or more URLs, file paths, pasted texts or screenshots.

**Several vaults connected?** Then this is capture only (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *A project that combines several wikis*): wiki-capture-only settles which part takes each item (*Which part*, there) and lands it, and step 2 does not run — the items are pending in that part until its own project ingests them, by its scheduled wiki-maintain run or on request there. Say so once, with the part each item landed in. A whole folder is not imported from here at all: that runs from the part's own project.

Run both skills, in order, in full. Do not substitute a remembered version of either — load them:

1. **wiki-capture-only** for each item — land it in `raw/inbox/` with its provenance block, under the naming the schema sets, after its checks: in scope, complete, not already in the vault. For a URL, fetch the contents; a link is not a source until its text is in `raw/`.
2. **wiki-ingest-pending** with **exactly the items step 1 just landed** as its argument, plus any item step 1 found already pending — a binary and its sidecar count as one item. It reads each properly, writes its source page and propagates across every page it touches; then it closes the lists (every page a source names cites it — for several items, one check for the whole pass), moves the files out of the inbox, rebuilds `index.md` and appends to `_meta/log.md`. Nothing else in `raw/inbox/` is touched: it stays pending.

**An item that matches the schema's out-of-scope list** is asked about once, as wiki-capture-only's step 2 says: *file it anyway* or *skip it*. Filed anyway — or forced up front, *"add this anyway"* — it is captured with its `scope: "override — …"` line and ingested in the same pass, like every other item. Skipped, it isn't captured. Partial or refused — a paywall, a JavaScript-rendered page, a truncated PDF, an empty clip, a blocked fetch: say so and offer the alternatives (clip it in the browser, print to PDF, paste the text). A half-captured source is never ingested as if whole: a partial that reads as whole is how a wiki ends up confidently wrong. It lands only if the person says so, marked `partial:` (wiki-capture-only, *Fidelity rules*). The other items go ahead.

**A whole folder?** It is imported, not captured file by file (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/folder-import.md`): wiki-capture-only copies it with its import record, the person picks the part to ingest now on that file's card — that answer is the one yes — and wiki-ingest-pending ingests that part. The rest stays pending.

**The vault out of reach?** wiki-capture-only puts each item on the offline backlog (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/offline-backlog.md`) and nothing is ingested now. Say so once, for all of them.

**Already in the vault?** wiki-capture-only's duplicate check says so. Still pending in `raw/inbox/` → don't capture it again; hand that item to wiki-ingest-pending with the others — it is what the person asked for. Already ingested, and the fetched text differs from the file the source page's `raw:` names → it lands as a re-capture without asking, and wiki-ingest-pending updates that source page. Already ingested and unchanged → say so; there is nothing to ingest.

**Several items:** ask once. When more than three items are handed over — already-pending ones included — show the list first, each item and the name it will get, and get a yes; that yes covers wiki-ingest-pending's too. Ask again only about an item that turned out to be out of scope or partial; one already in is handled as above. Capture them all, then hand wiki-ingest-pending exactly that list. Its rules for several items apply — the order shown, source pages drafted in parallel where sub-agents exist, propagation one item at a time, one log entry for the batch — and so do its size limits (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Cap it*): past ~20 new pages it ingests the items that fit, oldest first, and offers the rest after the report as a new pass; anything not ingested stays pending, and the report says which.

**Check-in.** wiki-ingest-pending's check-in step applies as the schema sets it. Where §11 says to file first and report after — match on the meaning, not an exact phrase — skip it. Otherwise ask what to emphasise; the items have already arrived, so that is the only open question, not whether to proceed.

**Lock:** step 1 writes only new files and needs no vault lock; wiki-ingest-pending takes it for step 2 (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`). If another session holds it, the items are captured and pending: say so, and offer to wait.

**Log:** a `capture` entry per item and an `ingest` entry, per `_meta/schema.md` §9.

**Report once, at the end**, in the shape wiki-ingest-pending asks for: what landed, what's new, what changed, what it contradicts, what it still doesn't answer — and any item that didn't land, with the reason. Don't narrate the capture as a separate result.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs.
