# Following links

A link in this wiki need not be clickable for a person — in most editors other than Obsidian a `[[wikilink]]` is plain text. It must always be followable by Claude, in any vault, with no editor involved. This is the one procedure for that. wiki-query uses it to follow links; lint check 1, ingest's "does this page exist?" test, wiki-dream-only's shortlist and the `wiki-reader` agent refer to it, so every skill agrees on where a link points.

It rests on one rule from schema §4: **every page name is unique across the vault**, without regard to case or folder. A link is a name, never a path — so pages can sit in any subfolder and move without a link breaking.

## 1. Read the target

Links take these forms — all count, wherever they appear: in the body, in tables, in embeds, and in frontmatter (`sources: ["[[x]]"]`).

| Written | Target |
|---|---|
| `[[name]]` | `name` |
| `[[name\|label]]` | `name` |
| `[[name#Heading]]`, `[[name#^block]]` | `name` — then that section of it |
| `![[name]]` | `name` (an embedded page) |
| `![[chart.png]]` | `chart.png` — an attachment, not a page |
| `[[ name ]]`, `[[folder/name]]`, `[[name.md]]` | `name` — non-standard; lint check 1 proposes the plain form |
| `[text](../concepts/name.md)`, `[text](name.md#section)` | `name` — a relative markdown link, as other editors write them |
| `[text](Name%20With%20Spaces.md)` | `Name With Spaces` |
| `[text](https://…)` | not a vault link — ignore |

Inside a table the pipe is escaped — `[[name\|label]]` — and means the same as `[[name|label]]`.

A `[[…]]` inside inline code or a fenced code block is an example, not a link — Obsidian doesn't resolve it either, so skip it. The search commands here can't tell the difference; drop any hit that sits between backticks.

To normalise: drop `|label` or `\|label`, drop `#heading` or `#^block`, trim spaces, drop any folder path and the `.md`, and decode `%20` as a space.

## 2. Resolve it by name

Against the **page set** — every `.md` file in the vault except those in `raw/`, `outputs/`, `_meta/` and dotfolders. That is `wiki/` at any depth, the root's frame pages (`index.md`, `overview.md`, a preset's `patterns.md` or `timeline.md`), and any folder the owner made or moved a page into. Resolve all the targets you chose in one command, without regard to case (to *search the text* of the page set instead, `references/retrieval.md` gives the matching `grep` options):

```bash
find . -type f -name '*.md' -not -path './raw/*' -not -path './outputs/*' -not -path './_meta/*' -not -path '*/.*' \
  | grep -iF -e '/TARGET-ONE.md' -e '/TARGET-TWO.md'
```

(With the Glob tool instead: `**/TARGET.md`, then drop hits under `raw/`, `outputs/` and `_meta/`; the Glob tool may match case exactly, so also try the name in lowercase.)

- **One hit** → that page. For a `#heading` target, go to that section — but still read the whole page: the contradiction callout is usually at the bottom.
  - A hit **outside `wiki/`** that isn't a frame page is a page the owner moved, or one of their own notes. Follow it and read it; don't edit it without asking; never create another page with that name. When a new source has something to add to it and nobody is there to ask, put the claim as a line on the nearest wiki page, linking to it, and name it in the report or digest. Lint reports such a page once and logs it (`- outside: <path>`); check 8 keeps its index row and check 1 treats links to it as resolved.
- **Two or more hits** → a duplicate name. Report it, follow neither, never guess. (Lint check 1 proposes the fix.)
- **No hit** → try, in order:
  1. **The file-name form** — lowercase, spaces as hyphens (`[[Acme Corp]]` → `acme-corp`). A hit is followed, and the link reported to lint as one to repoint (check 1 keeps the wording as a label: `[[acme-corp|Acme Corp]]`). Obsidian would not resolve the original.
  2. **An alias** — an entry in some page's `aliases:` equal to the target, ignoring case. Frontmatter only, whole entries only, so body text and partial names never match:
     ```bash
     find . -type f -name '*.md' -not -path './raw/*' -not -path './outputs/*' -not -path './_meta/*' -not -path '*/.*' \
       | tr '\n' '\0' | xargs -0 awk -v t='TARGET' '
     function clean(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); gsub(/^["\047]|["\047]$/, "", s); return tolower(s) }
     FNR == 1 { fm = ($0 ~ /^---[[:space:]]*$/); al = 0; if (fm) next }
     fm && /^---[[:space:]]*$/ { fm = 0; next }
     !fm { next }
     /^aliases:/ { al = 1; l = $0; sub(/^aliases:[[:space:]]*\[?/, "", l); sub(/\][[:space:]]*$/, "", l)
       while ((sub(/^[[:space:],]+/, "", l) || 1) && match(l, /"[^"]*"|\047[^\047]*\047|[^,]+/)) { if (clean(substr(l, RSTART, RLENGTH)) == clean(t)) print FILENAME; l = substr(l, RSTART + RLENGTH) }
       next }
     al && /^[[:space:]]*-[[:space:]]/ { x = $0; sub(/^[[:space:]]*-[[:space:]]*/, "", x); if (clean(x) == clean(t)) print FILENAME; next }
     { al = 0 }'
     ```
     It reads frontmatter only (a `---` block starting on the first line), both `aliases: [A, B]` — quoted entries with commas included — and the list form. Some versions of `awk` only lower-case ASCII, so a name with a capital `Ä`, `É` or `Ø` may need its exact case. One page → follow it, and report the link to lint to repoint to the page's own name (an alias does not make a link resolve in Obsidian). Without a shell, search for the alias text and open the files it names to check their `aliases:`.
  3. Nothing, and **the target has a file extension** (`.png`, `.pdf`, `.canvas`…) → an attachment or output: look in `raw/assets/` and `outputs/`.
  4. Nothing at all → a page nobody has written yet. That is a signal — something the wiki mentions and doesn't cover — not an error. In an answer it is a gap; for lint it is a forward link (check 4).

Never build a path from the type (`wiki/concepts/<name>.md`) — pages may sit in subfolders (schema §3, **Grouped by**) or wherever the owner moved them. And never use bash's `**`: without `globstar` it silently misses subfolders.

## 3. Relative markdown links

Resolve against the folder of the file that contains the link first. If nothing is there — the page moved, and nobody updated the path — resolve by name as in step 2, and report the stale path to lint.

## 4. Links out of a page without reading it

For a page's neighbourhood (a multi-hop question, dream's shortlist), list its link targets without opening it:

```bash
grep -ohE '\[\[[^]]+\]\]' FILE \
  | sed -E 's/^\[\[//; s/\]\]$//; s/\\?[|].*$//; s/#.*$//; s/^ +//; s/ +$//; s#^.*/##; s/\.[mM][dD]$//' | sort -fu
grep -ohE '\]\([^):]+\.md(#[^)]*)?\)' FILE
```

The first gives normalised wikilink targets; the second the relative markdown links, to normalise by hand. What links *in* to a page is the backlink search in `references/retrieval.md` — it returns file paths, so turn them into names before comparing the two lists: `sed 's#.*/##; s/\.md$//' | tr 'A-Z' 'a-z'` (and lowercase the first list the same way).

## 5. The index is a shortcut, not the authority

`index.md` links every page by name, and in a grouped vault each group's heading names its folder — so a name found there usually tells you where the file is. The search in step 2 settles it, because the index can lag behind the pages until the next lint.
