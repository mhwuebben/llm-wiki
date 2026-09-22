---
name: wiki-setup
description: Set up a new LLM wiki — an AI-maintained second brain built from plain markdown in a folder, with the three-layer structure (immutable raw sources, an LLM-owned wiki, and a schema file), ready to open in Obsidian. Use this whenever someone wants to start a second brain, a personal knowledge base, a research wiki, a book companion wiki, a team or competitive-intel wiki, says they have no vault yet, asks to turn a folder full of documents into a knowledge base that maintains itself, or mentions Karpathy's llm-wiki pattern — even if they only say something vague like "help me organise my notes with Claude". Always run this before wiki-ingest-pending or wiki-capture-and-ingest when the target folder has no _meta/schema.md. Also use it to upgrade an existing vault's schema after a plugin update.
---

# Wiki Setup

Build the scaffolding for a knowledge base that an LLM maintains and a human reads. Read `references/the-pattern.md` if you need the reasoning behind the structure before explaining it to someone.

The output of this skill is a folder the person can open in Obsidian plus a `_meta/schema.md` that every later operation (capture, ingest, query, lint, maintain, dream) reads first. Getting the schema right matters more than getting the folders right — the schema is what turns Claude into a disciplined wiki maintainer instead of a generic chatbot.

## Working in Cowork

- The vault is the connected folder. If no folder is connected, ask the person to click **Work in a project or folder** and pick (or create) one — everything below happens inside it.
- Read and write vault files with the file tools. Code you run may execute in an isolated environment that does not see the connected folder, so don't script bulk edits against the vault; if you want a script, test it on one file first. Moving files (a grouping adopted, a subject changed) needs a shell that does run where the vault's files are — `references/grouping.md` says how, and what to do without one.
- Importing an existing folder of documents needs the shell that runs on the person's computer, where both folders are — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/folder-import.md` has the command.
- A Cowork **project** around this folder is what gives the vault persistent instructions (Step 8). If the folder isn't in one yet, the person creates a project in Cowork and adds this folder to it.

## How to ask

The person is new to all of this, so every question has to make sense to someone who has never seen the plugin.

- **Every question with sensible choices goes on a card** (AskUserQuestion) — never as plain text in the same message as a card, where it is easy to miss. Where the answer may be the person's own words, offer two or three choices and let the card's free-text field ("Something else") take their own.
- **Say what you are asking about in their words.** Not "the routine" or a skill name — say what the thing does: "a scheduled run that files everything waiting in the inbox, tidies the wiki and writes you a summary of what changed".
- **Recommend where there is a sensible default**, first, marked *(Recommended)*, with a one-line description of what each choice leads to.
- **Don't ask what can be inferred or changed later** — say what was chosen, and where to change it. Skip any question the person's opening message already answers.
- **A request for their own words or a file is plain text**, alone in its message — the topic when nothing gave it, a link or a PDF for the first source. Never beside a card.
- **No card tool in this session?** Ask the same questions in one plain message, numbered, with the choices written out and the recommended one first; then stop and wait.

## Step 0 — Say whose plugin this is

On a new setup, before anything else — before asking for a folder — read `assets/about.md` and show its **Opening** block, word for word, rendered as markdown: who wrote the plugin, the idea it is built on, and where both live. One block, then on. Upgrade mode skips it.

## Step 1 — Interview before creating anything

Two cards, with one plain-text question between them only when the topic is still unknown; stop and wait after each (*How to ask*). Skip any question their opening message already answered.

1. **First card, two questions.**
   - **What is this wiki about?** Four choices covering the six presets in `references/domain-presets.md`, each described in a line: a research topic · a book, a series or a course · a company, a team, a market or competitors · their own life and notes. The free-text field takes anything else. Pick the exact preset afterwards, from the answer and the topic.
   - **What goes in?** Several can be picked: papers and PDFs, web articles, transcripts of podcasts or meetings, their own notes — spreadsheets and images through the free-text field.
2. **The topic, if nothing gave it yet** — the specific subject in a few words ("fusion energy", "the Wheel of Time"): plain text, alone in its message.
3. **Second card, built from the answers so far.**
   - **Whose wiki is it?** "Me — <their name>" when the session knows it, otherwise "Just me", and "A team"; the free-text field takes a name. Schema §1 records it; without a name it says "the owner", and they can add the name later.
   - **What will you ask it later?** Two example questions that fit their topic, marked as examples, several allowed, and a clear invitation to type their own. Whatever they pick or type goes into the schema word for word: these questions shape the page types more than anything else.

Pick the closest domain preset in `references/domain-presets.md` and apply all of it in Steps 3–5 — its page types and vocabulary, its starting grouping, and any extra root page, template or frontmatter field it adds. Don't ask more in the interview than these; anything else you can infer or settle later — including the languages the sources will be in, for schema §1, from their answers and the first documents. Don't ask how involved they want to be when sources are filed: nobody can judge that before seeing an ingest. The vault starts with file first, report after, and Step 9 tells them how to change it.

## Step 2 — Look before you write

List the folder. Three cases:

- **Empty** → build the full structure.
- **Has documents already** → don't build the wiki on top of them. Ask on a card: **A new folder beside it** *(Recommended — always for a git repository, or a folder with its own `README.md`, `index.md` or `overview.md`)*: the person creates or picks it (in Cowork, connects it too), the wiki is built there, and this folder is imported. **This folder**: only when none of `README.md`, `index.md`, `overview.md`, `raw/`, `wiki/`, `_meta/` or `outputs/` exists in it — then its documents are imported where they are; their file names share the vault's name space, and lint check 1 reports any clash. Either way, run the import's steps 1 and 2 now (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/folder-import.md`): what's there, what gets left out, how big the job is, and what to ingest first. The copy itself waits until Step 3 has built the structure, and an offer of the folder's own structure as subjects (that file's step 6) feeds the schema in Step 4.
- **Already has `_meta/schema.md`** → this is an existing wiki. Don't re-scaffold. If they asked to upgrade it, go to *Upgrading an existing vault* below; otherwise report what's there and offer wiki-ingest-pending, wiki-query or wiki-lint instead.

## Step 3 — Create the structure

```
<vault>/
├── README.md              how this vault works, for the human
├── index.md               catalog of every page — Claude keeps it current
├── overview.md            the evolving synthesis: what we know so far
├── _meta/
│   ├── schema.md          how this wiki is structured — Claude reads this first
│   ├── log.md             append-only record of ingests, queries, lints
│   ├── wiki-lock.md       the vault lock — lets one writer in at a time
│   ├── wiki-lock.sh       the script that takes and releases it
│   ├── wiki-search.sh     the searches the skills run — backlinks, citations, pending
│   └── templates/         page templates (source, entity, concept, note)
├── raw/                   immutable sources as text — read, never edit, never delete
│   ├── inbox/             dropped here, not yet ingested
│   └── assets/            binary originals: PDFs, docs, slides, images, audio
├── wiki/
│   ├── sources/           one summary page per raw source
│   ├── entities/          people, orgs, products, places, characters
│   ├── concepts/          ideas, mechanisms, themes, methods
│   └── notes/             filed answers, comparisons, analyses
└── outputs/               decks, exports, charts, reports, digests (disposable)
```

Each type folder starts flat unless the preset groups it (schema §3, **Grouped by**); a grouped folder gets its subfolders as pages arrive, not in advance. If Step 2 found documents to import, copy them now, by the import's step 3 — its command also writes the import record. Copy the four page templates from `assets/templates/` into `_meta/templates/`, copy `assets/wiki-lock.sh` and `assets/wiki-search.sh` into `_meta/` under those same names, and run `sh _meta/wiki-lock.sh status` once, which creates `_meta/wiki-lock.md` in its free form (`references/locking.md`). Every skill that changes the wiki takes that lock first. Say each file as you write it — `+ _meta/schema.md` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*) — so the person sees the vault appear. Create every folder with at least one file in it (a `.gitkeep`, the seed page, or — in `raw/`, its subfolders and `outputs/` only — a short `README.md` saying what the folder is for) so the structure survives a sync and is visible in Obsidian. Lint counts none of these as a source. Under `wiki/`, a README would be linted as a page, so use `.gitkeep` there.

## Step 4 — Write the schema

Start from `references/schema-template.md` and fill it in for this person's domain. The template has placeholders in `{{BRACES}}` — none may survive. Tailor at minimum:

- the one-paragraph statement of what this wiki is for and what it is *not* for
- the page types (drop any the domain doesn't need, add domain-specific ones — e.g. `characters/` for a book, `competitors/` for market intel, `experiments/` for a lab)
- the entity taxonomy in this person's vocabulary
- the **Grouped by** column: the preset's starting grouping, and — only where a type is grouped by subject — the subjects in §3c, each with its one-line description, and a hub page only where §3 has a type for it (it may not be written yet), plus a `subject:` line in the matching `_meta/templates/` (`references/grouping.md`)
- the `Languages:` line in §1; §11's Ingest line, which starts as file first, report after — `file it and show me the changelog`; §11's Maintain line as `weekly` for now — Step 8 asks, and changes it if needed — and its Dream line as `monthly`; and §11's Query line on whether unanswered questions are logged (the personal preset says not)
- the one or two questions from Step 1, written into the schema as the questions the wiki exists to answer

Tell the person in one line that the schema is theirs to argue with and that it will change as the wiki grows — co-evolving it is the point, not a sign something went wrong.

## Step 5 — Seed the starter pages

Write `README.md`, `index.md`, `overview.md` and `_meta/log.md` from `assets/vault/`. Fill them in, don't leave them as stubs:

- `README.md` — three-layer explanation in plain language, the loop (capture → ingest → query → lint, plus the scheduled maintain run and dream), and what the human owns versus what Claude owns.
- `index.md` — the category headings with empty tables, plus a line saying it's maintained automatically.
- `overview.md` — a stated purpose, an empty synthesis section, and an **Open questions** section pre-filled with the questions from Step 1. This file is the one the whole wiki is trying to make true and useful.
- `_meta/log.md` — a header plus the first entry: `## [YYYY-MM-DD] setup | vault created`.

## Step 6 — Obsidian

Walk through `references/obsidian-setup.md`: install, **Open folder as vault**, and the settings that make this pattern work: wikilinks on, automatic link updating on, new link format left on shortest path, new-note location, and the attachment folder pointed at `raw/assets/`. Then open the graph view.

Set up the **Web Clipper** in the same pass rather than leaving it for later — it's the habit that keeps the vault fed. The template lives inside the plugin, where the person can't browse, so read `assets/webclipper-template.json`, show its full JSON in a code block, and write a copy to `_meta/webclipper-template.json`. Then walk them through it: install the extension → its settings → Templates → import, and paste the JSON (or drop the file). It files clips into `raw/inbox/` with the provenance fields the wiki expects. Dataview can wait until it's wanted.

If they don't use Obsidian, say plainly that nothing breaks: it's markdown in folders, any editor works, and Claude follows the links itself. `[[wikilinks]]` just won't be clickable — to follow one, they search for the file by that name, which is unique (the *If they don't use Obsidian* section of `references/obsidian-setup.md`).

## Step 7 — Land the first source

Don't end on an empty vault — an empty second brain is abandoned by the weekend. After an import, follow the choice on its card: one part → ingest its first pass, with progress (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*), and the rest after Step 9 or with the scheduled runs; everything → the first pass here and the rest after Step 9, on the same yes; nothing now → offer one copied document instead. The handover is never held up for hours. Otherwise ingest one source now: their most interesting document, or one article fetched. Where §3c names hub pages not yet written, the list behind them (the syllabus, the series' book list) makes a good first source: it gives those pages something to cite. Use wiki-capture-and-ingest — the same route the project instructions give every later session — or wiki-ingest-pending if it is already in `raw/inbox/`: the test clip from Step 6, or a document Step 2 copied — offer one of those first, on a card, before asking for something new. Asking for something new is plain text (*How to ask*); say what will happen in plain words: *"Send me a link, a PDF or a note — the most interesting thing you have. I'll save it into the vault and file it right away: it gets its own page, the pages it touches are updated or created, and the overview and index are revised, so you can open the vault and see the result."*

## Step 8 — Hand over the project instructions and the scheduled task

This step is not optional. Everything in this plugin depends on future sessions routing correctly, and they only do that if the project says so; the scheduled task is what keeps the wiki current when nobody asks.

**First, ask how often the scheduled run should go**, on a card, naming what it is: *"How often should the wiki maintain itself? A scheduled task files everything waiting in the inbox, fixes the small problems a clean-up finds, and writes you a summary of what changed."* Choices: **Weekly** *(Recommended)* — for a vault that gets new sources most weeks; **Monthly** — for a quiet one. Put the answer in the Maintain line of schema §11 and in what you tell them about the task.

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/project-instructions.md`.
2. **Show the person both blocks, in the same reply**, with `{{VAULT FOLDER}}` already replaced by their actual folder name: the project instructions, then the wiki-maintain task prompt from *The scheduled task*. Do not summarise either and do not just point at the file — they need text they can copy in one go.
3. Tell them exactly where each goes. The instructions: the project instructions field of the Claude project that owns this vault (Claude desktop or claude.ai → the project → Settings), or a `CLAUDE.md` at the vault root in Claude Code. The prompt: a new scheduled task on that project, **with the vault folder attached to the task** — a scheduled session with no folder attached can do nothing and cannot ask for access, since granting it needs someone at the computer — set to approve automatically — otherwise a scheduled run stops at its first file write — and to run on the computer that holds the folder, with the vault and every imported folder connected.
4. Say what they buy in one sentence each: questions get answered from the wiki instead of from general knowledge and dropped links get ingested instead of parked; and whatever arrives on its own — clips, drops, the offline backlog — gets ingested, linted and summed up in a digest without anyone asking.
5. If this session is already running inside a project, say plainly that you cannot set the field or create the task yourself — they have to paste them.

## Step 9 — Say what happens next

In plain words, not skill names — the skill names belong in the prompts they paste.

1. **How involved they are, in one line.** Sources are filed first and reported after — that is what lets the scheduled run keep the wiki current on its own. To review each source before it is filed instead, they change the Ingest line in schema §11 to `discuss takeaways with me before writing`, or ask Claude to; a scheduled wiki-maintain run then only lists what is pending, and ingesting waits for them.
2. **Later, once there are ten or so sources:** a monthly dream pass that proposes connections for them to decide on. Mention it now, with the wiki-dream-only prompt from *The scheduled task*; don't schedule it on an empty vault. Its reports wait for them, and wiki-dream-ingest works through each one with them.

Close by telling them their job — curate sources, ask good questions, decide what matters — and yours: the reading, summarising, cross-referencing, filing and bookkeeping. Then show the **Closing** block of `assets/about.md`, word for word and rendered, as the last thing setup says.

## Upgrading an existing vault

A plugin update changes the skills, never the vault. When someone asks to upgrade an existing vault after a plugin update (bringing its content up to date is wiki-maintain's job):

1. Read their `_meta/schema.md` and `references/schema-template.md` side by side, section by section, plus `_meta/templates/` against `assets/templates/` and their `README.md` against `assets/vault/README.md`. Where `${CLAUDE_PLUGIN_ROOT}/CHANGELOG.md` has an *Upgrading an existing vault* note for a release dated on or after the vault's last `schema` log entry (its `setup` entry, if it has none), read that too.
2. List what the template has that their schema lacks or states differently — a missing field, rule, log operation or §11 line — each with the section and the one line of text you'd add or change. Skip anything they deliberately customised: their own page types, their own questions, their own wording of a rule that means the same. For an added line that needs a value — a `Languages:` line, say — propose one inferred from the vault. §11's Ingest, Maintain and Dream lines hold the owner's settings — the filing mode, the cadence: keep those values, and propose only wording the template added around them. If a type folder is past the threshold in §10 (100 pages if it sets none), offer a grouping, and adopt it only by `references/grouping.md` (*Adopting a grouping*), with the person present. Where §3c lists subjects without a hub, offer one for each subject whose value is also a page's name or alias — it only adds the link to §3c; no page changes and nothing moves.
3. **Settle every choice first:** each proposed line — where theirs conflicts with the template, show both and let them choose; never delete a section or a rule of theirs — any grouping, with its preview, approval and pre-flight (`references/grouping.md`), and which sections or loop-table rows of `assets/vault/README.md` their own `README.md` should take (it is Claude's starter page, but keep their edits).
4. **Then apply, under the lock.** Write `_meta/wiki-lock.sh` and `_meta/wiki-search.sh` from `assets/wiki-lock.sh` and `assets/wiki-search.sh` if either is missing or differs, and take the vault lock (`references/locking.md`). Apply only what they approved: the schema lines; the existing pages brought in line with what changed — a convention the schema now states is lint's mechanical fix, applied here on the same approval; `_meta/templates/` replaced with the plugin's, keeping any field or section they added; an approved grouping, under this lock; the README sections; and the operations line at the top of `_meta/log.md`, brought in line with §9 by an edit in place with the Edit tool — the one change to the log that isn't an append. Append to §12 of the schema, log a `schema` entry naming what changed — and any grouping they declined, as `- declined: grouping of <folder>` — and release the lock.
5. Show the current project instructions and the scheduled-task prompt, as in Step 8, items 1–3 — without asking the schedule again — so they can re-paste them, and name any Obsidian or Web Clipper setting that a note from step 1 says has changed — the plugin can't change either for them. Ask which scheduled tasks they have: for any whose prompt names a skill this plugin doesn't have, give the current prompt from *The scheduled task* in `assets/project-instructions.md` — the wiki-maintain one, and the wiki-dream-only one if they schedule dreaming. The plugin can't edit a task.

## Rules that survive into every later session

Write these into the schema, and follow them yourself:

- `raw/` is immutable. Read it, cite it, never edit, rename or delete it. Everything in `wiki/` can be regenerated; `raw/` cannot.
- On ingest a source splits by kind: text lands in `raw/`, binaries land in `raw/assets/` and leave a provenance sidecar of the same name stem in `raw/`. So `raw/` is always one greppable markdown file per capture, and `raw/assets/` holds the originals. Attachments — figures from a parent, images in a clip, files on an email — go to `raw/assets/` under the parent's stem and get no sidecar. Source frontmatter carries `raw:` at the markdown and `asset:` as a list of everything the source owns in `raw/assets/`.
- Filenames are unique across the whole vault, lowercase-kebab-case, because `[[wikilinks]]` resolve by name. Find a page by its name, never by assuming its folder.
- Pages are placed in their folder when they are created. Pages move only with the person present; a page the person moved stays where they put it.
- Every factual claim on a wiki page carries a link to the source page it came from. Synthesis that isn't in any source is marked as inference.
- Claude writes the wiki; the human writes in `raw/` (or anywhere, but Claude won't fight them for it).
- When new information contradicts an existing page, flag both versions — never silently overwrite what an earlier source said.

## Reference files

- `references/the-pattern.md` — why this works, and how it differs from RAG. Read before explaining the system.
- `references/schema-template.md` — the schema to fill in. Read in Step 4.
- `references/domain-presets.md` — page types and vocabulary for research, book, personal, business, competitive intel, course. Read in Step 1.
- `references/obsidian-setup.md` — the Obsidian walkthrough, and what to say when they don't use Obsidian. Read in Step 6.
- `references/grouping.md` — subfolders inside a type folder: choosing a grouping, placing pages, the owner's own reorganising, moving files safely. Read in Step 4 when the preset groups a folder, and in upgrade mode.
- `assets/templates/` — source, entity, concept, note templates to copy into the vault.
- `assets/vault/` — starter README, index, overview and log.
- `assets/webclipper-template.json` — importable Obsidian Web Clipper template that clips straight into `raw/inbox/`. Install it in Step 6.
- `assets/project-instructions.md` — the project instructions and the scheduled-task prompts to hand the person. Read and show in Step 8.
- `assets/about.md` — who wrote the plugin and where to reach them. Show its Opening in Step 0 and its Closing at the end.
- `references/locking.md` — the vault lock every writing skill takes. Setup creates its file in Step 3.
