---
name: wiki-status
description: Show the state of the LLM wiki in this folder — size, what is pending in raw/inbox, what is waiting for the owner's decision, what changed recently, its open questions and when the routines last ran. Read-only; writes nothing but a debug file when debug mode is on. Use when someone asks how their wiki or vault is doing, what is in it, or what to do next with it. Use wiki-doctor when something is not working or the setup itself may be wrong — instructions, scheduled tasks, folders, plugin version — wiki-gaps for what is missing or what to read next, wiki-lint to check the pages for problems or repair them, and wiki-maintain to bring it up to date.
---

Report the current state of one wiki — the connected folder, or the part named where several are connected. Read, don't write.

0. **One vault at a time.** With several connected — each a part of one brain (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`, *A project that combines several wikis*) — report on the one the person named. None named → one line per part (pages, pending, awaiting a decision, last maintain run), then offer the full report for one of them. Never add their numbers together: two parts are two wikis with two schemas. Anything the report would suggest doing — ingest, lint, maintain, a dream pass — is done from that part's own project; say so rather than offering it here.
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
   - **the setup, in one line:** whether the project instructions, the scheduled tasks and the vault's own scripts are in order is wiki-doctor's subject, not this one's. Where this session can cheaply tell — the instructions or a task point at a different vault id, a task's prompt names a skill this plugin doesn't have, `_meta/wiki-search.sh` is missing, the log shows the routine hasn't run within §11's cadence — say so in one line and point at wiki-doctor. A folder name that has gone stale is not one of these: the id is what identifies the vault, so that is tidy-up, and doctor's business. Don't diagnose here.
   - **what is waiting for the person** — the decisions an unattended run could not make: the *needs a human decision* list of the latest digest, minus what the log shows handled since (a later `lint` entry that applied fixes, a later ingest of a held item); items held pending for being out of scope, or for review where §11 asks to review each source first; and a dream report awaiting review
   - whether a dream pass is due, by the Dream cadence in §11 of the schema — or, where it sets none, once ten or more sources have been ingested since the last dream pass (since setup, if none has run)
3. Report it in under fifteen lines, in this shape:

**Wiki:** {{purpose in a few words}} · {{n}} pages{{ — per group, for a grouped type}} · last activity {{date}}{{ · other parts connected: {{names}}, not counted here}}
**Pending:** {{n}} items in raw/inbox {{names}}{{ · interrupted ingest: names}}{{ · n files in raw/ that no source page covers}}{{ · n on the offline backlog}}{{ · imported: folder — n of m still pending, synced date}}
**Recently:** {{two or three lines from the log, in plain language}}{{ · running now: operation, last progress time — or stale since expires}}
**Open questions:** {{the two or three live ones}}
**Routines:** last lint {{date}} · last maintain run {{date}} · last dream {{date}}{{ · dream report awaiting review}}{{ · dream pass due}}
{{**Setup:** {{what looked wrong, in one clause — the routine hasn't run since {{date}} though §11 says {{cadence}} · the instructions point at another vault · a script is missing}} — run wiki-doctor for the whole picture and the fixes. Only when something looked wrong; otherwise leave the line out.}}
{{**Waiting for you:** the decisions, counted by kind and named in a few words — e.g. "3 decisions from Sunday's digest (a merge, a contradiction, an out-of-scope clip) · 1 dream report" — and: say "go through them" to decide each on a card. Only when something is waiting; otherwise leave the line out.}}
**Suggested next:** {{the single most useful next action — wiki-ingest-pending or a wiki-maintain run if items are pending, draining the offline backlog if it has lines (wiki-capture-only), wiki-dream-ingest for a dream report awaiting review, a wiki-dream pass if one is due, or a question worth asking}}

End with this line — *LLM Wiki, a plugin by Dr. Markus Wuebben · questions: markus.wuebben@gmail.com* — the author and email that `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/about.md` names.

**"Go through them."** Status decides nothing itself. When the person asks, hand over in this order, each skill asking on its own cards: held pending items to wiki-ingest-pending; lint's judgement calls, starting from the latest lint report, to wiki-lint's proposing and applying steps; the dream report to wiki-dream-ingest.

Don't dump the index and don't list every page. If nothing is pending and nothing is stale, say the wiki is in good shape and name one question worth asking it.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs. That file is the one thing this skill writes; everything else about it stays read-only.
