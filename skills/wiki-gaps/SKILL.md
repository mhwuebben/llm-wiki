---
name: wiki-gaps
description: Find what the wiki does not know yet — the questions it is close to answering and the sources worth going and finding. Read-only; writes nothing. Use when someone asks what is missing from their wiki, what to read next, or where their knowledge is thin. Use wiki-lint instead when they want the vault cleaned up rather than extended, and wiki-dream for connections between what is already there.
---

Work out where this wiki is thin and what would fix it. Focus on the topic named in the request if there is one, otherwise the whole vault.

1. Read `_meta/schema.md` (what is this wiki *for*), `overview.md` and `index.md`, and the `- gap:` lines of `query` entries in `_meta/log.md` — questions the wiki couldn't answer. Re-test each against the wiki as it is now; a later ingest may have filled it.
2. Look for:
   - open questions that have sat unanswered
   - topics resting on a single source — fragile knowledge
   - sources everything cites that the vault doesn't hold
   - strongly argued positions with no counter-argument anywhere in `raw/`
   - clusters that nearly connect, where the linking analysis has never been written — name them; writing it is a dream pass's job (wiki-dream)
   - density that doesn't match the stated purpose — background everywhere, nothing on the decision they said this wiki is for
   - gaps that questions keep running into — a gap asked about on several different dates ranks above one that came up once
3. Report at most seven items, ranked by what would change the wiki's picture most. For each: the gap, why it matters, and the specific thing that fills it — a named source, a search, a person to ask, or a question to put to the wiki.
4. Offer to do the top one now: fetch and ingest the source, or answer the question and file it.

Don't pad the list. Three real gaps beat seven plausible ones.
