---
name: wiki-capture-only
description: Capture a source into an LLM wiki's raw/inbox — and stop there. Fetches and converts a URL, files a PDF, saves a pasted article, transcript, email or note, registers images and records provenance, after checking scope, completeness and duplicates. Also sets up the Obsidian Web Clipper for sources that arrive on their own, imports a whole existing folder (a docs repository, an export) with a record of where each file came from and keeps it in step later, and keeps the offline backlog of links sent while the vault can't be reached. Use when someone wants to save, park, clip or keep something for later without processing it now, or to import or sync a folder. Never ingests. Use wiki-capture-and-ingest when they want it in the wiki now, and wiki-ingest-pending for what is already waiting in raw/inbox.
---

# Wiki Capture Only

Sources are the ground truth of an LLM wiki. Everything in `wiki/` is regenerable; `raw/` is not. Capture's job is to land a clean, complete, attributed copy of a source in `raw/inbox/` — and then get out of the way. What it lands is **pending** until wiki-ingest-pending ingests it; that skill is also what moves it into `raw/` and `raw/assets/`. This skill never ingests. wiki-capture-and-ingest runs it as its first step and then ingests what landed — that is its job, not this one's.

**This skill is one door of several.** Most sources arrive without Claude: the Obsidian Web Clipper, a drag-and-drop into `raw/inbox/`, a sync from a phone, an export from a read-later app. That's the intended workflow, not a workaround — clipping is faster than asking, and a logged-in browser reaches pages a server-side fetch can't. Read `references/external-capture.md` for the Web Clipper setup, the other routes in, and how ingest reads a file the wiki didn't write. Use this skill when Claude is the one doing the fetching, converting or filing.

## Which part

This skill works on **one vault**. With several connected — each a part of one brain — a capture is the one write such a session makes (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *A project that combines several wikis*), so settle which part takes the item before anything is written. An **answer wiki-query files** from such a session lands here too, as pasted text with `answer-from: <the vault ids it read>` in its provenance, so that ingest files it as a note and never as a source (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *Where a cross-part answer is filed*). A **folder import** is the exception: it sets up an import record that the part's own maintain runs keep in step, so it runs from that part's own project — say so and import nothing.

- **A part the person named** wins, always.
- **A file from an imported folder** goes to the part that holds its import record, permanently: an imported folder belongs to one part, and a copy landing anywhere else would be a second, unconnected source.
- **Otherwise ask, once, with a recommendation** — the parts' §1 lines are the choices, and the recommendation says why ("this looks like material for the one you imported that docs folder into"). Unattended, don't guess: leave the item where it came from and say which parts it could belong to.
- **The same document in two parts** is allowed when the person asks for it, and only then. Both copies carry a provenance line `same-as: <the other part's vault id> · <the file's name there> · <fingerprint>` — the fingerprint being the first 16 characters of the file's SHA-256, the same one an import record uses (`references/folder-import.md`), computed with `shasum -a 256 <file> | cut -c1-16` or its equivalent, and omitted where no shell can compute it, so that nothing downstream mistakes one document for two independent sources — which would turn a single claim into false corroboration (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-only/references/connection-types.md`, *Convergence*). Say plainly that it will be maintained twice.

## First, always

1. Find the vault and read `_meta/schema.md`. No schema? This folder isn't a wiki yet — offer wiki-setup instead of improvising a structure. **The vault can't be reached at all** — no linked computer, the folder not connected, the device offline? Nothing can be captured now: put the item on the offline backlog (`references/offline-backlog.md`) and stop.
2. **Check it is wiki material**, against the schema's out-of-scope list. Two families fail the test however they arrive. **Admin:** tickets, boarding passes, invoices, receipts, statements, calendar entries, task lists, credentials, keys and account details. **Another living person's personal data:** a CV or résumé, an application, an ID document, a medical or financial record, a private message thread, a contact file, a photograph of someone who is not the vault's owner. The second family is the one that looks like a legitimate source — a CV is well-written, on-topic and full of facts — which is exactly why it needs a gate rather than judgement. Say which rule it fails, say what you'd do instead, and stop — do not capture it on your own judgement that it is probably fine. If the person tells you to capture it anyway, do: add `scope: "override — <the rule it fails>"` to its provenance block (quoted, because rule names contain colons), and ingest records the same on the source page.
3. Check for a duplicate before writing anything: search `raw/` filenames and the source pages for the URL, and for the title together with the author and edition or period — a recurring title (this year's annual report) is a new source, not a re-capture. If it's already there, say so and offer to re-capture it if this is a newer version — run by wiki-capture-and-ingest, re-capture a changed version without asking. A copy still in `raw/inbox/` is already pending: don't capture it twice. For a file from an imported folder, the same `origin:` means the same source (`references/folder-import.md`).

## Capture by source type

Say each file as it lands, `+ raw/inbox/<name>` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*), whether one item or a batch.

Full handling notes per type are in `references/source-types.md` — read it when the source isn't a plain web page or PDF. The short version:

| Source | What to do |
|---|---|
| **URL** | Fetch it. Convert to markdown: title, author, date, body. Strip nav, ads, cookie notices, newsletter pleas, comment sections. Keep tables, headings, block quotes, figure captions. If the fetch tool returns a processed rendering rather than the page's text (WebFetch does), ask it for the verbatim text and check headings and length against the page — a paraphrase is a partial capture. |
| **PDF** | Copy the file into `raw/inbox/` under a dated name, with a sidecar `.md` of the same stem beside it. Don't transcribe the whole thing — ingest reads the PDF directly, then files it into `raw/assets/` and its sidecar into `raw/`. Record page count in the provenance block. |
| **Pasted text** | Save verbatim as markdown. Never "improve" it. Ask where it came from if attribution isn't obvious. |
| **Transcript** (podcast, meeting, video) | Save as-is with speakers preserved. Add episode/meeting metadata. Timestamps are worth keeping — they become citations. |
| **Image / screenshot** | Copy into `raw/inbox/` with a sidecar `.md` of the same stem that embeds it and describes what it shows, so it's findable by text search. Ingest moves the image to `raw/assets/` and the sidecar to `raw/`. |
| **Email or chat thread** | Save the thread in order, oldest first, with sender and date per message. Whether it belongs at all was settled in step 2 — a private thread with another person fails it; a work, newsletter or public thread doesn't. Credentials inside an in-scope thread follow the fidelity rules below. |
| **Their own notes / voice memo** | Save verbatim in `raw/inbox/`. This is a primary source too, and often the most valuable one in the vault. |
| **Spreadsheet / data file** | Copy the file into `raw/inbox/`. Add a stub describing columns, row count and what the data is for. |

## Naming and placement

- Path: `raw/inbox/YYYY-MM-DD-slug.<ext>` on arrival — everything lands in the inbox, whatever its type. (If the schema says otherwise, the schema wins.)
- Ingest splits it by kind: text moves to `raw/`, a binary moves to `raw/assets/` and its sidecar moves to `raw/`. Capture never files straight into `raw/` or `raw/assets/` — the inbox is the queue, and skipping it hides the source from `wiki-ingest-pending`.
- If that name is already taken in `raw/inbox/` or `raw/` — a same-day re-capture — add `-2` before the extension.
- Date prefix = capture date, not publication date. Publication date goes in the provenance block.
- Slug from the source's real title, lowercase-kebab, trimmed to something readable. Not `article-1`, not the CMS's URL hash.
- Figures are attachments, not sources of their own. Figures extracted from inside a binary — a PDF's charts — are **ingest's job**: at ingest they land in `raw/assets/` named after the parent's raw stem (`2026-09-20-attention.md` → `2026-09-20-attention-fig3.png`), get no sidecar, and are listed on the parent's `asset:` rather than earning a source page. Images a web page links to are capture's job (see *Keep figures* below): downloaded into `raw/inbox/` beside the capture, named after its stem, and moved with it at ingest. A standalone image — a screenshot someone hands you — is a source and goes through `raw/inbox/` like anything else. The difference is parentage, not file type.

## Provenance block

Every markdown file written into the vault — the source itself when it's text, the sidecar when it isn't — opens with this, before the source's own content:

```yaml
---
captured: 2026-09-20
source_type: web | pdf | transcript | note | email | image | data
title: Attention Is All You Need
author: Vaswani et al.
published: 2017-06-12
url: https://arxiv.org/abs/1706.03762
captured_by: claude
ingested: false
---
```

`published:` is the date of publication the source itself states, as ISO-8601 (`2017-06-12`; `2017` or `2017-06` when that is all it gives) — leave it out when it gives none. The capture date goes in `captured:` and is never a stand-in, except for the owner's own writing, whose date is the day it was written.

`ingested: false` is a convenience for filtering, not the source of truth — plenty of files arrive without it. What actually settles whether a source has been processed is whether a source page — any page with `type: source`, wherever it sits — has a `raw:` field, or a `raw_previous:` entry or a `## Version history` line, pointing at it. Ingest flips the flag where it exists and moves the item out of the inbox: text to `raw/`, binaries to `raw/assets/` with their sidecars to `raw/`.

A source can be text **and** have attachments — a clip with three images, an email with a PDF, a paper with a data file. That is one source: the text is the source and goes to `raw/`, the attachments go to `raw/assets/` named after the source's raw stem, and the source page lists them all under `asset:`. They are attachments, so they get no sidecars of their own.

A binary that is itself the source (a PDF, document, slide deck, image, recording, spreadsheet or data file) can't carry frontmatter — give it a sidecar `raw/inbox/YYYY-MM-DD-slug.md` with the same block plus a `file:` line naming the binary. Attachments don't get one; they belong to their parent. Name the binary by filename, not path: the two travel to different folders at ingest and the filename stays true.

The sidecar is provenance only — what it is, where it came from, how complete the capture is, what it leaves out. No extracted text, no transcript, no OCR: that content belongs on the source page, where it can be revised, and the binary stays in `raw/assets/` to be reopened when a claim needs checking.

## Fidelity rules

- **Save the source, not your reading of it.** No summarising, no reordering, no fixing the author's argument. That happens in `wiki/`, where it can be traced and revised.
- **Complete beats tidy.** If the fetch returns a partial article (paywall, JS-rendered page, cookie wall), don't land it: say so plainly and offer the alternatives — browser extension clip, print-to-PDF, manual paste. Land a partial only when the person says to, with a `partial: <what is missing>` line in its provenance block, so ingest says so on the source page.
- **A refused fetch is not a partial fetch.** When the request is blocked outright — the host refuses, the fetcher reports the site as blocked, or the tool errors rather than returning thin content — nothing was captured. Do not write a stub, do not file the URL as a source, and do not reach for another way to fetch it: a block is a decision, not an obstacle. Log the failed capture with the reason, tell the person, and offer the routes that run in their own browser instead. A `capture | <title> — FAILED` log entry is the correct outcome, and it is worth writing, because it stops the same URL being retried silently next week.
- **Keep figures.** Download a web capture's images into `raw/inbox/` beside it, named after its stem (`2026-09-20-attention-fig1.png`), and embed them by filename; ingest moves them to `raw/assets/` as attachments. A URL that 404s in a year takes the evidence with it.
- **Don't invent metadata.** Unknown author is `author: unknown`, not a guess.
- **Sensitive material was settled at step 2, not here.** If a source turns out to contain another living person's data once you are actually reading it — a health detail, a private message, contact details, an identifier — stop and go back to the scope check rather than deciding in the moment. Once it is in the vault it gets read, summarised, cross-linked and exported.
- **A document can be in scope while parts of it are not.** When a source worth keeping also carries a credential — an order number, a booking reference, a key, an account number — the binary is the right home for them. Leave those fields out of the sidecar and the source page, then say on the page that you did and where they can still be read. Transcribing them spreads a secret across the greppable layer for no gain.

## Batch capture

When several items arrive at once (a reading list of URLs, a handful of PDFs). **A whole folder** — anything with subfolders, or more than a few dozen files — is imported instead, by `references/folder-import.md`: it keeps where each file came from, gives repeated names unique copies, and says how big the job is before starting.

1. List what you found and what you'd name each one. Confirm before capturing more than three items — when wiki-capture-and-ingest runs this, that one yes covers its ingest too.
2. Capture them all into `raw/inbox/`, each said as it lands — `+ raw/inbox/2026-09-20-attention.pdf` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*) — then, run on its own, report a table: title, type, size/length, duplicate?, in scope?
3. Stop there: everything captured is now pending. (Run by wiki-capture-and-ingest, hand it the items that landed.)

## Finish

- Append to `_meta/log.md`: `## [YYYY-MM-DD] capture | <title>` with the path and source type — in one append, as `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md` (*The log*) says. A capture writes only new files, so it needs no vault lock.
- Run on its own: tell the person what landed, in one or two lines, and that it is pending — wiki-ingest-pending ingests it when they ask, and a scheduled wiki-maintain run picks up everything pending. Don't offer to ingest: the person chose to only capture.
- Run by wiki-capture-and-ingest: skip the report and hand back the items that landed, plus any already pending; its report covers both steps.

## Reference files

- `references/external-capture.md` — the Obsidian Web Clipper setup (with the importable template), other routes into the vault, mapping foreign frontmatter, and how ingested state is determined. Read whenever files arrive in `raw/` that Claude didn't put there.
- `references/folder-import.md` — importing a whole existing folder: the size estimate and first slice, names that can't clash, the import record, subjects from the folder's structure, and keeping in step with it later.
- `references/offline-backlog.md` — what to do with an item when the vault can't be reached, and how the backlog is drained once it can.
- `references/source-types.md` — detailed handling for web pages, PDFs, transcripts, images, email threads, data files, books and paywalled content. Read when the source isn't a straightforward article or PDF.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs.
