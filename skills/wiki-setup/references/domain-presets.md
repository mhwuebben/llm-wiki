# Domain presets

Pick the closest one, then adapt. These change the page types, the folder names and the vocabulary — the rest of the structure stays the same.

Each preset also says how its type folders start out in schema §3's **Grouped by** column. Only groupings known before any page exists are set at setup; everything else starts flat, and lint proposes a grouping once a folder is big enough to show its shape (`references/grouping.md`).

## Research (papers, reports, a thesis-in-progress)

- Page types: `sources/`, `concepts/` (methods, mechanisms, findings), `entities/` (authors, labs, datasets, models), `notes/` (comparisons, literature gaps)
- `overview.md` holds a **working thesis** section that gets revised, with the evidence for and against it.
- Extra convention worth adding: every claim carries a strength marker — established / contested / single-study.
- Typical question: "what does the literature actually agree on about X?"
- Grouping: all flat. Subfields overlap too much to decide up front; lint proposes subjects if they emerge.

## A book (or a series, or a long course)

- Page types: `sources/` = one page per chapter, `characters/` (or `people/`), `concepts/` (themes, motifs, arguments), `places/`, `timeline.md`, `notes/`
- Ingest per chapter, as you read. Warn on spoilers: pages should note which chapter a fact comes from so the wiki can be read safely mid-book.
- `overview.md` tracks plot threads or the book's argument as it develops.
- Grouping: flat for one book. For a series, `sources/` by subject, one subject per book — each chapter belongs to exactly one, and §3c's line (the book the chapter is from) decides. No hubs by default; for a page per book, add a `books/` type to §3 and name those pages as the hubs.

## Personal (goals, health, psychology, journalling)

- Page types: `sources/` (journal entries, articles, podcast notes, test results), `concepts/` (patterns, habits, theories about yourself), `entities/` (people, places, projects), `notes/` (reviews, decisions)
- Add a `patterns.md` page at the vault root, beside `overview.md`: recurring loops the sources keep showing — in how the person works, decides, or gets stuck. Make it a standing page type in the schema: a row in §3 (`patterns` | `patterns.md` | — | the whole wiki | at setup; revised when a loop shows up in a third source) and `patterns` in §5's `type:` list. The page carries `sources:` like any synthesis page, and two sections:
  - `## Observed` — one line per loop, each with the source links it came from. **The bar is a third source:** before that, a loop lives as a line on the page it came up on. Ingest adds the line when the third sighting arrives; a dream pass looks for loops that have quietly reached it. A loop that stops being true is marked superseded with a date, not deleted.
  - `## Interpretation` — Claude's reading of the loops, every line marked *(inference)*. A later edit never promotes a line from here into Observed, and nothing here is ever cited as evidence for something else.
- Be careful and literal here. Record what the person wrote, keep interpretation clearly marked as inference, and don't diagnose. This vault is often the most sensitive one on the machine — mention that it stays local unless they choose otherwise.
- Grouping: `sources/` by year of published — journal entries accumulate, and the person's own writing is dated by the day it was written. Everything else flat.
- Set §11's Query line to not log unanswered questions: in this vault even a topic line can be private.

## Business / team knowledge base

- Page types: `sources/` (meeting transcripts, customer calls, docs, Slack threads), `entities/` (customers, people, teams, vendors), `concepts/` (processes, product areas), `decisions/` (one page per decision with date, context, outcome), `notes/`
- Give `decisions/` an ADR-style template — a `decided:` date in its frontmatter, the context, the alternatives considered, the outcome. Write it into `_meta/templates/` at setup; none is shipped.
- Stale-by-default: business facts rot fast. Set §11b's freshness window to a quarter, so lint flags a claim whose source is older than that once a newer source touches the same subject.
- Grouping: `sources/` by year of published, `decisions/` by year of decided. Entities and concepts flat.

## Competitive intelligence / market research

- Page types: `competitors/` (one page each, with a fixed section layout so pages are comparable), `concepts/` (market dynamics, pricing models), `sources/`, `notes/` (comparison tables)
- Fixed sections per competitor page make the comparison table generation trivial later.
- `overview.md` holds the current read on the market and what would change it.
- Grouping: `sources/` by year of published — market reports span several competitors, and each competitor page already gathers its own sources through the links to it. Everything else flat.

## Course notes / learning a subject

- Page types: `sources/` (lectures, readings, videos), `concepts/` (one per idea, written as an explanation you could revise from), `notes/` (worked problems, exam-prep summaries)
- Add `mastery: learning | shaky | solid` to concept frontmatter, so the lint pass can surface what to review. Use a field of its own — `status:` already records how complete the page is — and add it to §5 of the schema.
- Great pairing: ask the wiki to quiz you from its own concept pages.
- Grouping: `sources/` by subject, one subject per module of the syllabus (list them in §3c) — each lecture or reading belongs to one, and §3c's line (the module it is assigned to) decides. Concepts flat: most ideas are used across modules. No hubs by default. For a page per module (its aims and readings), add a `modules/` type to §3, name those pages as the hubs, and ingest the syllabus first so they have something to cite.
