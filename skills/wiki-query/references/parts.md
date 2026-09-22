# Several brains

A vault is a **part** of a brain, not the whole of it: a work wiki, a personal one, a project's. People keep them separate on purpose — different scope rules, different owners, different things that may leave the folder — and the separation is worth preserving. What crosses between them is **reading**, and nothing else.

**With exactly one part connected, none of this applies.** No routing, no extra questions, nothing slower. Read on only when a session can reach two or more folders that each hold a `_meta/schema.md`.

## Finding the parts

The parts are the connected folders holding a `_meta/schema.md`. Nothing is configured and nothing has to be listed: read each one's §1 — what it is for, whose it is, the questions it exists to answer — and its vault id. That is what routing reads, and it is one short section per part.

Two folders whose schemas carry the same **vault id** are two copies of one vault, not two parts: say so, ask which is live, and use only that one. Writing to both is how a vault ends up silently forked (wiki-doctor, *Identity and parts*).

Past about four parts, say which you consulted and stop there rather than reading them all: the cost is a pass per part.

## The one rule everything rests on

**Read across parts. Write into one.**

`[[wikilinks]]` resolve inside a single folder, and the plugin's central promise is that every claim carries a link to the source page behind it. A claim written into part A that links a page in part B is a broken link in Obsidian and an unfollowable citation everywhere else. So:

- An answer may draw on every part it consulted.
- A **note, a line, a callout or any other write goes into exactly one part** — the one that owns the question.
- A claim taken from another part is quoted with its provenance, never linked: `— credbl brain (wiki-7f3a2c), kpi-driver-tree-v4`. That format is what a later reader follows by hand, and it is what tells lint the citation is deliberately foreign rather than broken.
- A contradiction between two parts is **reported**, never filed as a callout on both: neither part owns it, and writing it into both would mean each holds a claim it cannot check. Say it in the answer, and offer to file the resolution as a note in the part that asked.
- **One log entry, in the part that was written to** — or, where nothing was filed, in the part that owns the question. A cross-part answer never leaves an entry in every part it read, and a `- checked:` line for a gap says which parts' inboxes were searched, since `sh _meta/wiki-search.sh pending` runs inside one vault at a time.
- Anything filed into part A must pass **A's** scope test (§1), whatever part it came from. Parts are often separated precisely because their scope rules differ; that is the boundary this protects.

## Routing a question

1. **A named scope wins, exactly.** "Ask the credbl brain", "just my personal notes", "both work brains" — use those parts and no others. Then say what was left out at name level — a search of page *names* in the excluded parts is allowed and is all that is allowed, since it reads no content: *"asked the credbl brain only; the personal brain has three pages whose names match — say the word and I'll ask it too."* A scope is honoured completely, including when the answer is thin.
2. **No scope: route by declared domain.** Each §1 says what its vault is for. A part whose domain covers the question is consulted; one that merely mentions the topic is not. Cheap tie-breakers in order: the index one-liners, then a name search.
3. **Ask only when it changes the answer** — two parts both plausibly own the question and would answer differently. Otherwise consult the ones that fit and say which.
4. **Always say which parts you consulted and which you skipped**, in one clause. An answer that quietly used one of three brains is the failure this rule exists to stop.

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

> Adoption stalled at 12% in 2026 — credbl brain (wiki-7f3a2c), globex-q3. Your personal notes put the same number at 18% for enterprises only — personal brain (wiki-91be04), market-sizing — which is a different population, not a conflict.

A note filed afterwards keeps the same shape: local claims as `[[links]]`, foreign claims as quoted text with the part's name and vault id. Say in the note's body that it draws on another part, so a reader who opens the vault alone knows why a citation doesn't resolve.

## What stays single-part

Only reading crosses. **Capture, ingest, lint, maintain and status each work on one vault** — capture asks which and recommends one (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/SKILL.md`, *Which part*), ingest takes the part it was given or the one whose inbox holds the items, and lint, maintain and status report on the one they were pointed at. Two of them are different by nature: wiki-setup asks where a *new* vault goes and what belongs in it, and wiki-doctor enumerates every part on purpose, since checking them is its job. **A dream pass stays inside one part too**: every finding it proposes must be filable, with both halves linked, and a connection whose halves live in two vaults cannot be. What a cross-part question turns up belongs in an answer, and in a note in the part that asked.
