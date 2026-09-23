# LLM Wiki

**A second brain that Claude keeps for you.** You bring the sources and the questions. Claude reads, files, cross-references and keeps everything current, in plain markdown, in a folder you own.

A plugin for **Claude Cowork** (it works in Claude Code too). By **Dr. Markus Wuebben** ([github.com/mhwuebben](https://github.com/mhwuebben) · markus.wuebben@gmail.com), inspired by Andrej Karpathy's [LLM Wiki proposal](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

---

## Why this exists

You read something that matters: a paper, a strategy memo, a competitor's annual report, a long thread that finally settled a question. You highlight it, clip it, maybe write three lines about it. Six months later you need it. What you find is a folder of clippings, a notes app full of untitled notes, and a vague memory that someone once disagreed.

**Second brains rarely fail at capture. They fail at the bookkeeping.** Capturing is easy. The expensive part is everything after it:

- linking the new thing to the old things;
- noticing that this report contradicts the one from March;
- updating the summary page you wrote back then;
- retiring the claim that quietly stopped being true.

That work is tedious and never ends, so it's the first thing anyone stops doing. From then on the collection grows while the knowledge doesn't.

**Chatting with your documents doesn't fix it.** Upload a pile of PDFs and ask a question, and the model reads fragments and works out an answer from scratch, every time. Nothing it worked out yesterday is kept. A contradiction stays hidden in a passage it happened not to read. You get an answer, but nothing builds up.

## The idea

Karpathy's proposal turns this around. Don't make the model search raw documents at question time. Have it **compile** them into a wiki, and keep that wiki current as new sources arrive:

- **Raw sources are never touched.** They are the ground truth.
- **The model owns the wiki pages.** It writes them, links them and revises them.
- **A schema says how.** You and the model refine it together over time.
- **Three operations keep it going:** ingest, query and lint.

The work is split so each side does what it's good at:

- **You** choose the sources, ask good questions and decide what matters.
- **Claude** does the reading, summarising, cross-referencing, filing and bookkeeping. That is exactly the work that kills every second brain, and a model doesn't get bored of it.

**LLM Wiki makes that proposal something you can install and leave running.** It is fourteen skills and a vault of plain markdown. Every claim links to the source it came from. The wiki is re-checked on a schedule, and nothing gets written that you can't open and read.

## What it's like

**Monday.** You clip an article in your browser, and it lands in the vault's inbox. On the train you send Claude a link from your phone. Your laptop is closed, so the link waits on a backlog. It is picked up the next time a session can reach the folder.

**Tuesday.** You drop a competitor's annual report into the chat: *"add this."* Claude reads all of it and writes a page for it. Then comes the part that makes the whole thing work: it goes through **every page the report touches** and updates each one with the new claims, each linked to the report:

- the competitor's page,
- three concept pages,
- the overview.

Where the report contradicts an earlier source, both claims stay on the page with a flag. Nothing is quietly overwritten.

**Thursday.** You ask how their pricing has moved this year. The answer comes from pages that are already compiled, with every claim cited. It also says plainly what the wiki doesn't cover yet, instead of filling the gap with general knowledge. The answer was worth keeping, so it's filed as a note, and next time it's already there.

**Friday night.** A scheduled run does the routine:

- ingests whatever arrived during the week;
- fixes broken links and a drifting index;
- writes you a digest of what the wiki learned.

Anything that needs a judgement call waits for you.

**Once a month.** A dream pass reads across what's already filed. It looks for connections no page states yet, such as two sources that agree independently, or a question the vault can now answer. It proposes them in a report, labelled as inference and cited. You accept or reject each one, and a rejected one is never proposed again.

**One source should change many pages, not produce one summary.** That is the difference between a wiki that builds up and a folder that fills up.

## Why you can trust what it writes

- **Your sources are never edited.** Every page in `wiki/` can be rebuilt from `raw/` and the schema. Nothing can rebuild `raw/`, so nothing touches it.
- **Every claim is cited.** Each factual line on a page links to the source page it came from, and lint samples the citations against the sources behind them. Claude's own synthesis is labelled as inference.
- **Disagreements are shown.** Two sources that conflict both stay on the page, with what would settle it. The wiki never averages them.
- **Nothing is thrown away.** A claim a newer source replaces moves to the page's `## History`, with the date and the reason. A source that changes over time keeps every version and the story of what changed.
- **You decide the judgement calls.** Merging pages, deleting anything, moving files, accepting a connection: each waits for your yes. Unattended runs ingest what's waiting and apply only fixes that have one right answer.
- **One writer at a time.** A lock you can open and read shows what's running. A second session waits, and a crashed one is taken over.
- **Junk stays out.** Tickets, invoices, credentials and other people's personal data are stopped at the door, whatever way they arrive.
- **No lock-in.** It is plain markdown in your folder. Obsidian makes it pleasant to browse, but nothing depends on it. There are no hooks and no MCP servers, only instructions you can read.

## What the plugin adds to the proposal

The proposal is a page long, on purpose. Keeping a wiki healthy for months turned out to need a lot of rules. These are the main ones:

- **Propagation that closes the loop.** An ingest ends by checking that every page the source names actually cites it. Nothing leaves the inbox before that check passes.
- **Documents of any length.** A 60,000-word plan is mapped by its own headings, read section by section (in parallel where Claude can), and ingested in one pass: one source page, claims cited by section, every page it touches updated once.
- **Sources that keep changing.** A document captured again is compared with the previous copy, and only what changed is propagated. The page keeps a version history, so you can see how a position drifted and why.
- **Folders you already have.** A docs repository or an export is imported whole, with a record of where each file came from, and every scheduled run brings in what changed there.
- **A laptop that's closed.** Links sent from a phone wait on a backlog in the Claude project, and are drained first by the next session that can reach the folder.
- **Dreaming with a gate.** Dream passes propose only connections a careful reader could verify by putting two pages side by side. They never bring in outside knowledge, and they never apply anything themselves.
- **Several brains.** A work wiki, a personal one, a project's: questions read across all of them. For a question that matters there is **delphi**. Each wiki answers alone, then sees the others' quoted claims (not their conclusions). You get back what they agree on, where they conflict, what only one of them knows, and what none does.
- **Machinery you can check.** `wiki-doctor` checks the setup around the wiki: the schema version, the project instructions, the scheduled tasks and whether they're really running. **Debug mode** records wherever the plugin's own instructions made Claude guess, which is the fastest way to send back a bug in a plugin written in prose. An eval suite (`evals/`) checks that messages reach the right skill and that skills behave on a fixture vault.

## Get started

1. **Install.** In Claude Desktop, open **Cowork → Customize → Plugins → + → Add marketplace**, paste `mhwuebben/llm-wiki`, sync, and install **llm-wiki**. In Claude Code, run `/plugin marketplace add mhwuebben/llm-wiki`, then `/plugin install llm-wiki@mhwuebben-plugins`.
2. **Pick a folder:** an empty one, or one that already holds documents. In Cowork, click **Work in a project or folder** and choose it.
3. **Say** *"Set up an LLM wiki here — it's for [your topic]."* Setup asks two short sets of questions so the schema fits your domain, and one about the schedule near the end.
4. **Make it a project.** Create a Cowork project with this folder. Paste in the project instructions setup hands you, and add the scheduled task it gives you (weekly suits an active vault).
5. **Feed it.** Set up the Obsidian Web Clipper when setup offers it, clip one article, and say *"process what's waiting."* Then open the folder in Obsidian (**Open folder as vault**) and watch the graph fill in. Obsidian is optional; any editor works.

Once there are ten or so sources, add a monthly dream pass the same way. [How it works](docs/how-it-works.md) covers the rest: installing from a file, upgrading, forking, and everything about the folder.

## The skills

Claude picks the right one up when the task fits. You can also call one by name, or with `/`. An item is **pending** while it waits in `raw/inbox/`, and **ingested** once a source page points at it.

Getting sources in:

| Skill | What it does | When, and how |
|---|---|---|
| `wiki-capture-only` | Gets a source into `raw/inbox/` cleanly — URLs, PDFs, transcripts, screenshots, pasted notes — with provenance, after checking it is in scope, complete and not already there. Stops there: the item is pending. Also imports whole existing folders, keeps a backlog while the vault is out of reach, and sets up the Obsidian Web Clipper. | When you want to keep something for later without processing it now. Manual. |
| `wiki-capture-and-ingest` | Captures one or more new items, then ingests exactly those; anything else in the inbox stays pending. | Whenever you hand over a link or a file you want in the wiki now — the everyday route. Manual; the project instructions route a dropped link here. |
| `wiki-ingest-pending` | The core loop. Takes pending items — the ones you name, or everything in `raw/inbox/`, including clips and drops that arrived without Claude — and for each one reads it, writes its page, propagates the change across every affected page, checks that every page the source names really cites it, flags contradictions and moves the file out of the inbox. | When items are waiting: clips, drops, things you saved for later. Manual ("process what's waiting"), and inside `wiki-capture-and-ingest` and `wiki-maintain`. |
| `wiki-maintain` | The routine: bring in what is on the offline backlog and what changed in imported folders, ingest everything pending, lint (only the mechanical fixes on its own), and write a digest of what the wiki learned since the last run. Built to run unattended. | Weekly for an active vault, monthly for a quiet one. **Scheduled**, or by hand after a busy stretch. |

Using and looking after the wiki:

| Skill | What it does | When, and how |
|---|---|---|
| `wiki-query` | Answers from the compiled wiki with citations — following links in both directions, by name, in any folder — names the gaps, and files good answers back as notes. An answer turned into a deck, document or chart is filed as a note first, so the thinking outlives the file. | Whenever you ask. Manual; the project instructions route questions here. |
| `wiki-lint` | Fourteen health checks — including clips nobody ingested, sources that should never have been filed, and a sample of citations tested against the sources they cite — fixes on approval, plus the gaps worth researching next. Repairs; it doesn't synthesise. | Scheduled, inside every `wiki-maintain` run; manual on its own after a big batch or when the wiki feels messy. |
| `wiki-dream` | Consolidation, in one sitting: runs `wiki-dream-only`, then `wiki-dream-ingest` on the report it just wrote. | When you want new connections and are there to decide. Manual. |
| `wiki-dream-only` | Reads across what's already filed for connections no page states yet — bridges between subjects, questions the vault can now answer, sources that agree independently, pages that should link — and writes each as a cited, inference-marked proposal to a report. Applies nothing; adds nothing from outside the vault. Each pass leaves a short register of open hypotheses in the log — a loop seen twice, a connection one line short — which the next pass tests first. | After about ten new sources, which is what makes a pass worth running; the digest says when it's due. **Scheduled**, or manual. |
| `wiki-dream-ingest` | Works through a dream report with you: re-checks each finding against the wiki as it is now, puts it to you, files what you accept as notes, links and citations, and remembers what you rejected. | After a dream pass — the digest, the task's notification and `wiki-status` say a report is waiting. Manual; it needs you. |
| `wiki-status` | Where the wiki stands: size, what's pending, what's running, imported folders, what changed, what it still doesn't know — plus what is waiting for your decision. Read-only. | Any time. Manual. |
| `wiki-doctor` | Whether the machinery is sound: the vault's structure and scripts, the schema against the plugin version that built it, the project instructions, the scheduled tasks and their prompts, whether the folder is attached to them, and whether the routines have actually run. Reports problems with the text to paste for each fix. Read-only. | After a plugin update, when a scheduled run stops happening, when something is off. Manual. |
| `wiki-gaps` | What's missing and what to go and read. Read-only. | When deciding what to read next. Manual. |
| `wiki-help` | How to use the plugin: which skill does what, what to say to trigger it, how to turn something on, and what you're looking at — the vault's folders, or the ring of dots around the Obsidian graph. Answers from the plugin itself, never by changing the wiki. Read-only. | Whenever you wonder *"how do I …?"*. Manual; the project instructions route such questions here. |
| `wiki-setup` | Builds the vault: `raw/`, `wiki/`, `_meta/schema.md`, index, overview, log, templates. Interviews you first so the schema fits your domain, and hands you the project instructions to paste into your project, together with the scheduled-task prompt. Later, upgrades an existing vault after a plugin update. | Once per vault; again after an update. Manual. |

**Two sub-agents:**

- `wiki-reader` — reads one source in parallel when several are ingested at once, and drafts its page. Writes nothing else, so parallel readers can't clobber each other.
- `wiki-auditor` — audits a slice of the vault read-only during a lint pass and returns findings.

## Several brains

Most people start with one wiki per project, which is the default. Some keep several on purpose, because they have different scope rules, different owners, or different things that must never leave a folder. Each is then a *part* of one brain:

- **Reading crosses.** Questions are routed by what each wiki's schema says it is for, and a scope you name ("ask the research wiki") is followed exactly. A claim taken from another part is quoted with that part's name and id, because links only work inside one folder.
- **Writing doesn't.** A project that combines several wikis is a reading room. The only thing it writes is a capture into one wiki's inbox, which that wiki's own project then ingests. Ingest, lint, maintain, dream passes and upgrades run where their wiki is the only one connected, so nothing ever has to guess which vault it is in.

## How an item moves through the wiki

Blue boxes are skills; amber is where an item starts; green are the states it passes through; yellow diamonds are checks; red is where it stops; dashed boxes are comments.

```mermaid
%%{init: {"flowchart": {"nodeSpacing": 30, "rankSpacing": 45, "curve": "basis"}, "themeVariables": {"fontSize": "15px"}}}%%
flowchart LR
  %% ── where an item comes from ──────────────────────────────
  U(["You hand over a link, a file,<br/>a pasted text or a screenshot"]):::you
  A(["It arrives on its own<br/>Web Clipper · drag-and-drop<br/>· an imported folder, synced"]):::you

  U --> R{"Vault folder<br/>reachable?"}:::check
  R -- "no" --> BL[("BACKLOG<br/>wiki-backlog.md<br/>in the Claude project")]:::state
  BL -. "drained first by the next session<br/>that reaches the folder, and by wiki-maintain" .-> W
  R -- "yes" --> W{"Which wiki?<br/>only when several<br/>are connected"}:::check
  W --> CAP[["wiki-capture-only"]]:::cmd
  N4["Several wikis connected:<br/>capture only — the item waits<br/>in that wiki's inbox for its<br/>own project to ingest it"]:::note
  N4 -.- W
  CAP --> G1{"In scope?<br/>Complete?<br/>Not already in?"}:::check
  G1 -- "no" --> X["Not captured<br/>you are told why"]:::stop
  G1 -- "yes" --> P[("PENDING<br/>raw/inbox/")]:::state
  A --> P

  %% ── ingest ────────────────────────────────────────────────
  P --> ING[["wiki-ingest-pending"]]:::cmd
  ING --> C{"Already in?<br/>In scope?"}:::check
  C -- "out of scope" --> H["Stays pending<br/>until you decide"]:::stop
  C -- "unchanged copy" --> K["Skipped"]:::stop
  C -- "a newer version" --> RC["Re-capture<br/>diff against the previous copy<br/>+ a Version history line"]:::step
  C -- "new" --> INGEST
  RC --> INGEST

  subgraph INGEST["ingest — steps 3 to 5b write under the vault lock"]
    direction TB
    S1["1 · Read<br/>in full"]:::step --> S2["2 · Check in<br/>unless the schema says<br/>file first"]:::step --> S3["3 · Source page<br/>wiki/sources/"]:::step --> S4["4 · Propagate<br/>entities · concepts · overview<br/>contradictions flagged<br/>then close the list"]:::step --> S5["5 · Move out of the inbox<br/>text → raw/<br/>binary → raw/assets/<br/>index + log"]:::step --> S5b["5b · Verify<br/>no orphans · index in line<br/>frontmatter complete"]:::step
  end

  INGEST --> D[("INGESTED")]:::done
  D --> AFTER[["wiki-maintain<br/>wiki-dream<br/>wiki-query"]]:::cmd

  %% ── comments ──────────────────────────────────────────────
  N1["wiki-capture-and-ingest runs<br/>wiki-capture-only, then<br/>wiki-ingest-pending on just<br/>the items it captured"]:::note
  N1 -.- CAP
  N2["Called by<br/>• wiki-capture-and-ingest:<br/>the new items<br/>• you: the items you name,<br/>or everything<br/>• wiki-maintain: everything,<br/>on schedule<br/><br/>Several at once:<br/>one closing check per pass,<br/>nothing leaves the inbox<br/>before it has passed"]:::note
  N2 -.- ING
  N3["From then on it is linted and<br/>summed up in the digest,<br/>connected by dream passes,<br/>and cited in answers<br/><br/>Several wikis connected:<br/>answers read across them,<br/>delphi on request"]:::note
  N3 -.- AFTER

  %% ── legend ────────────────────────────────────────────────
  subgraph LEGEND["legend"]
    direction LR
    L1[["command — a skill"]]:::cmd ~~~ L2[("state of an item")]:::state ~~~ L3{"check"}:::check ~~~ L4["ingest step"]:::step ~~~ L5["stops here"]:::stop ~~~ L6["comment"]:::note
  end

  classDef cmd fill:#1d4ed8,stroke:#1e3a8a,stroke-width:2px,color:#ffffff,font-weight:bold
  classDef you fill:#fef3c7,stroke:#b45309,color:#78350f
  classDef state fill:#dcfce7,stroke:#15803d,stroke-width:2px,color:#14532d,font-weight:bold
  classDef done fill:#15803d,stroke:#14532d,stroke-width:2px,color:#ffffff,font-weight:bold
  classDef check fill:#fef9c3,stroke:#a16207,color:#713f12
  classDef step fill:#f1f5f9,stroke:#64748b,color:#0f172a
  classDef stop fill:#fee2e2,stroke:#b91c1c,color:#7f1d1d
  classDef note fill:#ffffff,stroke:#94a3b8,stroke-dasharray:4 3,color:#475569,font-style:italic
  style INGEST fill:#f8fafc,stroke:#1d4ed8,stroke-width:1px,stroke-dasharray:6 4,color:#1e3a8a
  style LEGEND fill:#ffffff,stroke:#cbd5e1,color:#475569
```

## Habits that make it work

- **Ingest the same day you capture.** An inbox that grows without being processed is the failure mode this pattern exists to avoid.
- **Stay in the loop early.** Review the first ten source pages; your corrections become conventions in the schema.
- **File your good answers.** A question answered in chat and nowhere else taught the wiki nothing.
- **Let it maintain itself on a schedule.** Duplicates and stale claims compound as fast as the knowledge does; `wiki-maintain` ingests, lints and tells you what changed in one pass.
- **Let it dream, then judge.** A monthly dream pass finds connections nobody asked for. Everything it proposes is inference — go through the report with `wiki-dream-ingest`, accept the ones that hold up side by side, reject the rest, and the rejections stop it proposing them again.
- **Let the schema change.** When you keep correcting the same thing, fix it in the schema instead.

## Learn more

[How it works](docs/how-it-works.md) has the rest:

- what lands in the vault, where, when and why;
- one source followed end to end;
- the Web Clipper and folder imports;
- the lock and the backlog;
- installing, upgrading, forking and editing the plugin.

The [changelog](CHANGELOG.md) lists what each release changed, and what to do after it for an existing vault.

## Credit and contact

The plugin is inspired by Andrej Karpathy's [LLM Wiki proposal](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (April 2026). The proposal supplies the core design: immutable raw sources, an LLM-owned wiki, a schema you and the model co-evolve, and the ingest / query / lint loop. This plugin builds it out for Cowork, adding the page conventions, propagation rules, maintenance checks and routines above.

Written and maintained by **Dr. Markus Wuebben** ([github.com/mhwuebben](https://github.com/mhwuebben)). Questions, ideas or something not working: markus.wuebben@gmail.com, or [open an issue](https://github.com/mhwuebben/llm-wiki/issues). MIT licence.
