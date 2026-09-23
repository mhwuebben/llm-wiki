# Propagation

This is the step that makes a wiki a wiki. Work through it systematically — the temptation is to update the two pages you happen to remember and call it done.

## Build the touch list first

From your reading notes, list every entity, concept, claim and question the source touched. For each, search the vault for existing pages (including aliases and plural/singular variants) — by name, in any folder (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/links.md`). The name search is what answers *does this page exist?*; `index.md` is the orientation, not the register. It is read at the start of the run and once more when the lock is taken (wiki-ingest-pending, *Before you start*, step 6) — **and not again per source**: in a batch it is rebuilt once per pass (`references/batch-ingest.md`, step 5), so between rebuilds it doesn't know about the pages this run has created. Keep a running list of those instead, and check it alongside the search. You now have three buckets:

- **exists** → update
- **doesn't exist, clears the bar** → create
- **doesn't exist, doesn't clear the bar** → add a mention on the nearest existing page

A page the lookup finds outside `wiki/` is one the owner moved: don't edit it without asking. Unattended, add the claim as a line on the nearest wiki page, linking to it, and say so in the report.

The source page's `## Entities and concepts` section is this list, written down — entity, concept and other named pages, never other sources: every existing page on it gets its claim with a link to the source. Before bookkeeping you confirm that it did (*Close the list*, below), and lint re-tests it later (check 6).

Work the list top to bottom. Report the counts at the end; a source that touched two pages in a mature wiki usually means the list was built lazily.

**Notes are not on the list.** A note (`type: note`) is a dated answer, refreshed on purpose when its question comes up again — not rewritten by ingest. The one thing ingest adds to a note is the §7 contradiction callout, when the new source contradicts a claim the note makes — never a change to its answer or its `answered:` date. To find those notes, run the backlink search (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/retrieval.md`) on each page whose claim the source contradicts and keep the files with `type: note`. Notes don't count toward the ~15-page checkpoint below.

**A new page's name must be free across the whole vault** — `raw/` included, since Obsidian resolves links there too; pick a qualified name when it isn't (`caffeine-metabolism`, not a second `caffeine`). **New pages are placed at creation**, by schema §3: flat, or in the subfolder its grouping assigns (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/grouping.md`). Only source pages, and pages of a type §3 groups by subject, carry `subject:` — set once, by grouping.md's *Assigning a subject*; ingest never changes an existing page's subject, and a new entity or concept page does not inherit the source's.

## The promotion bar

Create a page when any of these is true:

- a second source now references it substantively
- one source says enough about it that someone would search for it by name
- it already has two or more `[[unresolved links]]` pointing at it from other pages
- the schema names it as a standing page type for this domain (e.g. every competitor gets a page)

Otherwise, a line on the nearest page, with a source link. Premature pages produce a graph full of stubs, which is worse than a dense graph of real pages.

**The bar can be cleared by something you still cannot write.** A term can be linked from five pages and defined by none of them — named in every source, explained in none. Creating that page means inventing the definition, which is the one thing this pattern exists to prevent. When that happens, leave it unwritten, record it as a **source gap** under `## What to read next` in `overview.md`: the page is blocked on a source nobody has captured, not on an edit nobody has made. Name the source that would unblock it. This is the one case where the promotion rule is correctly ignored, and the lint pass should stop re-reporting it as a fix.

## Updating an existing page

1. Add new claims in the section where they belong, each with its source link.
2. Revise, don't append blindly. If the new source sharpens an existing claim, rewrite the claim and cite both sources. Appending a near-duplicate bullet is how pages become unreadable.
3. Add the source to `sources:` in frontmatter and bump `updated:`.
4. Re-read the one-line summary at the top. If it's now wrong or thin, rewrite it — and if you rewrite it, update the matching row in `index.md` — in a batch, note it and let the one rebuild at the end carry it (`references/batch-ingest.md`, step 5).
5. Never delete substantive content. Superseded material moves to a `## History` section with the date and the reason.
6. **A newer version of the same source supersedes; it does not contradict.** When the claim changes because the document changed — a re-captured doc, a synced docs folder, a second edition — rewrite the claim, and move the old one to `## History` with the date and "superseded by <the new capture>". The contradiction callout in *Contradictions* below is for two **different** sources disagreeing; using it here files a change of fact as a dispute, and the vault ends up arguing with its own history. Where the older version's claim is still cited elsewhere, follow the citations and update those pages too — that is what the re-ingest's diff is for.

## Contradictions

A new source disagreeing with an old one is the highest-value event in the wiki. Handle it, don't smooth it:

```markdown
> [!warning] Contradiction
> [[source-a]] (2024) reports 40% adoption. [[source-b]] (2026) reports 12%.
> Different populations — A surveyed enterprises, B all firms. Probably not a real conflict; see [[adoption-measurement]].
```

Then:

- Put the callout on both pages involved — the two pages that carry the conflicting claims, as schema §7 says — and on both source pages as well when it's material. On a source page, say "this source" rather than linking the page to itself.
- Add a line to `## Contradictions in play` in `overview.md`, as schema §7 asks — and to `## Open questions` as well when resolving it would change the wiki's central thesis.
- Try to resolve it, briefly: different definitions, different populations, different dates, or a real disagreement. Say which. An unresolved contradiction with a hypothesis attached is far more useful than a bare flag.
- Never delete the older claim because the newer source is newer. Recency is evidence, not proof.

## Links

- Every new page gets at least one inbound link from an existing page, in the same pass. No orphans created by ingest.
- Link the first substantive mention on a page, not every occurrence.
- Deliberate links to pages that don't exist yet are fine — they're a to-do list the lint pass can read. Just don't create twenty in one ingest.
- When you rename a page, search for its old name and fix the links — `[[old-name]]` and any relative markdown link to `old-name.md`. Obsidian does this automatically for edits made inside Obsidian, not for edits made by an agent or in another editor.

## Overview

Ask three questions after every source:

1. Does the synthesis in `## What we know so far` need revising?
2. Did this answer an open question, or open a new one?
3. Did it change the contradiction list?

If the vault has a `patterns.md`, ask a fourth: did this source show a loop for the third time? Then it goes under `## Observed` there, with all three sources.

Most ingests move at least one of these. Update the file if so; leave it alone if honestly not.

## Close the list

The last step of propagation, before any file moves or the log is written. It turns "I think I updated everything" into a check.

**A missing section fails the check.** A source page with no `## Entities and concepts` at all — a reader wrote its own headings, an older page predates the rule — has nothing to test, so every test below passes and nothing was ever verified. That is not a pass: write the section from the touch list of this pass, then run the check. For a **source already ingested** — an interrupted ingest, a re-capture — the list has to be reconstructed from what the page's body names and the pages that cite it, which is judgement, not bookkeeping: with the person, do it and show it; unattended, leave the page alone and name it in the report, as lint check 10 does ("never applied unattended — choosing what a source adds is judgement"). A source that genuinely adds to no page says `none` and says why — `none` is a claim, an absent section is a hole. Lint check 10 lists the pages that have no section; check 14 treats an absent one exactly as it treats `none`.

1. **Every named page that got a claim from this source is on the list.** Compare the pages you edited or created in this pass with the source page's `## Entities and concepts`. A page that received a claim and isn't listed gets its line — what the source adds to it. A page you only touched to add a link to a new page doesn't belong there.
2. **Every page on the list cites the source in its body.** Two commands: `sh _meta/wiki-search.sh backlinks <source> <alias...>`, then `sh _meta/wiki-search.sh cites -a <alias> … <source> <the listed pages the search returned>` — the same aliases the search used, or a page citing the source by one of them reads as a gap that lint won't reproduce, which prints `cited:` or `NOT CITED:` per file (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/retrieval.md`, *The script* — the greps it runs are written out there for a vault with no shell). A listed page missing from the result, or reported `NOT CITED`, has a gap. It is the test lint check 6 runs, so what passes here passes there. Leave out what check 6 leaves out: other source pages, notes, names that still don't resolve after `${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/links.md`'s fallbacks (forward links), and names two files share (report those; write to neither). For a page outside `wiki/`, which you don't edit, confirm instead that the nearest wiki page carries the line.
3. **Close every gap now:** add the claim with its source link (*Updating an existing page*, above) — or, if the source turns out to say nothing substantive about that page, take the page off the list.

**In a batch, close the whole pass in one check.** Steps 1 and 3 stay per source: each source has its own list, and each gap is that source's to close. Step 2 is what runs once — **one backlink search for the whole pass**, its `SLUG` patterns covering every source slug in it, instead of one search of the vault per source. That union search is a filter, not the verdict: the filenames it returns don't say which slug matched, so what it proves is absence. A page on any source's list that the search didn't return has a gap. For the pages it did return, the *Does this page cite that source?* test still decides per source — one run per source over just the files that source listed, which greps those files and not the vault. So this still matches what lint check 6 runs per source.

**Nothing leaves the inbox until the pass's check has passed**: a source with an open gap keeps its item in `raw/inbox/` until the gap is closed, so a pass interrupted before the check still looks interrupted (wiki-ingest-pending, Step 5; `references/batch-ingest.md`, step 4).

Only then go on to bookkeeping. Say it in the report: how many named pages the list holds, and that each cites the source. Lint check 6 remains the safety net for interrupted ingests and for edits made since.

## Splitting and merging

**Split** when a page covers two things people would ask about separately, or when it's past schema §10's **Split past** line (~1,200 words if it has none) with distinct sections — counting neither `## History` nor `## Version history`, which are ledgers and grow by design. Split along the natural seam, leave a one-line summary and a link behind on the parent, and fix inbound links. **Each half takes its own `## History` entries** — the ones about the claims it now carries — so what a page used to say stays with the page that says it now.

**A `## History` that outgrows its page** — longer than the rest of the page, or past half the Split past length — is not a reason to split the page, and never moves into another subject's page: its record belongs to the claims it records. Name it in the report for lint, which proposes moving the older entries to a companion page (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-lint/references/checks.md`, check 10).

**Merge** when two pages are the same thing under different names. At ingest, do the safe half: fold the content and its citations into the better-named page, repoint the inbound links, add the dead name to the survivor's `aliases:`, and report the now-redundant page. **Do not delete it** — deleting a page is a lint-pass decision with a human in the loop. The lint pass removes the husk once someone approves it. Record the merge in the log either way. Don't leave a redirect stub unless the schema calls for one — the alias is what makes future ingests find it.

## Working sensibly

- **One read and one write per page** — decide everything that changes for a page before you touch it — and, in a batch, **one command per pass** rather than one call per page. The round trips are what make a long ingest slow; the reading isn't.
- **Read the pass's pages in a single command**: `for f in …; do printf '=== %s\n' "$f"; cat "$f"; done`, about ten pages or 50 KB at a time, splitting into a second command past that. Without a shell, read them one at a time.
- **Write them back in one command too**, whose script re-reads each page from disk and edits it in place — never writing back a copy read earlier, which is the lock's rule as well (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *Taking it*). That re-read is what the file tools' *changed since you read it* guard does for you, so make each edit fail loudly instead of quietly: anchor it on text that must be there, verify the page actually changed, print `ok <path>` per page, and stop at the first failure instead of running on through the rest. Those `ok` lines are your own proof the edits landed; the person's list is unchanged and stays yours to write (`references/batch-ingest.md`, *Showing progress*) — a `+` line for a page created, none for a page merely updated. Use the file tools for a single page, for a delicate rewrite, and wherever there is no shell.
- **A command that stopped halfway has written some pages and not others.** The `ok` lines say which. Say so, finish the rest — with the file tools if the script is what failed — and don't move anything out of `raw/inbox/` until the pass's list is closed, which is what keeps the state readable from outside.
- Check what you wrote after a run of edits — a missing frontmatter field or a broken link is cheap to fix now and annoying later.
- If the touch list runs past ~15 pages, say so at the check-in (Step 2), before the lock is taken and any page changes — that's a big change to their vault and they may want to watch it happen. With the check-in skipped, say it in the report.
