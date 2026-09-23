# Schema template

Copy this into `<vault>/_meta/schema.md` and fill every `{{PLACEHOLDER}}` — the dates in examples are literal and stay as they are. Delete page-type rows and examples the domain doesn't need — a schema that describes page types nobody uses teaches the next session bad habits — but keep every numbered section and its number: the skills cite them (§1, §7, §11b…).

---

````markdown
# Wiki schema

Operating manual for this wiki. Claude reads this file before any capture, ingest, query, lint, maintain or dream work. Humans can edit it — it is meant to be argued with and to change as the wiki grows.

**Last revised:** {{YYYY-MM-DD}}

## 1. What this wiki is for

**Vault id:** {{wiki-xxxxxx}} — this vault's name that never changes. The project instructions and every scheduled task point at this, not at the folder's name, so renaming or moving the folder breaks nothing. Never edit it; two vaults carrying the same id are two copies of one vault, which wiki-doctor reports.

**Whose vault this is:** {{name}}. Lint check 13 uses this to tell the owner's own contact details from a third party's; without it that check cannot judge what it finds.

**Languages:** {{the languages the sources are in, e.g. English, German}}. Query searches for a question's terms in each of them.

{{One paragraph: the domain, why it exists, what "good" looks like.}}

It exists to answer questions like:
- {{the first question they said they will ask it}}
- {{the second, if they gave one}}

Out of scope: {{what does NOT get filed here}} — and always, whatever else this vault decides: admin rather than knowledge. Tickets, boarding passes, invoices, receipts, statements, calendar entries, task lists, credentials, keys and account details. And another living person's personal data: CVs and applications, ID, medical or financial records, private message threads, contact files, photographs of people other than the vault's owner. These have a better home in the app that issued them; filed here they gain nothing, get propagated across pages, and end up in exports. A session that is handed one says which rule it fails and waits rather than capturing it. If the owner overrides that, the source page says it was ingested against scope and which rule it fails — in a `scope: "override — <rule>"` line in its frontmatter and a note in its body — and it propagates only if the owner asks for that too.

A source that is in scope but states its own expiry — an event page, a time-limited offer, a job posting — carries that date as `expires:` on its source page, so lint check 13 can find it once it has passed.

## 2. Layers

- `raw/` — immutable sources, as text. Read and cite; never edit, rename or delete. New sources land in `raw/inbox/` until ingested. On ingest, text goes to `raw/` and every binary goes to `raw/assets/`, so `raw/` stays greppable.
- `raw/assets/` — the binary originals: PDFs, documents, slides, images, audio, video, plus attachments used inside pages. Immutable in exactly the same way — never edited, never renamed, never deleted.
- `wiki/` — Claude's output. Every page here is regenerable from `raw/` plus this schema.
- `_meta/` — this schema, the log, the templates, the import records of folders brought in whole (`_meta/imports/`), the vault lock (`_meta/wiki-lock.md`: one writer at a time — a skill that changes the wiki takes it first, and anyone can open it to see what is running), the two scripts the skills run (`wiki-lock.sh`, `wiki-search.sh`), and a record of every reorganisation (`_meta/moves/`), if files were ever moved.
- `outputs/` — decks, exports, charts, and the lint and dream reports and the maintain digests. Disposable; the knowledge they present lives in `wiki/`.

## 3. Page types

| Type | Folder | Grouped by | One page per | Created when |
|---|---|---|---|---|
| source | `wiki/sources/` | {{— \| year of published \| subject}} | raw source | every ingest |
| entity | `wiki/entities/` | {{— \| subject}} | {{person, org, product, place, dataset…}} | mentioned substantively in 1+ source |
| concept | `wiki/concepts/` | {{— \| subject}} | {{idea, method, theme, mechanism}} | referenced in 2+ sources, or central to 1 |
| note | `wiki/notes/` | — | question answered, comparison, analysis, synthesis | a query, or a dream finding the owner accepted (wiki-dream-ingest), produces something worth keeping |
| overview | `overview.md` | — | the whole wiki | at setup; revised on most ingests |
| index | `index.md` | — | the whole wiki | at setup; updated on every ingest |

{{Domain-specific types, e.g. decisions/, competitors/, characters/ — with the same columns.}}

**Grouped by** gives a type folder one level of subfolders, for people browsing the files; Claude finds every page by name and never needs them. `—` keeps the folder flat. `year of <field>` puts a page in `<type folder>/<YYYY>/`, from the first four digits of that field; a page without a usable date stays at the top of the type folder — the capture or ingest date is never used as a stand-in. `subject` puts a page in `<type folder>/<subject>/` when its `subject:` names one of §3c's subjects; a page with no subject stays at the top. One level only. A page is placed when it is created; pages are only ever moved with the owner present (wiki-setup's `references/grouping.md`), and a page the owner moved stays where they put it.

**Promotion rule:** a passing mention lives as a line on an existing page. It earns its own page when a second source touches it, when the first source says something substantial enough that someone would search for it by name, or when two or more pages already link to it. **Unless no source defines it** — a term named everywhere and explained nowhere cannot be written without inventing the definition. Record that as a source gap under `## What to read next` in `overview.md`, naming the source that would unblock it, and leave the page unwritten.

## 3b. How sources arrive

Sources reach `raw/inbox/` by any route: the Obsidian Web Clipper, drag-and-drop, phone sync, a read-later export, or Claude fetching one on request. The wiki treats them all the same.

- **Every arrival passes the scope test in §1** before it is ingested, however it got here. A clip or a sync never met capture's check, so ingest applies it; a file that fails waits in `raw/inbox/` for the owner's decision.
- **`raw/` is immutable, including files other tools wrote.** Never reformat a clip or add frontmatter to it. The only permitted edit is flipping an existing `ingested:` field to the ingest date.
- **Foreign frontmatter is mapped, not rewritten.** Clipper `source` → `url`, `created` → `captured`, plus `published`, `author`, `site`, `description`, `tags`. The mapped values live on the source page.
- **Ingested state is derived**: a source has been processed when a source page — any page with `type: source`, normally under `wiki/sources/` — carries a `raw:` field (an answer captured from a combined project: when a note does) — or, for an earlier capture of a changed source, a `raw_previous:` entry or a `## Version history` line — pointing at its file. An `ingested:` flag, where present, is a convenience for filtering and is trusted only when it agrees.
- **On ingest the source splits by kind.** Text — a clip, a pasted article, their own note — moves from `raw/inbox/` to `raw/` as it is. A binary that is itself the source — PDF, doc, slides, image, audio, video, spreadsheet, data file — moves to `raw/assets/`, and a markdown sidecar with the same name stem goes to `raw/` in its place. **Attachments are the third case:** figures pulled from a parent, images inside a clip, files attached to an email. They go to `raw/assets/` named after their parent's raw stem (`2026-09-20-attention.md` → `2026-09-20-attention-fig3.png`), get no sidecar of their own, and are listed on the parent's `asset:`. Either way the item leaves `raw/inbox/`, and `raw/` holds exactly one markdown file per capture.
- **When the vault can't be reached** — a cloud session with the computer off — a link or pasted note goes on an offline backlog outside the vault (in a Claude project, the doc `wiki-backlog.md`) and is captured the next time a session can reach the vault, before anything else.
- **Folders are imported whole**, never file by file: each copy gets a unique name built from its path, and an import record in `_meta/imports/` keeps where it came from, a fingerprint and the date git records for it. The source page carries `origin:`; every maintain run brings in what changed in the folder since.
- **One route skips the inbox.** Obsidian saves pasted and downloaded images straight into its attachment folder, which is `raw/assets/`. Those are attachments of the clip or note that embeds them: at ingest they are listed on that source's `asset:` under the name they arrived with, and never renamed — `raw/` is immutable.
- **The sidecar is provenance only.** What the thing is, where it came from, when it was captured, how complete the capture is, and what it leaves out. No extracted text, no transcript, no OCR: the compiled content lives on the source page, and the binary in `raw/assets/` is reopened whenever a claim needs checking. A sidecar growing into a transcript is a sign the source page is too thin.
- **Duplicates get checked at ingest**, by URL, by `origin:` for a file from an imported folder — or by title together with author and edition or period — before any page is created. A recurring title (this year's annual report) is a new source, not a re-capture. A re-capture of a changed source is a new raw file: the existing source page's `raw:` moves to it, the earlier file goes on the page's `raw_previous:` list, and the page says what changed — never an overwrite, never a second page.

## 3c. Subjects

{{Only when a type in §3 is grouped by subject; otherwise write "None — no type is grouped by subject."}}

- `{{subject-folder-name}}` — {{what belongs here, in one line}}

Each line names a subject's folder and what belongs in it. A subject may also name its **hub**, the page it is about (a project, an organisation, a module, a book), even one not written yet: `` - `value` — [[hub-page]] — line ``. A page belongs to a subject when it is mainly about it; a page that spans several subjects, or none, has no `subject:` and stays at the top of its type folder. Only source pages, and pages of a type grouped by subject, carry `subject:`. The skill that creates a page sets it once and says why: by the line above when that plainly settles it, otherwise by the neighbourhood vote, which counts the subjects of the other sources that link the same pages (wiki-setup's `references/grouping.md`, *Assigning a subject*). After that it changes only when the owner changes it, or approves a lint proposal to. Subject names are lowercase kebab-case, so the folders work on every filesystem.

## 4. Naming

- Filenames: lowercase-kebab-case, `.md`, **unique across the entire vault**, compared without regard to case and across every folder — `[[wikilinks]]` resolve by name, not path. Grouping subfolders never make a repeated name acceptable.
- Link to a page as `[[name]]`, never by a path: a name survives any reorganisation, a path does not. Find a page by its name anywhere in the vault outside `raw/`, `outputs/` and `_meta/` — never assume its folder.
- Sources: the natural title, slugified (`attention-is-all-you-need.md`), not the original filename.
- Raw files: capture date, then a lowercase-kebab slug of the source's real title — not the CMS filename or a URL hash (`raw/inbox/2026-09-20-attention-is-all-you-need.pdf`). Files from an imported folder are named from their path in it instead (`2026-09-22-backend-readme.md`), so repeated names can't clash. Files that arrived from a clipper or a sync keep the name they came with; `raw/` is immutable. A new wiki page never takes a name a file in `raw/` already has; if a clash arises anyway, the wiki page is the one renamed.
- People: `firstname-lastname.md`. Disambiguate with a qualifier, never a number (`john-smith-anthropic.md`).
- A binary and its sidecar share one name stem: `raw/assets/2026-09-20-attention.pdf` next to `raw/2026-09-20-attention.md`. The sidecar names the binary by filename, not by path, so it survives a layout change.
- No dates in wiki page names except where the thing itself is dated (a meeting, a release).

## 5. Frontmatter

Every page starts with YAML. Wikilinks inside YAML must be quoted.

```yaml
---
type: source            # source | entity | concept | note | overview | index
title: Attention Is All You Need
aliases: [transformer paper]
tags: [{{domain tags}}]
created: 2026-09-20
updated: 2026-09-20
status: stub            # stub | developing | solid
# subject: {{subject}}   # only in vaults with subjects in §3c, on source pages and grouped types: one of them, or omit
# source pages only:
raw: raw/2026-09-20-attention.md            # always the markdown in raw/, never raw/inbox/
asset: [raw/assets/2026-09-20-attention.pdf]  # list: the binary original and any attachments; omit if none
# expires: 2026-09-20                       # add only if the source states its own end date
# scope: "override — admin"                # add only if the owner had it ingested against §1's scope, naming the rule it fails
# raw_previous: [raw/2025-03-02-attention.md]    # the last ten earlier captures, newest first; older ones stay listed under ## Version history; omit if none
# origin: "docs/backend/README.md"           # only for a file from an imported folder: its import record's name and the path inside the folder
author: Vaswani et al.
published: 2017-06-12   # as the source states it (YYYY or YYYY-MM when that is all it gives); the owner's own writing: the day it was written; a file from an imported folder that states none: its git date from the import record; omit if unknown
url: https://arxiv.org/abs/1706.03762
# non-source pages:
sources: ["[[attention-is-all-you-need]]"]
# raw: raw/2026-09-20-answer.md   # on a note only when it was filed from an answer captured in a project combining several wikis (answer-from: in its provenance)
# sections: 11                    # only on a source page read in sections (§10): how many; it groups its key claims by section and is never split
# history-of: "[[transformers]]"   # only on a history companion: the page whose older ## History entries it holds (§10)
---
```

**Reserved tag:** `synthesis` marks a note surfaced by a dream pass and filed by wiki-dream-ingest — a connection drawn across pages rather than an answer to a question. Every other tag is the domain's own.

`updated` changes on every edit. A note also carries `answered:` — the day its answer was last written or refreshed. Nothing else changes it: a callout, a link or a lint fix bumps `updated:` only (a note missing `answered:` gets it from `created:`, by lint check 9), so `answered:` is what tells whether a newer source has overtaken the note. `raw:` always points at a markdown file in `raw/` — it, `raw_previous:` and the page's `## Version history` lines are what the derived ingested-state check reads — and `asset:` **lists** everything in `raw/assets/` that belongs to this source: the binary original if the source is one, plus any figures or attachments extracted from it. One source, one page, however many files — and however many captures: when a source changes and is captured again, `raw:` points at the newest capture and `raw_previous:` lists the earlier ones, so lint still knows every file in `raw/` is covered. `sources` lists every source page that contributed; it is how the lint pass finds pages nobody can trace.

`raw_previous:` and **`## Version history`** together are the record of a source that keeps changing — a doc re-captured every week, a strategy paper in its third revision. Every capture keeps its own file in `raw/`, forever; the frontmatter list stays readable by holding only the last ten, and the section on the page carries one line per capture, oldest included: date, the file, what changed in the claims (or "no claim changed"), and the reason **the source itself gives** — never an inferred one. It is the drift of the thing the source describes, which is often worth more than the current version alone. For a file from an imported git folder, the repository is the detailed history; the section records only what changed a claim here.

`expires:` is only for a source that states its own end date — an event page, a time-limited offer, a job posting, a call for papers. Lint check 13 reads it and reports the page once the date has passed; without it, nothing in the vault can notice that a source has stopped being useful.

## 6. Linking and citation

- Link the first mention of any entity or concept that has a page: `[[transformers]]`, or `[[transformers|the architecture]]` when the sentence needs different wording. Inside a table, escape the pipe — `[[transformers\|the architecture]]` — or the table breaks.
- **A claim taken from another part of the brain** — another connected vault — is quoted with that part's name and vault id instead of a link, because links resolve only inside one folder: `— research brain (wiki-7f3a2c), transformer-scaling`. That is a complete citation here, not a missing one, and lint leaves it alone.
- **Every factual claim carries a source link**, usually at the end of the sentence or bullet: `Training used 8 P100 GPUs — [[attention-is-all-you-need]]`. A claim from a source read in sections (§10) names the section too — `— [[advisor-plan]], §Phase 2` — as a transcript's claim names its timestamp. On a source page the page itself is the source, so its own claims carry no link to it; a link there points at a *different* source it confirms or contradicts.
- **In answers and notes**, a claim read on a page that cites a source may carry that citation: `— [[page]], citing [[source]]`. It reports what the opened page cites; the source page itself is opened when the exact figure or wording matters.
- Claude's own synthesis across sources is allowed and valuable, but marked: `*(inference)*` or under an `## Interpretation` heading.
- Quote sparingly — a line or two at most, in quotes, with the source link. The wiki is a compilation, not a copy.
- A wikilink to a page that doesn't exist yet is fine and useful: it marks something worth writing. The lint pass lists them.
- **Raw files are never linked with `[[ ]]`.** A source page names its files as plain paths — `raw:`, `raw_previous:`, `asset:` — and an image may be embedded (`![[…]]`), but a raw file is never the target of a link. Links resolve by name among the wiki's pages, a raw file's name can match a page's, and every check that follows links assumes they point at pages. In Obsidian's graph the raw files therefore float as a ring around the wiki; that is expected, and the graph view's search box (`-path:"raw/" -path:"_meta/" -path:"outputs/"`) hides them.

## 7. Contradictions

A contradiction between **two parts of the brain** — two connected vaults — is reported in the answer and, if it is worth keeping, captured as an answer into one part's inbox and filed there as one note, naming the other part: neither vault owns it, and writing a callout into both would leave each holding a claim it cannot check.

Never silently overwrite what an earlier source said. Record the disagreement on both pages involved — the two pages that carry the conflicting claims — and on both source pages as well when it is material:

```markdown
> [!warning] Contradiction
> [[source-a]] (2024) reports X. [[source-b]] (2026) reports Y.
> Unresolved. Currently favouring the newer figure; see [[note-page]] if investigated.
```

Add a line to `## Contradictions in play` in `overview.md`, and to `## Open questions` as well when resolving it would change the wiki's central thesis.

## 8. index.md

Content-oriented catalog: one row per page, grouped by type. Read it first when answering a question, then drill into pages. Updated on every ingest, rebuilt by the lint pass.

```markdown
## Concepts
| Page | What it covers | Sources | Updated |
|---|---|---|---|
| [[transformers]] | attention-based sequence architecture | 4 | 2026-09-20 |
```

A type that §3 groups gets a subheading per folder, naming it, with the rows of the pages that are in that folder now — ungrouped rows first. So anyone reading the index, in any editor, can see where each file lives:

```markdown
## Sources
| Page | What it is | Ingested |
|---|---|---|
| [[an-undated-clip]] | a blog post with no date | 2026-09-20 |

### 2017 — wiki/sources/2017/
| Page | What it is | Ingested |
|---|---|---|
| [[attention-is-all-you-need]] | the transformer paper | 2026-09-20 |
```

## 9. _meta/log.md

Append-only, newest at the bottom, one entry per operation, always starting with the same prefix so it stays greppable:

```markdown
## [2026-09-20] ingest | Attention Is All You Need
- source: raw/2026-09-20-attention.md + raw/assets/2026-09-20-attention.pdf → [[attention-is-all-you-need]]
- new: [[transformers]], [[self-attention]]
- updated: [[sequence-models]], [[overview]], [[index]]
- flagged: contradiction with [[rnn-scaling-claims]]
```

Operations logged: `setup`, `capture`, `ingest`, `query`, `lint`, `maintain`, `dream`, `schema`. A `query` entry is written when an answer is filed as a note, or when the core of a question went unanswered — then with the topic, not the question word for word, a `- checked:` line with what was searched and how much was waiting in `raw/inbox/`, and a `- gap:` line. A gap is never logged without the `- checked:` line above it: lint reads the pair, and a gap named while the answer sits pending is a finding (check 14). An `ingest` entry carries `- verified:` — the pass's own check of the pages it wrote (wiki-ingest-pending, Step 5b). A `dream` entry may also carry `- read:` (the pages that pass opened in full) and the register lines `- watch:`, `- near:` and `- closed:` — hypotheses the pass left open for the next one, never facts, and never copied into `wiki/`.

## 10. Page style

- Write for a reader who knows the domain but not this source. No preamble, no "this page discusses".
- Structure over prose: short sections, bullets, tables where things are comparable.
- Keep pages focused — aim for {{~300–800}} words.
- **Read in sections past:** {{~15,000}} words. A source longer than that is mapped by its own headings, read section by section and ingested in one pass; its page groups the key claims by section, cites them as `— [[source]], §<section>`, and is never split.
- **Split past:** {{~1,200}} words, not counting `## History` or `## Version history` — both are ledgers and grow by design. A page past it with distinct sections is split along its natural seam and linked, not left to ramble. A `## History` that outgrows the rest of its page moves its older entries to a companion `<page>-history` page; it never moves into another subject's page.
- A type folder past {{100}} pages is offered a grouping (§3) by the lint pass. A declined offer is not repeated until the folder has doubled.
- Present tense for what is true; past tense with a date for what was observed.
- Never delete substantive content during an update. Revise, mark superseded, or move it to a `## History` section. The single exception is a lint check-13 redaction of a third party's personal data, which removes rather than moves — a `## History` section is still in `wiki/` and still exports.

## 11. Workflow expectations

- **Ingest:** file it and show me the changelog
- **Query:** answer from the wiki first; say so explicitly when the wiki doesn't know and you're reaching for `raw/` or the web. {{Log the topic of a question the wiki couldn't answer | Don't log unanswered questions}}.
- **Lint:** the mechanical fixes applied and reported, everything else proposed with a recommendation. Runs inside every maintain run; can also run on its own.
- **Maintain:** {{weekly | monthly}} — ingest everything pending, lint, write a digest. May run unattended, with authority for exactly two things beyond capturing what is on the offline backlog and what changed in imported folders: ingesting in-scope pending items — unless the Ingest line above asks to discuss each source first, in which case an unattended run only lists them — and lint's mechanical fixes (the mechanical parts of checks 1, 8 and 9). Everything else it reports — it never moves a wiki page.
- **Dream:** {{monthly | every 10 new sources}} — a dream pass (wiki-dream-only, which may be scheduled) writes a report of connections the pages already imply and applies nothing. I decide each finding with wiki-dream-ingest; only what I accept lands in `wiki/`.
- **Debug:** off. Turn it to `on` while testing the plugin or a new routine: runs then also record where these instructions made them guess, into `outputs/debug-YYYY-MM-DD.md`, and behave exactly as they otherwise would — including an unattended run, whose authority below covers that one extra file. Off is the normal state.
- **Human owns:** sourcing, direction, judgement. **Claude owns:** summarising, linking, filing, bookkeeping.

## 11b. Freshness

A claim counts as stale once it is older than **{{freshness window — e.g. 12 months; a quarter for a fast-moving domain, several years for a stable one}}** and a newer source touches the same subject. A claim is as old as the source behind it (its `published:` date), not as old as the page's `updated:`; a source with no date is of unknown age — say so rather than treating it as fresh. Lint check 6 reads this line; without it that check cannot run.

## 12. Schema history

**Built with:** llm-wiki {{version}}, on {{YYYY-MM-DD}}. Setup writes this and upgrade mode updates it; wiki-doctor compares it with the installed plugin and says what an upgrade would change.

- {{YYYY-MM-DD}} — created at setup.
````

---

## Notes for whoever fills this in

- Placeholders are not optional. A schema with `{{BRACES}}` left in it is worse than no schema, because the next session will follow it literally.
- Section 11 is the one people change most after a week of real use. Say so when handing it over. Its Ingest line starts as file-first; the owner who wants to review each source before it is filed changes it to "discuss takeaways with me before writing".
- Leave every **Grouped by** cell at `—` unless the grouping is known before any page exists — `year of published` for a source type that arrives in volume and is dated, or subjects the purpose itself lists, where each page belongs to one (the books of a series, a course's modules). Otherwise the lint pass proposes one once a folder is big enough to show its shape.
- In §3c, name a hub only where §3 has a type for that page (a project is an entity; a module or a book needs a type of its own); it may be written later.
- When you later change conventions mid-flight, append to section 12 and, if the change is retroactive, run a lint pass to bring old pages in line.
