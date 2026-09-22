---
name: wiki-doctor
description: Check that the machinery around an LLM wiki is sound — the vault's own structure and scripts, the schema against the plugin version that built it, the project instructions, the scheduled tasks and their prompts, whether the vault folder is actually attached to them, and whether the routines have really been running. Reports problems with the exact text to paste for each fix. Read-only; writes nothing. Use when something about the wiki is not working, after installing or updating the plugin, when a scheduled run failed or stopped happening, or when someone asks whether their wiki is set up correctly. Use wiki-status for how the wiki itself is doing (pages, pending, what is waiting), wiki-lint for problems inside the wiki's pages, and wiki-setup to apply a schema upgrade this skill recommends.
---

# Wiki Doctor

Everything the wiki needs in order to run is outside the wiki: a schema the current plugin understands, two small scripts, project instructions that route, scheduled tasks whose prompts still point at the right place and have the folder attached. None of it is visible from the pages, and all of it fails quietly. This skill looks at exactly that, and at nothing inside `wiki/` — the pages are wiki-lint's job and the vault's contents are wiki-status's.

**Read-only. It writes nothing** — not a page, not the schema, not a log entry. Each finding carries the text to paste or the skill to run: schema and script repairs go to wiki-setup's upgrade mode, page problems to wiki-lint. The two things nobody but the owner can do — attaching a folder to a task, creating a task — are named as theirs.

## What it checks

Work through the seven groups. Skip a check whose input this session cannot read, and **say it was skipped rather than passed**: a scheduled session usually cannot list tasks or read project instructions, and "no problems found" from a run that could not look is the one output worse than none.

**1. The vault is a vault.** `_meta/schema.md` exists and is readable. `raw/`, `raw/inbox/`, `wiki/`, `_meta/` and `outputs/` exist. `index.md` and `overview.md` exist. `_meta/templates/` holds the templates the schema's §3 page types need. Nothing here → this is not a set-up vault: offer wiki-setup and stop.

**2. Identity.** Schema §1 carries a **vault id** (`**Vault id:** wiki-…`), which is what the instructions and the task prompts point at, because folder names change. Missing → wiki-setup's upgrade adds one. Present, but another connected folder's schema carries the same id → two copies of one vault: name both folders and ask which is live, because two sessions writing two copies is the one failure the vault lock cannot catch.

**3. Version.** Schema §12 records the plugin version the vault was last set up or upgraded with. Compare it with this plugin's `.claude-plugin/plugin.json`. Behind → say which version, name the two or three things that release changed for an existing vault (`${CLAUDE_PLUGIN_ROOT}/CHANGELOG.md`, the **Upgrading an existing vault** paragraphs), and recommend wiki-setup's upgrade mode. Ahead, or missing → report it as unknown, not as current.

**4. The scripts.** `_meta/wiki-lock.sh` and `_meta/wiki-search.sh` exist and match the plugin's copies in `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/`. Run `sh _meta/wiki-lock.sh status` and `sh _meta/wiki-search.sh pending`: a script that is present but fails to run is worse than a missing one, because every skill assumes it works. Report a stuck lock — held, long past `expires:`, by a session that is plainly gone (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *Stale leases*) — with what it says it was doing. No shell in this session → say the scripts could not be run.

**5. The project instructions**, where this session can read them — in a Claude project the project's own instructions, in Claude Code the `CLAUDE.md` at the vault root — against `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/project-instructions.md`:

1. Do they point at this vault — by id where they name one, by folder name otherwise?
2. Do they name a skill this plugin doesn't have? That is the sure sign of an old copy, and the routing rule that names it does nothing.
3. Is every rule of the current text there in some wording? Match on what a rule does, not on its words: the person may have rewritten one.

**Their own additions are theirs.** A rule the plugin never wrote is never reported as missing, wrong or unnecessary. The one exception is a rule that plainly countermands a plugin rule — sources sent somewhere other than the wiki, sessions told not to read the schema or to skip the scope check — and that is named once, as something to look at, not corrected.

**6. The scheduled tasks.** List the tasks this session can see. For each that names a wiki skill:

- **Does its prompt point at this vault?** By id where it names one; otherwise by folder name, which a rename makes stale — a run still finds the vault by its schema file (wiki-maintain, step 0), so that is a line to tidy, not a broken schedule.
- **Is the vault folder attached to the task?** Where that is visible. This is the one that silently stops everything: a scheduled session with no folder attached can do nothing and cannot even ask, because granting access needs someone at the computer.
- **Is the prompt current?** Compare with *The scheduled task* in the project-instructions asset. Give the corrected text.
- **Does the cadence match** the Maintain and Dream lines in schema §11?

Then, from the log, **whether the runs actually happen**: the last `maintain | digest` entry against §11's Maintain cadence, the last `dream` entry with a `scope:` line against its Dream line. A task kept only on the person's own computer is in no list a session can read, so a missing task is never proof that nothing is scheduled — an overdue cadence in the log is.

**7. The connections.** Which folders this session can reach: the vault itself, and each folder an import record in `_meta/imports/` names. A record whose folder is unreachable means its syncs have silently stopped — say since when, from its last `synced:` line. In a Claude project, whether `wiki-backlog.md` exists and how many lines it holds: a backlog with old lines means sessions have been unable to reach the vault for a while.

## The report

Under twenty lines. Problems first, each with its fix; then one line saying what was checked and found sound; then what was skipped and why.

```
**Vault:** credblaiBrain · id wiki-7f3a2c · schema built with 3.1.0 · plugin 3.3.0

**Problems**
1. The weekly maintain task has no folder attached — every run since 2026-08-30 did nothing. Attach credblaiBrain to the task in the Claude desktop app; nobody else can do this.
2. Its prompt still names "EOBrain". Replace it with: <the corrected prompt, in a block>
3. The schema is two versions behind. 3.2.0 added the version-history section and the log's checked: line. Run wiki-setup in upgrade mode; it proposes each line and changes nothing you don't approve.

**Sound:** vault structure · both scripts run · lock free · project instructions current · 2 imported folders reachable
**Not checked:** nothing
```

Rank by what is broken now over what will break later: a task that cannot run beats a schema line that is missing. Say plainly which fixes need the person — attaching a folder, creating a task, pasting instructions — and which are a skill they can run. End with the single most useful next step.

**Clean is a real answer.** A vault with nothing wrong gets three lines and no invented advice.

## Unattended

A scheduled run of this skill can check groups 1–4 and 7 and usually not 5 and 6 — it cannot read project instructions or list tasks. Run it anyway, report what it could see, and say clearly what was skipped. It never writes, so it is safe on any schedule; once a month alongside the routine is plenty.

End with this line — *LLM Wiki, a plugin by Dr. Markus Wuebben · questions: markus.wuebben@gmail.com* — the author and email that `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/about.md` names.
