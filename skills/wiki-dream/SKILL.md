---
name: wiki-dream
description: Dream and decide in one sitting — consolidate what the wiki already knows by running wiki-dream-only for a new pass (connections no page states yet: bridges between subjects, open questions the vault can now answer, sources that independently agree, pages that should link, patterns seen a third time), then wiki-dream-ingest to work through exactly that report with the person and apply what they accept. Use when someone asks for new insights or connections, what their notes add up to, or to consolidate or dream over the wiki, and is there to decide. Use wiki-dream-only for a pass that only writes the report — the one to schedule — wiki-dream-ingest for a report already written, wiki-query to answer a specific question, wiki-gaps to find what to go and read, and wiki-lint to clean up or merge duplicates.
---

# Wiki Dream

A new dream pass and its review, back to back. Run both skills, in order, in full — load them rather than working from a remembered version:

1. **wiki-dream-only** — the pass: read across the vault, test each connection against the gate, write the report to `outputs/`.
2. **wiki-dream-ingest** with **exactly the report step 1 just wrote** — re-check, put each finding to the person, apply what they accept, log the decisions.

**Several wikis connected?** Then neither step runs (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *A project that combines several wikis*): say in one line to dream from that part's own project, and write nothing.

**A report already awaiting review?** Offer to work through it first with wiki-dream-ingest — its findings are left out of a new pass while they are open. Either way, then run the pass.

**Nothing found?** A pass with zero findings is a result, not a failure — on a young vault, the honest one. Say so; there is nothing to ingest.

**Unattended?** A scheduled run of this skill runs step 1 only and says the report awaits review: step 2 needs the person, and only they can accept a claim into the wiki. The routine to schedule is wiki-dream-only.

**Lock:** step 1 writes only a new report and a log line, so it needs no vault lock. Step 2 takes it when it applies decisions (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`).

**Log:** wiki-dream-only's pass entry, then wiki-dream-ingest's review entry.

**Report once, at the end:** what the pass found, what the person accepted, and what the wiki now says that it didn't — with anything handed to lint or to wiki-gaps.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs.
