---
name: wiki-dream-ingest
description: Work through a dream report with the person and apply what they accept — re-check each finding against the wiki as it is now, put the survivors to the person (missing links as one batch, everything else one at a time), file the accepted ones as synthesis notes, links, citations or pattern lines, and log what was accepted and rejected so it is never proposed again. Takes the report named, or every report awaiting review, oldest first. Needs the person; never runs unattended. Use when someone wants to review, go through, decide on, accept or apply a dream report, or says "ingest the dreams". Use wiki-dream for a new pass followed by this review in one sitting, and wiki-dream-only for a pass that only writes the report.
---

# Wiki Dream Ingest

A dream report is a list of proposals: connections the vault's pages imply but no page states. Every one of them is inference. This skill is where the person decides which of them become part of the wiki — and it applies exactly those, nothing else. It is to a dream report what wiki-ingest-pending is to a pending source.

**It needs the person.** Every accepted finding is a new claim in the wiki, and only the owner can accept a claim. A scheduled or otherwise unattended run of this skill writes nothing: it says which reports are awaiting review and stops.

## Before you start

1. Read `_meta/schema.md`, `index.md`, `overview.md`, `patterns.md` if the vault has one, and `_meta/log.md`.
2. **Pick the reports.** Named → exactly those. Otherwise every report **awaiting review** — the latest `dream` entry that names the report carries an `unreviewed:` line — oldest first. None → say so, and offer a new pass (wiki-dream).
3. **The vault lock** (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`) is taken at Step 3, not before: deciding can take a while, and no other session should wait on a conversation. Steps 1 and 2 only read.

## Step 1 — Re-check every finding

A report can be days old. First skip what is already settled: a finding an earlier `review of` entry for this report accepted, rejected or dropped is done — only its undecided findings come back. For each remaining finding, read the pages it names as they are now and run it through the gate again (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-only/SKILL.md`, *The gate every finding must pass*): an ingest since may have written the connection already, changed one of its halves, or retired a page. Drop what no longer passes, with the reason — that is a `dropped:` line, not a rejection.

**With several reports in play, merge the survivors before putting anything to the person.** Passes are written weeks apart and never see each other's proposals, so two reports can reach the same page from different directions. After each report's re-check, set the surviving findings side by side and look for two things:

- **Repeats** — the same connection twice, in different words. Decide it once, on the oldest report, and mark the later one `dropped: <n> <kind> | [[a]]↔[[b]] | reason: decided on <report>`.
- **Conflicts** — two findings that cannot both be applied: opposite conclusions from the same two pages, two notes that would say different things about one claim, or a link one proposes and another argues against. These are the interesting ones, and putting them to the person separately is how a vault ends up holding both. Show the pair together as one decision, with the date of each pass and what changed in between — usually a source arrived, and the newer finding is the better one, but not always.

A conflict that turns out to be two true things that can't both be followed is not a review problem: it is a productive tension, and belongs on the pages as one, from whichever report proposed it first.

## Step 2 — Put it to the person

- **The shape:** one line per surviving finding, by its number in the report — its kind, the connection in one sentence, and the proposed action. Then go through them: **missing links as one batch**, everything else one finding at a time, most consequential first, and last the gaps the report hands to wiki-gaps, as one batch. An undecided gap doesn't keep the report open. Show both quoted halves and the step for any finding the person wants to look at before deciding.
- **Their answers:** *accept*, *reject* — ask for the reason in a line, since it is what stops the next pass proposing the same thing again — or *not now*, which leaves the finding `undecided:` and free to come back. "Accept 1 and 3, reject 2" is a fine answer.
- **Edits:** the person may reword a conclusion or narrow it. If the edit changes what is claimed, re-check both halves against the new wording before applying; a claim the halves no longer support is not applied.
- **Stopping part-way** is fine: apply what was decided, log it, and leave the rest undecided — the report stays awaiting review until every finding has an answer or is dropped.

## Step 3 — Apply what was accepted

Take the vault lock, re-read each page right before changing it, apply every accepted finding, then release it and log (Step 4). Say each new note as it lands: `+ wiki/notes/<slug>.md` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*). If the lock is held, say by what and until when, and apply once it frees — the decisions are already made.

- **A note** for a bridge, an answered question or a tension: from `_meta/templates/note.md`, in `wiki/notes/` (or wherever schema §3 places notes), tagged `synthesis`. Replace the template's "Asked" line with "Surfaced by a dream pass" and the date of its report; set `created:`, `updated:` and `answered:` to today, the day the note is written. Set `status: developing` — a synthesis is never `solid` on its first day. Every claim carries a link to the page it came from and to the source page that page cites for it; the connecting step itself is marked *(inference)*. Link the note from every page it bridges, so it is found from the topic and not only from the index.
- **A missing link:** add the wikilink where the first page discusses the second's subject. That is the whole edit to the text; do not rewrite the surrounding sentence.
- **A convergence:** add the second source's citation beside the claim it corroborates. That, and revisiting the page's `status:` if two independent sources now carry what one did, are the only edits this skill makes to an existing claim — the proposal named both.
- **A pattern:** add it to `## Observed` in `patterns.md` with all three sources. Not a note — the page already exists.
- **Anything handed to lint** — a contradiction, a stale claim, an answered-but-open question, a frontmatter slip — is not applied here: the pass already listed it on its `for lint:` line, which the next lint reads. Add a `- for lint: <check> | [[page]] | <what>` line to this entry only for something the re-check newly turned up.
- **A gap:** if accepted, add a line under `## What to read next` in `overview.md` naming the missing fact. Name a source only if a page in the vault already names one — choosing one from general knowledge is wiki-gaps' job. A gap the person doesn't decide on is logged `undecided:`, not `rejected:`.
- **`overview.md`:** when an accepted finding's proposal named an overview line, add that line to "What we know so far", marked *(inference)* and linked to the note. Nothing goes into the overview that the person did not see in the proposal. Add lines; don't rewrite existing ones. An open question it answers stays where it is, marked "— answered: [[note]]"; one it half answers is marked "— partly answered: [[note]]" and stays open.
- **Every edited page:** bump `updated:`. On a page in `wiki/` or `patterns.md`, add any newly cited source to `sources:`; on a page in `wiki/`, refresh its row in `index.md`. A new note gets a row under Notes. `overview.md` needs neither.

Never edit a source-backed claim beyond adding a citation. Never delete. Never touch `raw/`.

## Step 4 — Log and report

Append one entry per report worked through (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *The log*):

```markdown
## [2026-09-22] dream | review of outputs/dream-2026-09-21.md
- accepted: 1 bridge → [[note-slug]]; 3 missing links ×3
- rejected: 4 tension | [[c]]↔[[d]] | "c's goal is d's anti-pattern" | reason: different populations, not a real tension
- dropped: 2 answered "open question X" | reason: [[e]] already answers it since [2026-09-22] ingest
- undecided: none
- closed: near "job cadence" — settled by finding 1
```

- **No `scope:` line** — a review is not a dream pass, and the next pass is still measured from the entry that wrote the report.
- **Keep the `rejected:` shape** — `rejected: <n> <kind> | [[a]]↔[[b]] | "<the connection>" | reason: …`, with the finding's number in the report — with the person's reason when they gave one. It is what wiki-dream-only reads to avoid proposing the same thing again.
- **Close the register entry a finding came from.** A `watch:` or `near:` line on an earlier dream entry that this decision settles — accepted, rejected or dropped — gets a `closed:` line here repeating that entry's quoted short name and naming the finding. Otherwise the next pass spends its first and cheapest reads re-testing a hypothesis that is already answered (wiki-dream-only, *Before you start*, steps 2 and 3, part 1). A finding left `undecided:` closes nothing. `closed:` is the register's line; `retired:` in the log means a retired source page, which is lint's.
- **A report is closed** when every finding is accepted, rejected or dropped — gaps aside. With findings left `undecided:`, add `- unreviewed: <the report>` to this entry: the latest entry naming the report then still marks it as awaiting review.
- Fill in the report's *Decisions* section with the same lines.

Then tell the person what changed in the wiki — the notes filed, the links and citations added, what the overview now says — in a few lines.

## Rules

- Apply only what the person accepted, exactly as proposed or as they reworded it. Nothing from outside the vault, and nothing a finding didn't propose.
- Never edit a source-backed claim beyond adding a citation. Never delete. Never touch `raw/`.
- Anything the report hands to lint or to wiki-gaps is not applied here, except a gap the person accepts, which goes under `## What to read next` in `overview.md` as above.
