# Delphi mode

For one kind of question: an important one, where several parts of the brain hold relevant material and you want to know where they actually disagree rather than reading one blended answer. It asks each part independently, shows each of them what the others found, and assembles the result.

**Opt-in, never automatic.** It costs a pass per part. It runs when the person asks for it — "ask both brains properly", "delphi", "have them check each other" — or when a routine question turned out to sit across parts and the answer visibly depended on which one you read first; then offer it in one line rather than starting it. Everything in `parts.md` still holds: **reading crosses, writing does not**.

## Which parts take part

**Not the routing an ordinary question uses.** For a normal answer, a part is consulted when its §1 says the subject is its business (`parts.md`, *Routing a question*). Delphi exists to surface what a part holds that nobody expected it to — the *only one part knows* group is often the most valuable thing it returns — and a part's declared domain is exactly the thing that would hide that. So:

- **A named scope is used exactly**, as always.
- **Otherwise, every connected part runs a cheap search first** — the question's names and terms, and their aliases, with `sh _meta/wiki-search.sh search` in each part — and **every part where it finds anything takes part in round 1**, whatever its §1 says. A part where it finds nothing costs one search, not a round, and is named in the answer as searched and silent.
- **Declared domain only breaks a tie**: when more than about four parts have hits, the ones whose §1 covers the subject go first, and the rest are named as not asked.

Fewer than two parts with material on the question → there is nothing to cross-examine: answer normally and say so.

## Why the rounds are separated

A single pass over several vaults lets the first thing it reads frame everything after it, and the answer comes out smooth and slightly wrong — a blend, with the disagreements sanded off. Asking each part on its own, before any of them has seen the others, is what makes a conflict visible at all.

## Round 1 — each part answers alone

One pass per part, in parallel where sub-agents exist — one per part, each given only that part's folder, its schema, and the question. The `wiki-reader` agent is not this: use a general sub-agent with read-only tools, and tell it explicitly to write nothing.

**Make sure each one can reach what it reads.** Where sub-agents' file tools see the vaults — Claude Code, or a session working in the folders themselves — give vault paths. Where they don't, which is the usual case in Cowork with the vaults on the person's computer, copy what each needs into the session's workspace first: that part's `index.md`, its `_meta/schema.md`, and the pages its shortlist names, with the vault path each copy stands for (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, step 2, says how this is done for readers). A sub-agent handed a path it cannot open fails quietly, which in this mode looks exactly like a part that had nothing to say.

Each part returns, in this shape and nothing more:

- **Claims**, each quoted from a page, with its page name and the source page behind it. A claim it cannot quote does not travel.
- **What it cannot say** — the part of the question its pages don't reach.
- **Confidence per claim**: source-backed, or the part's own synthesis (a note, an overview line, an inference-marked line).

**Conclusions do not travel between rounds. Claims do.** This is the rule the whole mode rests on: show one part another's *prose conclusion* and you get agreement by rhetoric, which is how a Delphi round turns into consensus theatre. Round 2 shows quoted claims only.

## Round 2 — each part sees the others' claims

Give each part the claims the others returned — quoted, each labelled with its part and vault id, stripped of any conclusion — and exactly three questions:

1. **Does this contradict something you hold?** Quote your line and theirs.
2. **Does it confirm something independently?** Only if your source is a different document: same author, same url, the same `origin:` or content fingerprint, one citing or summarising the other, or a Version history line saying it adopts the wiki's inference or restates another source's claim, means one source seen twice, not two agreeing (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-only/references/connection-types.md`, *Convergence*).
3. **Does it fill a gap you named?** Then say what your pages can now add on top of it, and what still isn't answered.

A part may not revise a claim because another part disagrees. It may only add, contradict with a quote, or say the disagreement stands. Nothing is written to any vault during the rounds.

## Round 3 — assemble

The main session does this; no sub-agent decides it.

1. **Agreed, independently** — the claim, and the two or more distinct sources behind it, named by part. State the independence test you applied.
2. **In conflict** — both claims, quoted, with their parts. Resolve only by the precedence rules in `parts.md` (*Precedence, when parts disagree*): quoted source over synthesis, primary over summary, newer for time-sensitive claims, more specific population, and declared domain as the one tie-break. Say which rule decided it. Where none does, the conflict *is* the finding: present both, say what would settle it — usually a source nobody holds — and leave them standing.
3. **Only one part knows** — the claim with its part, and one line on why the others are silent: outside their domain, or a gap they named.
4. **Nobody knows** — the part of the question that stayed unanswered, which is often the most useful line in the answer.

Different definitions are the most common false conflict. Two parts measuring different populations, periods or units are not disagreeing, and saying so is worth more than a verdict.

## The answer

Lead with the answer, then the four groups above, in that order. Every claim carries the part it came from. Then, in one or two lines: which parts were asked, which were not and why, and how many rounds actually ran — a part that returned nothing in round 1 drops out, and saying so is honest, not a failure.

**Filing stays single-part** (`parts.md`): if this is worth keeping, it is captured into a single part's `raw/inbox/` — the one that owns the question, or a part kept for synthesis (`parts.md`, *Where a cross-part answer is filed*) — with foreign claims quoted and attributed rather than linked, and that part's own project ingests it under its own scope test. A cross-part contradiction is recorded in that note as a contradiction *between parts*, named as such — never as a callout written into both vaults.

## When not to use it

- A lookup, or anything one part plainly owns. The cost is a pass per part.
- A question whose parts would all answer from the same document — check that first; it is one source, and the rounds would dress it up as agreement.
- Unattended. It is for a question someone is waiting on; a scheduled run has no one to judge a standing conflict.
