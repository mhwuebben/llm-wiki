# Several parts

A vault is a **part** of a brain, not the whole of it: a work wiki, a personal one, a project's. People keep them separate on purpose — different scope rules, different owners, different things that may leave the folder — and the separation is worth preserving. What crosses between them is **reading**, and nothing else.

**With exactly one part connected, none of this applies.** No routing, no extra questions, nothing slower. Read on only when a session can reach two or more folders that each hold a `_meta/schema.md` — and then read *A project that combines several wikis*, at the end, first: it says which skills write anything at all in such a session.

## Finding the parts

The parts are the connected folders holding a `_meta/schema.md`. Read each one's §1 — what it is for, whose it is, the questions it exists to answer — and its vault id. That is what routing reads, and it is one short section per part.

**Where the project instructions list the parts** — the several-wikis paragraph a project gets only when it deliberately combines them — that list is the expected set, and it is what makes an absent part visible: a part on the list whose folder isn't connected is **named as missing** in every answer it would have been consulted for — *"the personal part isn't connected, so this is from two of three"* — never silently left out. A connected vault that isn't on the list is still a part: use it, and mention once that the instructions don't name it. Without a list, discovery is all there is, and a folder nobody connected simply isn't in the brain.

Two folders whose schemas carry the same **vault id** are two copies of one vault, not two parts: say so, ask which is live, and use only that one for reading. Until the other copy is disconnected, write nothing into either — not even a capture. Writing to both is how a vault ends up silently forked (wiki-doctor, *Identity and parts*).

Past about four parts, say which you consulted and stop there rather than reading them all: the cost is a pass per part.

## The one rule everything rests on

**Read across parts. Write into one.**

`[[wikilinks]]` resolve inside a single folder, and the plugin's central promise is that every claim carries a link to the source page behind it. A claim written into part A that links a page in part B is a broken link in Obsidian and an unfollowable citation everywhere else. So:

- An answer may draw on every part it consulted.
- A **note, a line, a callout or any other write goes into exactly one part** — the one that owns the question — and from a session that reaches several parts it goes in as a **capture into that part's `raw/inbox/`**, never as a page edit (*A project that combines several wikis*, below). That part's own project ingests it.
- A claim taken from another part is quoted with its provenance, never linked: `— research brain (wiki-7f3a2c), transformer-scaling`. That format is what a later reader follows by hand, and it is what tells lint the citation is deliberately foreign rather than broken.
- A contradiction between two parts is **reported**, never filed as a callout on both: neither part owns it, and writing it into both would mean each holds a claim it cannot check. Say it in the answer, and offer to file the resolution as a note in one part — *Where a cross-part answer is filed*, below.
- **One log entry, in the part that was written to** — the capture's own line. A cross-part answer never leaves an entry in every part it read, and one that files nothing leaves none at all. A gap is said in the answer, naming which parts' inboxes were searched, since `sh _meta/wiki-search.sh pending` runs inside one vault at a time.
- Anything filed into part A must pass **A's** scope test (§1), whatever part it came from. Parts are often separated precisely because their scope rules differ; that is the boundary this protects.

## Routing a question

1. **A named scope wins, exactly.** One part, several named parts, or all of them. Use what was named and nothing else. Then say what was left out at name level — a search of page *names* in the excluded parts is allowed and is all that is allowed, since it reads no content: *"asked the research brain only; the personal brain has three pages whose names match — say the word and I'll ask it too."* A scope is honoured completely, including when the answer is thin.
2. **No scope: route by declared domain.** Each §1 says what its vault is for. A part whose domain covers the question is consulted; one that merely mentions the topic is not. Cheap tie-breakers in order: the index one-liners, then a name search.
3. **Ask only when it changes the answer** — two parts both plausibly own the question and would answer differently. Otherwise consult the ones that fit and say which.
4. **Always say which parts you consulted and which you skipped**, in one clause. An answer that quietly used one of three brains is the failure this rule exists to stop.

## Three shapes of question

Everything else in this file serves these. They are the same whatever the parts hold.

**1. One subject, several parts.** What does the brain collectively hold about it? Read each part that owns any of it, assemble one answer, attribute every claim to its part. The ordinary cross-part question.

**2. One question, several parts compared.** Ask each named part the same thing and set the answers side by side — what each holds, where they differ, what only one has. **Do not blend them into an average.** Two rules keep this honest:

- **Check they are comparable before comparing.** Nothing guarantees two parts are alike. Where they use different page types, different vocabulary or different periods, say so and compare only what lines up.
- **Small numbers are anecdotes.** Report per part first; mark any generalisation as inference and say how many parts it rests on. Calling something a pattern takes three instances in three **independent sources** — not three parts, which may be holding the same document: different author, different publisher or url, and neither source citing or summarising the other (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-only/references/connection-types.md`, *Pattern* and *Convergence*). Three parts that agree because one memo reached all three are one instance.

**3. Divergence over time.** The same subject in two parts, holding claims that disagree — sort them by the `published:` dates of the sources behind them. A source with no date is not guessed at and not sorted in: list those apart, as claims of unknown age, and say so. Where the claims stop agreeing is a date, and usually a document that one part holds and the other doesn't. That is the useful form of "what went wrong and where": not a verdict, but the point of divergence and the source that would have prevented it.

For shape 2, `delphi.md` is the deeper version — each part answers alone, then sees the others' quoted claims — with its own rule for which parts take part (a search in every part, not routing by declared domain), and it is opt-in on its own terms: run it when the person asks, or offer it when an answer visibly turned on which part was read first. Never start one because the question looks important.

## The same subject under different names

A subject is rarely named identically in two parts. Resolve it per part by name and aliases (`references/links.md`), and **say which name each part used** — that is itself information, and a wrong match silently invents agreement.

Where the owner confirms two names are the same subject, the alias belongs on each part that lacks it — but it is a page edit, so it is made from each part's own project, not from here (*A project that combines several wikis*, below). Say which alias goes on which page in which part, in one line each, so the person can ask for it there. Nothing in one vault comes to depend on another resolving, and the page should say why the alias is there — a name another part uses, not a sign that two pages here are the same thing, which is what lint check 3 looks for.

## Precedence, when parts disagree

**Which vault a claim came from is never the reason one wins.** Adjudicate between the claims, with the rules that already govern one vault:

- A claim quoted from a source page beats a synthesis note, which beats a line in an overview.
- A primary source beats a summary of it.
- For a time-sensitive claim, the newer source — recency is evidence, not proof, and never enough on its own.
- The more specific definition or population wins over the looser one, and often the conflict dissolves there: two parts measuring different things are not disagreeing.
- **Declared domain is the one legitimate tie-break.** A part whose §1 says the subject is its business is better evidence on it than a part that touches it in passing. That is authority the owner declared, not a preference between folders.
- **Agreement across parts is not automatically corroboration.** Two parts holding the same document, or two copies with the same content fingerprint, are one source (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-only/references/connection-types.md`, *Convergence*). Check author, url and `origin:` — and that neither source cites or summarises the other, which is the commonest false corroboration — before calling it independent support.

When it stays a real disagreement, say so, say what would settle it, and leave both claims standing. Never average them, and never let the part that answered first frame the answer.

## Citing across parts

In the answer, each claim carries the part it came from once — not on every line, but wherever the reader would otherwise assume one brain:

> Adoption stalled at 12% in 2026 — market brain (wiki-7f3a2c), globex-q3. Your personal notes put the same number at 18% for enterprises only — personal brain (wiki-91be04), market-sizing — which is a different population, not a conflict.

A note filed afterwards keeps the same shape: local claims as `[[links]]`, foreign claims as quoted text with the part's name and vault id. Say in the note's body that it draws on another part, so a reader who opens the vault alone knows why a citation doesn't resolve.

## Where a cross-part answer is filed

A note comparing several parts has no natural owner among them, and the rule that a note lives in one part still holds. **Filing it is a capture**: the answer, as written — its claims quoted, each with its part and vault id and the page and source behind it — lands in one part's `raw/inbox/` through wiki-capture-only, with `answer-from: <the vault ids of the parts it read>` in its provenance. It is **not** the owner's note and never becomes a source: it is Claude's synthesis, and a source page built on it would let inference be cited as evidence. That part's ingest files it as a note instead (wiki-ingest-pending, *An answer captured from a combined project*), under its own scope test. Say so when filing: *"it's in research-brain's inbox, and its next maintain run ingests it."* Which part, in order of preference:

1. **A part that exists for synthesis**, where the owner keeps one — a vault whose §1 says so. It is an ordinary part, so every rule here applies to it unchanged.
2. **The part that owns the question** — named by the person, or the one whose domain it was routed to.
3. **Nowhere** — the answer stands in the conversation. Filing is always an offer, never automatic, and a comparison that nobody will reread is better left unfiled. Nothing filed means nothing logged either.

A part kept for synthesis has no domain of its own, so routing never reaches it: it is read when it is named, or when its §1 says plainly what subjects it synthesises. Worth saying to the owner once, when one is first used.

## A project that combines several wikis

**A session is combined when it can reach two or more folders that each hold a `_meta/schema.md`** — a project that deliberately combines them, or one where an extra wiki is connected by accident. Everything above is about reading, and reading is what a combined session is for. **The only thing it writes into any vault is a capture into one part's `raw/inbox/`**, with its log line; that part's own project — its instructions, its scheduled tasks, its scope — does everything else.

The reason is simple: a write needs one vault it plainly belongs to. A capture has one — the person names it, or *Which part* in `${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/SKILL.md` settles it — and it lands in an inbox, where that part's ingest still runs its own scope test. Ingest, lint, maintain and a dream pass work on a vault's pages as a whole; in a combined session they have no natural target, and a scheduled one would be running with several folders attached. Each of them has a home already: the part's own project.

| Skill | In a combined session |
|---|---|
| wiki-query, delphi | works — this is what a combined session is for. Filing an answer is a capture: *Where a cross-part answer is filed*, above |
| wiki-status, wiki-gaps, wiki-help | work, read-only — status reports one line per part, never a sum |
| wiki-doctor | works, and matters most here: it is what finds a part missing, two copies of one vault, or a scheduled task naming a wiki skill — wiki-maintain, wiki-dream-only — with several parts attached |
| wiki-capture-only | works: each item into one part (*Which part*). A folder import is not a capture: it sets up an import record, so it runs from that part's own project |
| wiki-capture-and-ingest | captures, and stops there: the items stay pending until that part's own project ingests them — its scheduled wiki-maintain run, or the person asking there. Say so once |
| wiki-ingest-pending, wiki-lint, wiki-maintain, wiki-dream, wiki-dream-only, wiki-dream-ingest | refuse |
| wiki-setup | hands over the combined project instructions, and nothing else: a new vault or a schema upgrade runs from that part's own project |

**A refusal is one line, and says where to go instead**: *"This project combines three wikis, so nothing but captures is written here — run the lint from research-brain's own project."* It names the part when the person named one, or lists them when they didn't. It writes nothing — no report, no log line, no debug file — and it is the same attended or unattended: a scheduled run that finds several parts attached stops before its first write and says in its output which parts it found, so wiki-doctor and the person can see why nothing ran. There is no override for naming a part: a named part is exactly the case the part's own project already serves, and an override would bring back the question this rule removes.

**A debug file is the one other write** — `outputs/debug-YYYY-MM-DD.md` in the part a read-only run was pointed at, when debug mode is on (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`). It is not knowledge and touches no page.

**With one part connected, none of this applies**, and every skill works as it always did. A folder with no `_meta/schema.md` — an imported source folder attached to a task — is not a part and doesn't count.
