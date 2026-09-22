# Answer formats

Match the format to the question. A table for a "why" question is as wrong as a paragraph for a six-way comparison. Most questions want prose with links; the formats below earn their complexity only sometimes.

## Prose with citations — the default

Answer first, support after, every claim linked. Two to five short paragraphs. Use it for "why", "how", "what happened", "should I".

## Comparison table

For "A versus B", "which of these", "how do they differ". Build it from the same attribute set for every item — and if the wiki's pages have a fixed section layout (competitors, methods, characters), the rows come almost free.

| | Acme | Globex |
|---|---|---|
| Model | seat-based — [[acme-q3]] | usage-based — [[globex-q3]] |
| Position | enterprise — [[acme-q3]] | mid-market — [[globex-q3]] |

Note where a cell is unknown rather than leaving it blank; blanks read as "no" and mislead.

## Timeline

For "when", "how did this develop", "what changed". Date, event, source, one line of significance. Pull dates from frontmatter `published:` and from claims, and say when a date is approximate.

## Briefing

For "get me up to speed on X" or something they'll hand to someone else. Structure: what it is, why it matters now, what's established, what's contested, what to watch. This is the format most worth filing back as a note — briefings age well and get reused.

## Quiz or review questions

For course and book wikis: generate questions from concept pages, with the answers linking back to the page that teaches it. Good for revision, and it surfaces which pages are too thin to answer from.

## Chart

When the answer is a shape — a trend, a distribution, a comparison of magnitudes. Take the numbers from the wiki or the raw data file, state the source of each series, and keep it simple. File the synthesis as a note first (*Slide deck or document*, below), save the image into `outputs/`, and embed it in the note. Don't chart three data points.

## Slide deck or document

When the answer is going to be presented or sent. **File the synthesis first**, as a note (*File the answer back* in SKILL.md): the argument, the evidence, the citations. Then make the deck or document from that note, into `outputs/`, with whatever this session offers for the format — a slides or document artifact (record its link on the note), or the environment's PowerPoint, Word or PDF skills if it has them; if it has none, say so and offer markdown. Write for a reader who hasn't read the sources: the conclusion first, three to five claims, citations kept but small, what is contested said plainly, gaps shown rather than smoothed over. The note is what survives the meeting; the file in `outputs/` is a render of it, so a later version is re-made from the note rather than edited by hand.

## Formatting rules across all of them

- Lead with the answer. Never make someone read three paragraphs of setup to find out whether the wiki knows.
- Links are the citations. Use page names, not "according to source 3".
- Mark inference explicitly wherever it appears, in any format.
- Keep chat answers scannable; save the long-form structure for what gets filed.
