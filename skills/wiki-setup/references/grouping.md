# Grouping — folders inside a type folder

A type folder (`wiki/sources/`, `wiki/concepts/`, a preset's `people/`…) can get **one** level of subfolders, declared in the **Grouped by** column of schema §3. This file is the procedure for choosing a grouping, placing pages, honouring the owner's own reorganising, and moving files safely. wiki-setup (upgrade mode), wiki-lint (checks 9 and 10) and every skill that creates a page refer to it.

## What grouping is for, and what it is not

- **Folders are for people.** Claude finds every page by name — through `index.md`, by search, by following links (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/links.md`). No skill depends on a page's folder, so a folder may only mirror what the page's frontmatter already says.
- **No editor is required.** The vault must work in Finder or Explorer, any text editor, GitHub, or Obsidian. Links are unique names, so any "find file by name" resolves them, and the index's group headings name each folder. Without Obsidian, folders matter more, not less — there is no graph and no backlinks pane.
- **Names stay unique across the whole vault, compared without regard to case.** A subfolder never makes a repeated name acceptable. That uniqueness is what lets a page move without breaking a single link.
- **Different kinds of thing are types, not groups.** "Separate people from organisations" means adding a type (schema §3), not a subfolder of `entities/`.
- **`raw/` is never grouped or reorganised.** It is immutable.

## The two keys

**`year of <field>`** — for a dated type that arrives in volume: journals, meeting notes, news, a field followed over years. The value is the first four digits of that field, when it begins with a four-digit year. Defaults: sources `published` — the date of publication, not the period covered; a decision type its `decided:` date; notes `created`. **The capture or ingest date is never a stand-in** — an undated page stays at the top of the type folder, and so does one whose field holds a placeholder such as `unknown`. (For the owner's own writing, ingest records the day it was written as `published:`, so journals do get a year — wiki-ingest-pending's *Dates* rules; a file from an imported folder that states no date gets the date git records for its last change.) A year page never moves on its own; if its date is later corrected, moving it is a proposal like any other.

**`subject`** — for vaults that span distinct areas: several projects, research subfields, a syllabus's modules, the books of a series. The value is the page's `subject:` — one lowercase kebab-case name from schema §3c, or none. §3c lists each subject as `` - `value` — [[hub-page]] — what belongs here, in one line ``: the value names the folder, and the hub is the page the subject is about — a project, an organisation, a module, a book, a research field — so a subject can be defined by a page in the wiki, not only by a sentence. The hub is optional and may be a link to a page nobody has written yet; it is an entity, concept or other named page, never a source, a note or a frame page. The value need not match the hub's name, so renaming the hub only repoints the link in §3c. An entry may leave the hub out: `` - `value` — what belongs here ``. `subject:` is carried by source pages and by pages of a type §3 groups by subject — nothing else: entity and concept pages in a flat folder don't carry it, and the owner's own page never does. It is set once, by the skill that creates the page, by *Assigning a subject* below. Ingest never changes it later; only the owner does, or a lint proposal they approve. A page that spans several subjects, or none, deliberately has no subject. A value not listed in §3c places nothing and is proposed under lint check 9. The field exists only in vaults whose §3c lists subjects: the plugin's templates don't carry it, and adopting a subject grouping — or a preset that starts with one — adds it to the vault's own `_meta/templates/`.

## Placement

A page with a value lives in `<type folder>/<value>/<name>.md`; without one, in `<type folder>/<name>.md`. The type folder is the one §3 names for the type (`source` → `wiki/sources/`). One level only: a subject that grows too big is split into two subjects, never nested.

**Every skill that creates a page places it by this rule, at creation** — ingest (and the `wiki-reader` agent), query and dream filing a note, lint creating a missing page, setup. Nothing tidies up afterwards: wiki-maintain and every unattended run never move a page.

## Assigning a subject

One rule, used by every skill that sets `subject:`, so ingest, the reader and lint reach the same answer from the same evidence. For a source page, in order:

1. **§3c's line**, when it plainly settles it from the source itself — the book, module, project or engagement the source says it is part of — or from its recorded `origin:`, for a subject defined as a subfolder of an imported folder. Where each page has one subject by its nature (a chapter's book, a lecture's module), this is the rule that decides. When the line settles it, the vote isn't run, and lint never proposes against it.
2. **Otherwise, the neighbourhood vote.** Take the named pages the source's body links — entity, concept and other named pages, resolved by name (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/links.md`) — leaving out the owner's page (schema §1, if the vault has one), frame pages, notes, other source pages, pages outside `wiki/` and names that don't resolve. Pages this ingest creates count; they lean to nothing yet. A page's **leaning** is the subject carried by more than half of the *other* source pages that link it in their body; a §3c hub leans to its own subject. A subject **wins** when at least half of the named pages linked lean to it and no other subject has as many — and not on the hub alone: at least one other page must lean with it.
3. **Otherwise, none.** The page stays at the top of the folder — honest, and lint revisits it.

The leanings come straight from the source pages, so nothing else needs labelling, and a page linked from several subjects leans to none and votes for none. To see them for the pages a source links:

```bash
for P in PAGE-ONE PAGE-TWO; do     # the named pages the source links, by name
  printf '%s: %s\n' "$P" "$(grep -rliF --include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*' \
      -e "[[$P]]" -e "[[$P|" -e "[[$P\\|" -e "[[$P#" . | grep -v '/THIS-SOURCE\.md$' \
    | tr '\n' '\0' | xargs -0 grep -l '^type: source' | tr '\n' '\0' \
    | xargs -0 awk 'FNR == 1 { fm = 0; n++; sub(/^\357\273\277/, "") }
        { sub(/\r$/, "") }
        FNR == 1 && /^---[[:space:]]*$/ { fm = 1; next }
        fm && /^---[[:space:]]*$/ { fm = 0; next }
        fm && /^subject:/ { v = $0; sub(/^subject:[[:space:]]*/, "", v); sub(/[[:space:]]+#.*$/, "", v); gsub(/["\047[:space:]]/, "", v); if (v != "") c[v]++ }
        END { printf "%d linking sources;", n; for (v in c) printf " %s %d", v, c[v] }')"
done
```

Each line says how many other source pages link that page and how many of them carry each subject; count only values §3c lists. A page no other source links leans to none — its line reads `0 linking sources`, or stays empty where `xargs` runs nothing on empty input (macOS). With the Grep tool instead: run the backlink search (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/retrieval.md`) for each page, keep the source pages, and read their `subject:` lines.

The report names the subject and its basis — §3c's line, the vote ("four of six linked pages lean to it"), or none. In a batch, a reader decides before the earlier sources' pages exist, so the main session re-runs the rule at that source's turn and reports a different answer rather than moving the file; lint check 9 proposes it.

**Pages of other types**, only where §3 groups their type by subject: at creation, §3c's line when it plainly settles it, otherwise none. A new page never inherits the subject of the source that created it — general pages pulled into the first subject that mentions them would then vote for it for good. Once two or more sources link the page, its leaning is the evidence lint uses.

## When the owner reorganises

Setup promises that Claude won't fight the person over where things live. So a mismatch between a page's folder and its frontmatter is only ever a **proposal** (lint check 9, propose part), resolved in the person's favour, and only in a type that §3 groups — in a flat type, any folder the person makes is fine and never a finding.

| What the person did | What lint proposes |
|---|---|
| Moved a page into another declared subject folder | set `subject:` to that folder |
| Moved a page back to the top of the type folder | remove `subject:` |
| Put pages in any folder that isn't one of the type's group values (a `to-review/` beside the year folders, a folder §3c doesn't list) | nothing — it is their folder |
| Moved a page into a different year folder than its date | moving it back, with them present — never editing the date |
| Moved a page into another type's folder (a concept under `entities/`) | retyping it (below), or leaving it; a type folder's name is never offered as a subject |

A declined proposal is logged on the lint entry as `- kept: <path> (placement)` and not raised again while that page's path and frontmatter stay as they are. When the person's move is accepted and `subject:` changes to match, lint also logs `- kept: <path> (subject)`, so the vote never argues with their folder. Claude never moves a page back on its own.

## Choosing a grouping

- **Flat by default.** Most vaults never need more; the index, search and links carry them.
- **At setup**, adopt a grouping only when it is known before any page exists *and* each page will have exactly one value by nature: `year of published` for a dated source type that arrives in volume, or subjects the stated purpose itself lists (the books of a series, a course's modules). Domain presets say which (`references/domain-presets.md`).
- **Later**, lint check 10 proposes one once a type folder passes the threshold in schema §10 (100 pages if it sets none): subjects around hub pages (*Proposing a subject*, below), or years from `published:`. It does not propose a grouping that would leave more than about a third of the folder at the top — for concepts in a single-domain vault, or clips that carry no date, grouping would not help. A proposed subject needs about ten pages; once declared, a subject keeps its folder until it is retired.
- **On every pass**, whatever the vault's size, check 10 also reports a grouped type whose top has grown past a third of its pages, and proposes filling in the missing values or going back to flat. Once a subject-grouped folder passes the threshold, it also proposes a new subject among the pages at the top, or a split of a subject whose own folder has passed it.
- A declined proposal is logged `- declined: grouping of <folder>`, `- declined: subject <value>` or `- declined: split of <value>`, and not made again until that folder has doubled.

## Proposing a subject

A subject is proposed around a **candidate hub**: a named page — not the owner's page, not a frame page — that about ten or more source pages without a subject (those at the top of the folder) link in their body. The preview settles by repetition, because the vote needs leanings and leanings need subjects:

1. **Seed:** the source pages without a subject that link the candidate take the proposed subject, provisionally. Pages that already have a subject keep it.
2. **Vote** every source page without a subject by *Assigning a subject*, counting the provisional subjects like real ones and the candidate as the hub.
3. **Repeat** step 2 until nothing changes — usually two or three rounds.
4. **Flag** the uncertain: seed pages the vote wouldn't have chosen, pages that won by a single page, and named pages linked by two or more sources outside the subject.

A **split** is previewed the same way inside one subject, with two or three of its most-linked member pages as candidate hubs; a source none of them wins stays in the parent subject. Nothing is written until the person approves; *Adopting a grouping* then applies it.

## Moving files

Used only with the person present: adopting a grouping, a subject renamed, merged or split, going back to flat, a type split, or a move they asked for. Take the vault lock (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`) after the approval and the pre-flight, hold it through the schema and frontmatter changes, the moves, the path updates and the index, renewing it every few dozen files with a count — `moved 60/310`, shown to the person too (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*) — and release it at the end — unless the skill running this, an upgrade, already holds it.

1. **A shell that runs where the vault's files are.** In Cowork that is the computer's shell with the folder mounted — not an isolated environment that cannot see the folder. Never emulate a move by writing a copy: where file deletion is off, that leaves two pages with one name. With no suitable shell, the change waits.
2. **Pre-flight, said to the person:** sync has settled; every app with the vault open is closed, on this device and on others (Obsidian, an editor, a sync client mid-upload); every file is downloaded — a page that reads as empty is never moved, since on a synced drive that usually means it isn't on disk yet; a git commit or a backup first is recommended — without git, a compressed copy of the vault (everything but `outputs/`) written into `outputs/` is enough: it stays on the person's machine and lint never reads it.
3. **Move one file first** and check it arrived and left. Then, per file:
   ```bash
   mkdir -p "$D" && [ ! -e "$D/$F" ] && mv -n "$S" "$D/" && [ -e "$D/$F" ] && [ ! -e "$S" ] || echo "NOT MOVED: $S"
   ```
   (`$S` the page, `$D` its new folder, `$F` its filename.) Every `NOT MOVED` is reported — usually a name that already exists there.
4. **Record each move as it happens:** right after a move is verified, append `old path → new path` to `_meta/moves/YYYY-MM-DD.md`, and say it — `→ old path → new path` (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`, *Showing progress*), the first few and then a count for a large move. The record is what an undo replays, what the check in step 7 reads, and what an interrupted run resumes from.
5. **Update everything that stores a path**, outside `raw/` and dotfolders: relative markdown links *to* a moved page, relative links *inside* a moved page (they now start from a different folder), and Obsidian canvases if the vault has any (`"file": "wiki/…"` in `.canvas` files). Rewrite a relative link only if it no longer resolves from its file's current folder, and compute the new path from that folder to the target's current location — never by adding or removing `../`, which breaks a link that was already fixed. `python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' <target file> <folder of the linking file>` prints it; without Python, work it out and check it resolves (`ls "<folder>/<new path>"`). Name the person's own files that will be edited before you edit them. Anything inside `raw/` that stores a path is listed, never edited. `[[name]]` links need nothing — that is why the wiki uses them.
6. **On resume**, skip pages already in place, and redo step 5 for every line already in the record — an interrupted run may have moved files without fixing their paths.
7. **Check again after a pause.** A sync service can bring a moved file back at its old path. The same name at the old and the new path is a duplicate name (lint check 1) caused by sync: report it, move neither.
8. Folders a move emptied are listed for the person to remove, or removed with their permission to delete.

## Adopting a grouping

From setup's upgrade mode, or on approval of a check 10 proposal:

1. **Preview:** how many pages go to each folder; which stay at the top, and why; for a year grouping, every page whose `published:` equals its `created:` or the date prefix of its raw file — probably a capture date recorded as the publication date — flagged as unverified and left at the top until the person confirms it; the `subject:` each page would get, grouped by folder with the uncertain ones flagged (nobody reviews three hundred rows one by one); and what Claude cannot see or update — paths stored outside the vault (editor workspaces and bookmarks, browser bookmarks, links from other apps), paths inside `raw/`, and for Obsidian users bookmarks, graph groups by path and Dataview or Bases queries that name an exact folder.
2. **Approval**, then the pre-flight (*Moving files*, step 2). Take the lock now.
3. **Schema:** the §3 Grouped by cell, with `—` for every other type; §3c for subjects, each with its hub where there is one (`` - `value` — [[hub-page]] — line ``), `subject:` in the vault's source template and in the templates of any other grouped type, and a line in §12.
4. **Frontmatter:** write the approved `subject:` values, or normalise `published:` dates, on every page concerned.
5. **Moves**, as above.
6. **Index:** rebuild the type's section with a subheading per group naming its folder. Any structure the index already had inside the group — cluster headings, a note on a batch — moves under the group heading, one level down, rather than being flattened.
7. **Verify:** every page where its frontmatter says; `index.md` in line; the record written.

Placement follows from frontmatter, so an interrupted adoption resumes from the record (*Moving files*, step 6). Log it as a `schema` entry — counts, not a list of files, plus the record's path. A grouping the person declines is logged too (`- declined: grouping of <folder>`), so lint doesn't offer it again until the folder has doubled:

```markdown
## [2026-09-20] schema | sources grouped by year of published
- moved: 212 pages into 9 year folders; 14 undated stay at the top
- record: _meta/moves/2026-09-20.md
```

## Other changes

- **Rename or merge a subject:** approval, then §3c, the `subject:` values, the moves. Renaming or merging only the **hub page** is not a subject rename: repoint the link in §3c and leave the values and folders alone.
- **Split a subject:** as above, with each page's new subject assigned in the preview.
- **Retire a subject:** remove it from §3c and from its pages; the pages go to the top.
- **Back to flat:** Grouped by → `—`, every page to the top of the type folder. The move records also let an adoption be undone exactly.
- **Split a type or retype a page** (people out of entities; a concept the person filed under `entities/`): a schema change for a split, with each page's `type:` assigned in the preview; rewrite `type:`, move the files, update the index. Never unattended; lint may propose a retype (check 9) but never applies one on its own.
