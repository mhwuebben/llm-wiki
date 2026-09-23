# Re-captures

A **re-capture** is a newer copy of a source the wiki already holds: a synced docs folder where files changed, a web page captured again, a report in its second edition. It never becomes a second source page. It updates the one the wiki has, from what changed — and a whole folder of them, such as a documentation tree regenerated from start to finish, goes through in **one run**.

The old copy stays in `raw/`: immutable, the evidence behind every claim it once supported, and what the next change is compared with. The source page's `raw:` moves to the new copy, the old one goes onto `raw_previous:` (the last ten), and every capture keeps its line under `## Version history`.

## Finding the page

In this order — the first that answers wins:

1. **The same `origin:`** — the import record's name and the file's path in the folder — or, outside an import, the same URL, or the same title with the same author and edition or period.
2. **A move.** The record line is marked `(moved)`: it names the copy the old path last named, so the page whose `raw:` or `raw_previous:` names that copy is the one. Point its `origin:` at the new path.
3. **The copy's lineage.** The record's previous line for this path names a copy; the page whose `raw:` or `raw_previous:` names that copy is the page.
4. **Moved and changed** — *Moved and changed*, below.

Nothing found → it isn't a re-capture: a new source.

## What changed

**Compare, don't re-read.** Where a shell runs on the computer that holds the vault, compare there and move only the result: `diff -u raw/<previous copy> raw/inbox/<new copy>`, and `diff -u -w` to see whether anything but spacing changed. A binary is compared by its text where a tool can extract it (`pdftotext`, or the format's own converter); where none can, it is read whole.

For each re-capture, write a **change extract** to a draft folder outside the vault — the same working material a large source's sections produce (`references/large-sources.md`): the claims **changed** (old and new wording, each quotable), **added** and **removed**; the pages each touches; and anything the source itself says about why it changed — a changelog entry, a revision note, a commit message the import recorded. Or one line: **no claim changed**.

- **With sub-agents** — one `wiki-reader` per re-capture, in waves, in *change mode* (`${CLAUDE_PLUGIN_ROOT}/agents/wiki-reader.md`): given the diff, the new copy's path when the diff is most of the file, the source page, and the list of every page name.
- **Without** — write each extract yourself, one re-capture at a time, before the next.

A diff that is most of the file — a document rewritten in new words — means reading the new copy in full against the source page's key claims. That is what a rewrite costs; the rest of the run doesn't pay it.

## Applying it

- **No claim changed** → the source page gets its new `raw:` and its Version history line, `no claim changed`, and nothing else in the wiki is touched. These never count against the batch cap.
- **Claims changed** → merge the extracts first, then edit **each page once** with everything every re-capture changes on it (`references/batch-ingest.md`, step 3; `references/propagation.md`, *Working sensibly*). The old wording moves to the page's `## History`, "superseded by the new version of [[source]]" — a newer version of the same source supersedes, it doesn't contradict (`references/propagation.md`, *Updating an existing page*, rule 6).
- **Settled contradictions.** Re-check every contradiction callout that cites this source. Where the new version now agrees with the other side, the callout moves to `## History`, "settled by the new version of [[source]]". Where it still disagrees, it stays, updated to the new wording.
- **The cap.** Re-captures don't stop a run: their updates land on pages that already exist, one edit per page. The batch cap (`references/batch-ingest.md`, *Cap it*) counts the new pages the run creates, as it always has.
- **Dates.** `published:` becomes the date the new version states, or its git date from the record. With neither — a file synced before it was committed — keep the previous one; when a later sync records a git date for the same content, lint fills it in.

The Version history line, newest first — every part that applies, and the reason as the source gives it, or `reason not stated`:

```markdown
- 2026-10-02 · raw/2026-10-02-docs-pricing.md · 3 claims changed, 1 added · reason not stated · moved from docs/billing/pricing.md · resolves the contradiction on [[refund-policy]] · adopts the inference in [[note-pricing-tiers]]
```

The source's own reason, where it gives one, goes in quotes in place of `reason not stated`; a reason the source doesn't give is never supplied.

## Echoes

A newer version can say what the wiki itself concluded: documentation rewritten after the wiki flagged a contradiction, or regenerated from what the wiki holds. Before propagating, compare each changed or added claim with the wiki's own lines — contradiction callouts, lines marked as inference, notes, accepted dream findings, and claims on the same pages cited to *other* sources:

- **Resolves the contradiction on [[page]]** — the callout it settles.
- **Adopts the inference in [[page]]** — a line or note that was Claude's synthesis until now. The note gets a line too: *"Adopted in [[source]] on <date>."* The claim is now source-backed — the owner put it into their documentation — but this source is not independent confirmation of the inference, and a dream pass never counts it as such (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-dream-only/references/connection-types.md`, *Convergence*).
- **Restates [[page]], citing [[other source]]** — the same claim another source already made, arriving by way of the wiki. One source seen twice, not two agreeing.

These go on the Version history line, as what the wiki observed. They never say why the author changed the document; only the source can say that.

The wiki cannot tell whether adopting its conclusion was right. If its finding was wrong and the documentation now repeats it, these lines are what lets a person find that later.

## Moved and changed

A new item from an import, while the same record has paths that went `gone` without moving (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/references/folder-import.md`, *Keeping in step*), may be one of them — renamed and edited at once. Before writing a new source page, compare it with those gone files' last copies: the same file name or the same first heading, and then how much of the text the two share (`diff` on the shell). Most of it shared → the same source, moved: a re-capture of that page, `origin:` pointed at the new path, `moved from <old path>` on its Version history line. If the gone file's copy was never ingested — still pending, no page yet — there is no page to update: ingest the new copy as a new source and put the old one on its `raw_previous:` unread, as for several pending copies of one document. Unclear → a new source page; lint's duplicate check (check 3) proposes the merge later. A new source never absorbs a gone one on a guess.

## A reorganised folder

When a sync prints `RESTRUCTURE?`, or the unmatched new items and unmatched gone paths of one import both reach about twenty, match them all first, as above, and only then write new source pages. After matching:

- **With the person present** — show the matches and the leftovers, and get one yes.
- **Unattended** — ingest the matched ones as re-captures, capture nothing twice, and leave the unmatched new items pending, with the digest naming how many and why. Writing twenty or more new source pages for what may be moved documents would leave twenty duplicates for someone to merge by hand; this is the one case, besides the cap on new pages, where a run stops short of everything pending.

## Old copies in searches

Every earlier copy stays in `raw/`, so a search of `raw/` finds old wording too. `sh _meta/wiki-search.sh raw <term>` labels each hit — current, or an earlier copy of which page — and the skills never present a line found only in an earlier copy as current (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/retrieval.md`, *When the wiki seems to have nothing*).
