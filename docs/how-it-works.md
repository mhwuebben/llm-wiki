# How LLM Wiki works

The reference behind the [README](../README.md): what lands in the vault and why, how sources get in, and how to install, upgrade, fork and edit the plugin.

## What lands in the folder

```
vault/
├── README.md            how this vault works, for you
├── index.md             catalog of every page — read first on every question
├── overview.md          the evolving synthesis: what we know, open questions, contradictions
├── patterns.md          personal vaults only: loops the sources keep showing
├── _meta/
│   ├── schema.md        the conventions Claude follows — yours to edit
│   ├── log.md           one entry per operation, append-only
│   ├── imports/         a record of every folder imported whole: where each copy came from
│   ├── wiki-lock.md     the vault lock: free, or what is writing right now
│   ├── wiki-lock.sh     the script that takes and releases it
│   ├── wiki-search.sh   the searches the skills run — backlinks, citations, pending
│   ├── moves/           a record of every reorganisation, if pages were ever moved
│   ├── webclipper-template.json  the Web Clipper template, to import
│   └── templates/       page templates for source, entity, concept, note
├── raw/                 your sources, one markdown file each — immutable
│   ├── inbox/           pending items, waiting to be ingested
│   └── assets/          binary originals and attachments — immutable
├── wiki/                Claude's pages, all regenerable from raw/ + the schema
│   ├── sources/         one page per source — once large, optionally in year or subject subfolders
│   ├── entities/        people, organisations, products, places, datasets
│   ├── concepts/        ideas, methods, mechanisms, themes
│   └── notes/           filed answers, the thinking behind decks and documents, approved dream findings
└── outputs/             decks, exports, charts, lint reports, digests, dream and debug reports
```

`_meta/schema.md` is the file worth reading and editing. It's what makes Claude a disciplined wiki maintainer rather than a chatbot with file access, and it's meant to evolve as you learn what your domain needs.

### Where things go, and when

| Path | What lands there | When, and who puts it there |
|---|---|---|
| `raw/inbox/` | Every new source, whatever its type: a Web Clipper article, a dropped PDF, a synced file, a URL Claude fetched and converted to markdown, a pasted note. A binary Claude captures gets a markdown sidecar with the same name stem, holding its provenance; one that arrived on its own gets its sidecar at ingest. | The moment it arrives — from you, your tools, `wiki-capture-only` or `wiki-capture-and-ingest`. It is pending here until it is ingested. A file that fails the scope test (admin, or another person's personal data) stays here until you decide. |
| `raw/` | One markdown file per capture of an ingested source. Text sources as they came; for a binary, its sidecar — what it is, where it came from, when it was captured, how complete the capture is. No extracted text. A changed source captured again gets a new file; its page points at the newest, keeps the last ten under `raw_previous:`, and lists every capture it ever had — with what changed and why — under `## Version history`. | At ingest, moved out of the inbox once the source's pages are written. Never edited, renamed or deleted afterwards; the one permitted touch is flipping an existing `ingested:` flag. |
| `raw/assets/` | The binary originals — PDFs, Word files, slides, images, audio, video, spreadsheets — plus attachments: figures pulled from a paper, images inside a clip, files attached to an email. Attachments are named after their parent's file and get no sidecar. | At ingest, while its sidecar moves to `raw/`. Images you paste or download in Obsidian land here directly, once you point Obsidian's attachment folder here during setup; ingest lists them on their parent. |
| `wiki/sources/` | One page per source: summary, key claims, the entities and concepts it touches, how it sits with the rest of the wiki, open questions. Its `raw:` field points at the file in `raw/`, `asset:` lists what it owns in `raw/assets/`. | At ingest — `wiki-ingest-pending`, run by you, by `wiki-capture-and-ingest` or by `wiki-maintain`. After a duplicate check, so nothing gets two pages. |
| Subfolders of a type folder | `wiki/sources/2026/`, `wiki/concepts/pricing/` — only where the schema groups that type (§3), by year or by subject. One level deep. | A page lands in its subfolder when it is created. A grouping is set at setup only when it's known in advance (a journal by year, a course by module); otherwise lint proposes one once a folder passes ~100 pages. A subject can name its own page in the wiki (a project, a module, a book) in schema §3c; each new source gets its subject from §3c's line, or else from the subjects of the sources it shares pages with, and the ingest report says which. Pages are moved only with you present, recorded in `_meta/moves/`, and a page you move stays where you put it. |
| `wiki/entities/`, `wiki/concepts/` | What the vault knows about each thing, gathered across every source that mentions it, each claim with its source link and disagreements shown on the page. | Created at ingest once a thing clears the schema's promotion bar — a second source, enough said that someone would search for it by name, or two pages already linking to it. Until then it's a line on the nearest page. Updated by every later source that touches it. |
| `wiki/notes/` | Answers worth keeping, the argument behind a deck or briefing, and connections across pages you approved. | `wiki-query` files a good answer — and, when an answer becomes a deck or document, files the synthesis here *before* making it; `wiki-dream-ingest` adds a dream finding you accepted, marked as inference. |
| `index.md`, `overview.md` | The catalog, and the current best picture — including open questions, contradictions in play and what to read next. | The index gains a row for every new page, at ingest or when a note is filed; lint rebuilds it from the pages whenever it has drifted. The overview is revised whenever an ingest, a filed answer or an approved finding moves the picture. |
| `patterns.md` | Recurring loops in how you work, decide or get stuck — each with the sources that show it. Claude's reading of them is kept apart, marked as inference. | Personal vaults only. A loop earns a line at the third source that shows it — added at ingest or proposed by a dream pass. |
| `_meta/imports/` | One record per imported folder: each file's path in that folder, a fingerprint, its git date, and the name of its copy. | Written when a folder is imported; extended by every sync, when `wiki-maintain` brings in what changed. |
| `_meta/wiki-lock.md`, `_meta/wiki-lock.sh` | The vault lock: free, or which operation is writing right now, with a line per step — and the small script every writing skill takes and releases it with. | Created at setup. Taken and released by every skill that changes the wiki; open the `.md` any time to see what is running. |
| `_meta/wiki-search.sh` | The searches the skills run — where a name resolves to, what links a page, whether a page's body cites a source, what is waiting in the inbox, and which hits in `raw/` are current and which are earlier copies. One command each, so ingest, query and lint always get the same answer. | Created at setup. Run by the skills; run it yourself any time — `sh _meta/wiki-search.sh backlinks <page>`. |
| `_meta/log.md` | One entry per operation: setup, capture, ingest, query, lint, maintain, dream, schema — including, by topic, questions the wiki couldn't answer. | Appended by every skill that changes something. It's how `wiki-maintain` knows what's new since last time, how a dream pass knows what you've already rejected, and how `wiki-gaps` knows what you keep asking about. |
| `outputs/` | Decks, exports and charts, plus the routine reports: `lint-YYYY-MM-DD.md`, `digest-YYYY-MM-DD.md`, `dream-YYYY-MM-DD.md`, and `debug-YYYY-MM-DD.md` where debug mode is on. | `wiki-query` when an answer becomes a deck, document or chart; `wiki-lint`, `wiki-maintain` and `wiki-dream-only`, each time they run. |

### Why it's split this way

- **`raw/` is the ground truth.** Everything in `wiki/` can be rebuilt from `raw/` and the schema; nothing can rebuild `raw/`. That is why it is never edited, and why a claim on a wiki page always links back to a source.
- **Text in `raw/`, binaries in `raw/assets/`.** `raw/` stays one greppable markdown file per capture, while the originals sit beside it and get reopened whenever a claim needs checking.
- **One queue.** Every source enters through `raw/inbox/` (only images Obsidian downloads into `raw/assets/` skip it), so `wiki-ingest-pending`, `wiki-maintain` and lint all look in one place — nothing gets filed twice, nothing silently skipped.
- **"Ingested" is derived, not flagged.** A source counts as ingested when a source page points at its file. Files from other tools often carry no flag, and a flag can be wrong; the pointer can be checked.
- **`outputs/` is disposable.** A deck or report is a view of the wiki, never the only copy of a thought, so lint never reads it and clearing it loses nothing but renders. Three catches: a dream report still awaiting review is the only copy of its findings, a debug file nobody has read yet is the only copy of what a run found confusing in the plugin, and a chart embedded in a note shows as a broken embed until it is made again from the note.
- **Names for links, folders for you.** Every page name is unique across the vault and links use names, not paths. So Claude finds any page wherever it sits, you can reorganise inside `wiki/` in any editor, and nothing depends on Obsidian: outside it, a `[[link]]` isn't clickable, but searching for the file by name finds exactly one.
- **The schema is yours.** Plugin updates never change `_meta/schema.md`; the skills follow it over their own defaults.

## One source, end to end

A PDF you hand Claude on 20 September:

1. **Checked:** `wiki-capture-and-ingest` runs `wiki-capture-only`, which checks it is in scope and not already in the vault.
2. **Arrives:** it lands as `raw/inbox/2026-09-20-attention.pdf`, with the provenance sidecar `raw/inbox/2026-09-20-attention.md` beside it — complete, page count recorded — and is logged as `capture | Attention Is All You Need`. It is pending; `wiki-capture-and-ingest` hands just this item to `wiki-ingest-pending`.
3. **Read and filed:** `wiki/sources/attention-is-all-you-need.md`, with `raw: raw/2026-09-20-attention.md` and `asset: [raw/assets/2026-09-20-attention.pdf]`.
4. **Propagated:** new pages for `transformers` and `self-attention`, updates to every page it confirms or refines, a contradiction callout wherever it disagrees with an earlier source, a revised `overview.md` — and a closing check that every page the source page lists cites it.
5. **Moved and indexed:** the PDF to `raw/assets/`, the sidecar to `raw/`, new rows in `index.md`. It is no longer pending; anything else in the inbox still is.
6. **Logged:** `## [2026-09-20] ingest | Attention Is All You Need` in `_meta/log.md`, after the capture entry.

A web clip goes the same way, minus the sidecar: the clip itself moves to `raw/`, and any images Obsidian downloaded for it — already in `raw/assets/` — are listed on its source page's `asset:`. A PDF you drop into the inbox yourself also goes the same way; ingest writes its sidecar.

## Feeding the vault

Most sources should arrive without asking Claude. The **Obsidian Web Clipper** is the main path: `wiki-setup` gives you a template to import (`skills/wiki-setup/assets/webclipper-template.json`, also saved to your vault as `_meta/webclipper-template.json`) that clips articles straight into `raw/inbox/` with the provenance fields the wiki expects — and because it runs in your logged-in browser, it gets paywalled and JavaScript-heavy pages a server-side fetch can't.

Drag-and-drop, phone sync, and read-later exports work the same way. The wiki doesn't care how a file arrived:

- `raw/` is immutable, including files other tools wrote — clips are never reformatted, and frontmatter is mapped onto the source page rather than rewritten in place.
- Ingest splits a source by kind: text to `raw/`, binaries to `raw/assets/` with a provenance sidecar left in `raw/`. Attachments — images in a clip, figures from a paper — go to `raw/assets/` too, but belong to their parent and get no sidecar. So `raw/` is always greppable, `raw/assets/` holds the originals, and a source page carries `raw:` for the markdown and `asset:` as a list of everything it owns in `raw/assets/`.
- A source counts as ingested when a source page points at its file, not because of a flag — so nothing gets filed twice and nothing gets silently skipped.
- Every arrival passes the same scope test before it is ingested, however it got there. Admin (tickets, invoices, statements, credentials) and other people's personal data (CVs, private threads, contact files) stay in the inbox until you decide.
- The lint pass checks `raw/` against the source pages and reports clips nobody ingested.

Clip freely; ingest the same day with `wiki-ingest-pending`, and let the scheduled `wiki-maintain` run sweep up whatever is left.

**Bringing in a folder you already have** — a docs repository, a Notion or Evernote export, course materials, a shared drive — is an import, not a copy. Claude first says how many files there are, what it would leave out (build output, generated reference material) and roughly how many passes the ingest will take, and suggests starting with one part. It copies each file under a unique name built from its path, so the `README.md` in every subfolder doesn't clash. An import record in `_meta/imports/` keeps where each copy came from, a fingerprint of its content and, in a git repository, the date of its last change. That lets source pages carry their `origin:` and date, lets the folder's own structure become subjects, and lets every scheduled `wiki-maintain` run bring in what changed in the folder since. A changed file updates its source page from what changed, and the old copy stays in `raw/` as the record of what the document used to say; a file that only changed its spacing, or moved, adds no copy at all; a file that disappears is reported, never deleted. A whole folder regenerated at once still goes through in one run.

## What makes it safe to leave running

- **One writer at a time.** Every skill that changes the wiki first takes the vault lock, `_meta/wiki-lock.md`: a lease with a holder, an expiry and a line per step, so you can open it and see what is running. A second session waits; a session that died is taken over a minute after its lease runs out — normally within six minutes — and the next ingest finishes whatever it left half done. Reading, capturing and writing reports never wait.
- **You can see what it is doing.** A long run — an import, a batch, the routine — starts with a plan (how many items, how many passes, how long), says what it is about to do before each long step, and reports a tally after each pass. The lock file shows the same count at any moment.
- **Nothing gets lost while the folder is out of reach.** If Claude can't reach the vault — a cloud session with your laptop closed, a chat from your phone — a link or note you send goes on a backlog in the Claude project (`wiki-backlog.md`). The next session that can reach the folder captures it before anything else, and so does the scheduled `wiki-maintain` run.

## Install

### In Cowork, from the marketplace (best for sharing)

1. In Claude Desktop, open the **Cowork** tab → **Customize** → **Plugins** → **+** → **Add marketplace**.
2. Paste `mhwuebben/llm-wiki` (or the full URL) and sync.
3. Find **llm-wiki** in the listing and install it.

Updates arrive on the next sync, which is why this beats sending files around. See *Upgrading* below for what a sync does not change.

### In Cowork, from the file

**Customize → Plugins → +** and upload the plugin folder (zipped). Same components, no update channel.

### In Claude Code

```
/plugin marketplace add mhwuebben/llm-wiki
/plugin install llm-wiki@mhwuebben-plugins
```

### Forking it

Push your copy to a git repo whose root contains `.claude-plugin/marketplace.json` — it already does — then add that repo as a marketplace.

Change authorship where it appears: `author` and `repository` in `.claude-plugin/plugin.json`; `owner` and `name` in `.claude-plugin/marketplace.json` (and the install commands above, which use that name); `skills/wiki-setup/assets/about.md`, the introduction and sign-off `wiki-setup` shows; and the byline and contact lines in `README.md`. Keep the copyright line in `LICENSE`, as the MIT licence requires, and add your own beside it.

### Upgrading

A sync updates the skills. It does not touch anything in your vault:

- **Your `_meta/schema.md` stays as it was.** It is yours, and the skills follow it over their own defaults — lint included, so a schema you have customised never floods a report. When a release changes a schema convention, ask Claude to *upgrade the vault*: `wiki-setup` compares your schema with the current template and proposes each change for you to approve, brings existing pages in line with what changed, and offers subfolders for any folder that has grown large.
- **Your project instructions stay as they were.** When a release changes routing, re-paste them: ask Claude to *upgrade the vault*, which shows the current text, or copy the first fenced block from `skills/wiki-setup/assets/project-instructions.md`.
- **Scheduled tasks name skills.** If a task's prompt names a skill this plugin doesn't have, ask Claude to *upgrade the vault*: it gives you the current prompt. The plugin can't edit a task for you.

## Editing it

Every component is markdown. Change a `SKILL.md` and it takes effect in the current session; agents need a plugin reload or a new session. Bump `version` in both manifests when you publish a change, or marketplace installs won't pick it up.
