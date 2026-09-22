---
name: wiki-status
description: Show the state of the LLM wiki in this folder — size, what is pending in raw/inbox, what is waiting for the owner's decision, what changed recently, its open questions and when the routines last ran — and whether the project instructions are current and the routines are actually running. Read-only; writes nothing. Use when someone asks how their wiki or vault is doing, what is in it, or what to do next with it. Use wiki-gaps for what is missing or what to read next, wiki-lint to check it for problems or repair it, and wiki-maintain to bring it up to date.
---

Report the current state of the wiki in the connected folder. Read, don't write.

1. Confirm this is a wiki: `_meta/schema.md` exists. If not, say so and offer wiki-setup.
2. Gather:
   - page counts by type (sources, concepts, entities, notes, and any the schema adds) and total — counted at any depth, since pages may sit in subfolders — and, for a type the schema groups, how many pages sit in each group
   - what is pending in `raw/inbox/`, grouped into items as wiki-ingest-pending's *Before you start*, step 3, does (empty files aren't items). A file still in `raw/inbox/` that a page's `raw:` or `asset:` already names is an interrupted ingest — or, while an ingest or maintain lease is live, an ingest still running; say which
   - apart from that, any file in `raw/` or `raw/assets/` that no source page's `raw:`, `raw_previous:`, `asset:` or `## Version history` line covers (usually something filed by hand) — not pending, but not in the wiki either. Ignore dotfiles, a folder's own `README.md`, files a `retired:` line in the log names, and attachments — a binary in `raw/assets/` named after a source's raw stem or embedded by a page or raw file, as lint check 11 defines them
   - imported folders: for each import record in `_meta/imports/`, the folder, how many of its files are still pending, and when it was last synced (its last `synced:` line)
   - the offline backlog, if this session can read it — in a Claude project, the doc `wiki-backlog.md`: how many lines, and how many need a file re-attached (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/offline-backlog.md`)
   - the vault lock: `sh _meta/wiki-lock.sh status`, or read `_meta/wiki-lock.md` — free, held (by what operation, until when, the last progress line), stale (more than a minute past `expires:` — the next writer takes it over) or missing (the next writer creates it)
   - the last five entries in `_meta/log.md`, leaving out `query` entries that only record a gap
   - **pages changed with nothing in the log to explain them** — pages whose `updated:` is newer than the newest log entry. A couple is the owner typing in Obsidian and isn't worth a line; a batch of them is work that ran outside the skills, and the note says how many and since when, with lint check 14 as the way to look properly. Never phrase it as the owner doing something wrong: their vault, their edits
   - `## Open questions` and `## Contradictions in play` from `overview.md`
   - when the last lint, the last maintain run and the last dream pass ran: the last `lint` entry; the last entry that names a digest file (`outputs/digest-YYYY-MM-DD.md`), normally a `maintain | digest` entry; and the last `dream` entry with a `scope:` line — a review entry has none and does not count
   - whether a dream report is still awaiting review — the latest `dream` entry that names the report carries an `unreviewed:` line
   - **the project instructions**, where this session can read them — in a Claude project the project's own instructions, in Claude Code the `CLAUDE.md` at the vault root — against the plugin's current text (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/project-instructions.md`). Three questions, in this order:
     1. Does the folder name in them match this vault?
     2. Do they name a skill this plugin doesn't have? That is the sure sign of an old copy, and the routing rule that names it does nothing.
     3. Is every rule of the current text there in some wording? Match on what a rule does, not on its words: the person may have rewritten one.

     **Their own additions are theirs.** A rule the plugin never wrote is never reported as missing, wrong or unnecessary. The one exception is a rule that plainly countermands a plugin rule — sources sent somewhere other than the wiki, sessions told not to read the schema or to skip the scope check — and that is named once, as something to look at, not corrected.
   - **the scheduled runs:** the tasks this session can list, and what the log shows — the last `maintain | digest` entry against §11's Maintain cadence, the last dream pass against its Dream line. A task the person keeps only on their own computer is in no list this session can read, so a missing task is never proof that nothing is scheduled; a cadence overdue in the log is. **In a task prompt this session can read, check the folder name against this vault's actual folder** — a renamed vault leaves the prompt naming a folder that no longer exists. The run still finds the vault by its `_meta/schema.md` (wiki-maintain, step 0), so this is stale text to tidy rather than a broken schedule — report it as a note, not a warning, and offer the corrected prompt rather than pasting four lines into a short report; the plugin cannot edit a task itself. Say in the same line whether the vault folder is attached to the task, where that is visible: a scheduled run with no folder attached does nothing at all.
   - **what is waiting for the person** — the decisions an unattended run could not make: the *needs a human decision* list of the latest digest, minus what the log shows handled since (a later `lint` entry that applied fixes, a later ingest of a held item); items held pending for being out of scope, or for review where §11 asks to review each source first; and a dream report awaiting review
   - whether a dream pass is due, by the Dream cadence in §11 of the schema — or, where it sets none, once ten or more sources have been ingested since the last dream pass (since setup, if none has run)
3. Report it in under fifteen lines, in this shape:

**Wiki:** {{purpose in a few words}} · {{n}} pages{{ — per group, for a grouped type}} · last activity {{date}}
**Pending:** {{n}} items in raw/inbox {{names}}{{ · interrupted ingest: names}}{{ · n files in raw/ that no source page covers}}{{ · n on the offline backlog}}{{ · imported: folder — n of m still pending, synced date}}
**Recently:** {{two or three lines from the log, in plain language}}{{ · running now: operation, last progress time — or stale since expires}}
**Open questions:** {{the two or three live ones}}
**Routines:** last lint {{date}} · last maintain run {{date}} · last dream {{date}}{{ · dream report awaiting review}}{{ · dream pass due}}
{{**Warning:** {{the instructions name folder "X", this vault is "Y"}}{{ · the instructions are out of date — what is missing, or a skill they route to that this plugin doesn't have; say "upgrade the vault" for the current text to paste}}{{ · the routine isn't running — last digest {{date}}, §11 says {{cadence}}; check the scheduled task, or run wiki-maintain now}}.}}
{{**Note:** {{no scheduled maintain run is visible to this session (one kept on your computer wouldn't be) — if there is none, run wiki-maintain {{cadence}} yourself, or create the task with the prompt wiki-setup gives}}{{ · the same for a dream pass, once the vault has ten or more sources}}.}}
{{**Waiting for you:** the decisions, counted by kind and named in a few words — e.g. "3 decisions from Sunday's digest (a merge, a contradiction, an out-of-scope clip) · 1 dream report" — and: say "go through them" to decide each on a card. Only when something is waiting; otherwise leave the line out.}}
**Suggested next:** {{the single most useful next action — wiki-ingest-pending or a wiki-maintain run if items are pending, draining the offline backlog if it has lines (wiki-capture-only), wiki-dream-ingest for a dream report awaiting review, a wiki-dream pass if one is due, or a question worth asking}}

End with this line — *LLM Wiki, a plugin by Dr. Markus Wuebben · questions: markus.wuebben@gmail.com* — the author and email that `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/about.md` names.

**"Go through them."** Status decides nothing itself. When the person asks, hand over in this order, each skill asking on its own cards: held pending items to wiki-ingest-pending; lint's judgement calls, starting from the latest lint report, to wiki-lint's proposing and applying steps; the dream report to wiki-dream-ingest.

Don't dump the index and don't list every page. If nothing is pending and nothing is stale, say the wiki is in good shape and name one question worth asking it.
