# Retrieval strategies

## The default: index first, search alongside

`index.md` is a catalog with one line per page. Read it, pick the five to ten pages that could bear on the question, read those, then follow their links. For a vault of a few hundred pages this beats any search you could run, because the one-line summaries were written by an agent that had read the sources. Run the text search in the same step, not after: it costs little and catches what no summary mentions.

## The script

Every search below is also a subcommand of `_meta/wiki-search.sh`, which setup copies into the vault from `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/wiki-search.sh` (write it from there if it is missing — it is plain text, and the plugin's copy is the current one). **Run it rather than writing the grep yourself**, wherever a skill asks for one of these searches:

```bash
sh _meta/wiki-search.sh find <name>                 # where a name resolves to; AMBIGUOUS if two files share it
sh _meta/wiki-search.sh names                       # every page name in the vault
sh _meta/wiki-search.sh search <term> [term...]     # first-step search over the page set
sh _meta/wiki-search.sh backlinks <name> [alias...] # every page that links that page
sh _meta/wiki-search.sh cites [-a alias]... <name> <file>...   # cited: / NOT CITED: / MISSING: per file, body only
sh _meta/wiki-search.sh pending [term...]           # what is waiting in raw/inbox, and how much
sh _meta/wiki-search.sh raw <term> [term...]        # the text of raw/, each hit labelled current, earlier, uncovered or pending
```

One command, from any directory, with the page set and the link forms already right — which matters because ingest's closing step, lint check 6 and this skill must all get the same answer. A hand-written grep that misses the `\|` form or searches `raw/` quietly disagrees with the check that runs later. The recipes below are what the script does, and what to run where there is no shell.

## The commands

Run from the vault's root, **one vault at a time**: where several parts are connected (`parts.md`), every command here runs once per part, from that part's root, results carrying that part's name, and `_meta/wiki-search.sh` is each vault's own copy, searching only that vault. Written for a POSIX shell (macOS, Linux, Git Bash on Windows); the Grep and Glob tools are fine equivalents where they can match without regard to case. `-F` makes every pattern literal, so names with dots, brackets or parentheses need no escaping.

Every search runs over the **page set** — the same files `references/links.md` resolves against: every `.md` in the vault except `raw/`, `outputs/`, `_meta/` and dotfolders, so pages in subfolders and pages the owner moved out of `wiki/` are included. That is what the options `--include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*'` with `.` at the end do. (Write `'.?*'`, not `'.*'`: the latter also excludes `.` itself, and the search finds nothing.)

**First-step search** — the question's names and rarer terms, with translations into the languages on schema §1's `Languages:` line:

```bash
grep -rliF --include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*' \
  -e 'term one' -e 'term two' -e 'Übersetzung' .
```

**Large index** — past ~300 rows, search `index.md` rather than reading it whole:

```bash
grep -iF -e 'term one' -e 'term two' index.md
```

**Backlinks** — every file that links to the page named `SLUG`, in any form a link takes (plain, labelled, the table-escaped `\|`, to a heading, and relative markdown links written in other editors):

```bash
grep -rliF --include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*' \
  -e '[[SLUG]]' -e '[[SLUG|' -e '[[SLUG\|' -e '[[SLUG#' \
  -e '/SLUG.md)' -e '(SLUG.md)' -e '/SLUG.md#' -e '(SLUG.md#' .
```

Add the page's `aliases:` as extra targets the same way (`-e '[[Alias]]' -e '[[Alias|'`…) — links written to an alias don't resolve in Obsidian, but they are still about this page. With the Grep tool instead of a shell: the regex `\[\[SLUG(\]\]|\\?\||#)` without regard to case, escaping `. ( ) [ ] + ?` in SLUG, then `/SLUG\.md[)#]` for relative links.

- **30 files or fewer:** run it again with `-n` in place of `-l` to see the linking lines themselves, without context — each line says what that page says about the subject.
- **More than 30** — a hub page: keep the file list, don't print the lines. Narrow by type first (source pages for "which sources say…"), then, if still many, by the question's terms:
  ```bash
  grep -rliF --include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*' -e '[[SLUG]]' -e '[[SLUG|' -e '[[SLUG\|' -e '[[SLUG#' . \
    | tr '\n' '\0' | xargs -0 grep -l '^type: source' \
    | tr '\n' '\0' | xargs -0 grep -liF -e 'term one' -e 'term two'
  ```
  The term filter drops pages that use a synonym or another language, so say how many linking pages you did not read.
- **Links, not mentions.** A page can discuss a subject without linking it. When completeness matters ("every source that mentions X"), add a name and alias search of the source pages and report it as a text match: `grep -rliF --include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*' -e 'Name' -e 'alias' . | tr '\n' '\0' | xargs -0 grep -l '^type: source'`.
- Non-standard link forms (spaces inside the brackets, a folder path, `.md` inside a wikilink) are not caught; lint check 1 proposes normalising them.

**Does this page cite that source?** The backlink search also finds a source named only in a page's frontmatter `sources:` or in code — neither of which carries a claim. To confirm that a page's *body* links a source, test each file the search returned. This one test is what wiki-ingest-pending's closing step and lint check 6 both run, so the two always agree:

```bash
S='SOURCE-NAME'   # the source page's name; add the same eight -e patterns for each alias
for f in PAGE-FILE-ONE PAGE-FILE-TWO; do
  awk 'NR == 1 { sub(/^\357\273\277/, "") }
       { sub(/\r$/, "") }
       NR == 1 && /^---[[:space:]]*$/ { fm = 1; next }
       fm { if ($0 ~ /^---[[:space:]]*$/) fm = 0; next }
       /^[[:space:]]*(```|~~~)/ { code = !code; next }
       code { next }
       { gsub(/`[^`]*`/, ""); print }' "$f" \
  | grep -qiF -e "[[$S]]" -e "[[$S|" -e "[[$S\\|" -e "[[$S#" \
      -e "/$S.md)" -e "($S.md)" -e "/$S.md#" -e "($S.md#" || echo "NOT CITED: $f"
done
```

It skips a byte-order mark, Windows line endings, the frontmatter block and fenced and inline code, and counts every link form the backlink search does. (Inside double quotes `\\|` is a literal `\|`, the table-escaped pipe; don't copy it into single quotes.) With the Grep tool instead: search the file with the backlink regex above and drop hits in the frontmatter block or in code.

**Is a note behind?** Dates are days, so compare strictly: a source created *after* the note's `answered:` day — a source from the same day may already be in the answer. The note may be behind if it carries a contradiction callout citing such a source. Otherwise, take every page the note links to — in its body and in `sources:` (`references/links.md`, *Links out of a page*), leaving out `index`, `overview` and other frame pages — as `P1`, `P2`…, and list the newer source pages that link to them, ranked by how many of those pages each one links:

```bash
grep -rliF --include='*.md' --exclude-dir=raw --exclude-dir=outputs --exclude-dir=_meta --exclude-dir='.?*' \
    -e '[[P1]]' -e '[[P1|' -e '[[P1\|' -e '[[P1#' -e '[[P2]]' -e '[[P2|' -e '[[P2\|' -e '[[P2#' . \
  | tr '\n' '\0' | xargs -0 grep -l '^type: source' | tr '\n' '\0' | xargs -0 grep -H '^created:' \
  | awk -F':created: *' -v d='ANSWERED' '$2 > d { print $1 }' \
  | while IFS= read -r f; do
      printf '%s %s\n' "$(grep -ohiF -e '[[P1]]' -e '[[P1|' -e '[[P1\|' -e '[[P1#' -e '[[P2]]' -e '[[P2|' -e '[[P2\|' -e '[[P2#' "$f" \
        | tr 'A-Z' 'a-z' | sed 's/[][|#\\]//g' | sort -u | wc -l)" "$f"
    done | sort -rn
```

Leave out sources the note already cites. What remains is newer material on the pages the note rests on: the top of the list is the evidence worth reading. A source that shares only one page with the note — usually a hub, the owner or the main subject — is weak evidence on its own; many of them together still say the topic has moved. Never judge by the note's `updated:`: a callout or a lint fix bumps it without refreshing the answer.

**How old is the evidence?** For a time-sensitive question, the `published:` dates of the source pages behind the answer:

```bash
grep -H '^published:' <the source page files>
```

## When the index isn't enough

| Situation | What to do |
|---|---|
| Vault has grown past a few hundred pages | Search the index instead of reading it; the first-step search does the rest |
| Question uses words no page title would contain | The first-step search — domain jargon, synonyms, proper nouns, other languages |
| Index summaries look stale | Trust the pages over the index, and offer a lint pass afterwards |
| Answer is spread across many pages thinly | Read `overview.md` first — the synthesis may already hold it |
| Question is about *when* or *what changed* | Three records, in this order: the source pages' `## Version history` lines (what each source said and when it changed), the `## History` sections of the pages carrying the claims, and their history companions — a page with `history-of:` naming them — where the older entries live (what the wiki concluded and why it stopped), and `_meta/log.md` (when the vault did the work). A question about how a position drifted is answered from the first two; the log only dates it |
| Question is about a specific number, date or wording | Go to the source page, then to the raw file. Summaries drop precision by design |

## Multi-hop questions

"How does the thing in A affect the thing in B?" needs a path, not a lookup. List what each endpoint links to (`references/links.md`, *Links out of a page*) and what links to each (the backlink command), turn both lists into lowercase names — the backlink command returns paths: `sed 's#.*/##; s/\.md$//' | tr 'A-Z' 'a-z'` — drop `index`, `overview` and the other frame pages, which link to everything, and intersect: the shared neighbours are the candidate connections. For hub pages, filter by the question's terms first. If there is no shared page, that absence is itself the finding — and usually worth filing as a note, since the connection you just worked out is new knowledge.

## Vague questions

"What do I know about X?" — answer in layers: the one-line definition, the three or four things the sources establish, the disagreements, the gaps. Then ask what they're actually after. Don't dump every page that mentions X.

"Where does my thinking stand?" — this is `overview.md` plus the most recent log entries. Lead with the synthesis and what changed since last time.

## When the wiki seems to have nothing

Before saying the wiki has nothing on X, look in the three places it could still be. Filenames first, then text:

1. **The pages** — the first-step search, with synonyms and the vault's other languages. Nothing → go on.
2. **`raw/inbox/`** — `ls raw/inbox/ | grep -iF 'term'`, then `grep -rliF -e 'term' raw/inbox/` (outside the page set on purpose). Skip empty files: an empty note named like a page is usually one Obsidian created when someone clicked a link to a page that didn't exist yet. A hit is a source captured but not ingested: say so, and offer to ingest it — where it matches a line of schema §1's out-of-scope list, name the line and ask once: *file it anyway* or *skip it*.
3. **The text of `raw/`** — `sh _meta/wiki-search.sh raw <term> [term...]`, which labels every hit: `current`, `earlier` — an earlier copy of a source that has changed since, whose current wording is on the page it names — `uncovered` — a file no source page names, which lint check 11 reports: it is not in the wiki, so say so and cite the file itself — or `pending`. **A line found only in an earlier copy is never answered as current**: it is what the source used to say, and the page it names, its `## History` and its `## Version history` say what replaced it. Without the script, `grep -rliF --include='*.md' -e 'term' raw/`, and check each hit against the `raw_previous:` and `## Version history` of the source pages before trusting it. A hit in a *current* ingested file that no page mentions means the ingest left it out: answer from the file, citing its source page and the file, and offer to add the line to the source page only when it answers the question asked. Summaries drop detail by design; don't offer to add every fact.

Nothing in any of the three → a real gap. Say so, say what you searched (terms and languages), and say how many binary sources could not be searched: their text is not in `raw/` — only their provenance sidecars are — so a PDF or a recording can hold what no search finds.

Two guards. Never write into `wiki/` anything schema §1's out-of-scope list keeps out, however you found it, unless the owner files it anyway (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-capture-only/SKILL.md`, step 2); and never restore in an answer what a page's redaction line says was removed. Files of retired sources (named on a `retired:` line in the log) are not left-out content either.

## Questions the wiki can't answer

Three honest responses, in order of usefulness:

1. **Adjacent knowledge**: "The wiki doesn't cover pricing, but it has three pages on the channel strategy that bear on it."
2. **The gap as an action**: name the source worth capturing, and offer to fetch and ingest it now.
3. **Outside knowledge, clearly labelled**: general knowledge or a web search, marked as not from the wiki, with an offer to capture what you found so next time it *is* in the wiki.

## Reading economically

- Don't open forty pages to answer a small question. Shortlist, read, stop when the answer is supported; past ~15 pages without that, stop and say what you didn't read.
- Read whole pages, not fragments — pages are short by design, and the contradiction callout is usually at the bottom. Grep lines are for choosing which pages to open, not for citing.
- For counting or aggregate questions ("how many sources mention X"), search rather than read, and say your count is a text match, not a judgement.
- Re-read `overview.md` before any question about the big picture. It exists precisely so you don't have to reconstruct the synthesis every time.
