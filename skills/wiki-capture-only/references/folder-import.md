# Importing a folder

Many wikis start from a folder that already exists: a docs repository, a Notion or Evernote export, a Zotero collection, course materials by week, a shared drive, an older notes vault. Copying it into `raw/inbox/` file by file loses three things that matter — where each file came from, which files share a name, and how big the job is. This is how to import a folder without losing them, and how to keep the wiki in step with it afterwards.

It runs from wiki-setup (a folder that already has documents), or whenever someone asks to import, bring in or add a whole folder. Copying is capture — new files in `raw/inbox/`, no vault lock — and ingesting what was copied is wiki-ingest-pending's job, pass by pass. A folder that already has an import record is not imported again: the same command brings in what changed (*Keeping in step*).

## 1. Look before copying

List the folder at every depth and report, in a few lines:

- **how many files**, by kind (markdown, PDF, office documents, images, other) and by top-level subfolder
- **what isn't a source:** dotfiles and dotfolders (`.git/`), build output and dependencies (`node_modules/`, `dist/`, `build/`), lock and config files, and symbolic links — left out without asking
- **what looks generated:** an API reference built from code, a database schema dump, a changelog, vendored third-party docs. Each is better left out, or captured as a single source — say which you see
- **what fails the scope test** (wiki-capture-only, step 2): files whose names or kinds suggest admin — invoices, statements, tickets, credentials — or another person's personal data — CVs, ID scans, private message exports. They are left out unless the owner says otherwise; a shared drive often holds some
- **names that repeat** across subfolders (`README.md`, `index.md`, `notes.md`, `Untitled.md`) — they get unique names below, so nothing clashes
- **whether it is a git repository** — then each file's last-change date can be recorded

What is left out goes on the import's exclude list, so a later sync leaves it out too.

## 2. Say how big it is, and choose what happens now

A pass ingests about five to ten items — fewer early on, when most items create pages, and at most eight without sub-agents (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-ingest-pending/references/batch-ingest.md`). One scheduled wiki-maintain run is about one pass. Say it in numbers — *"380 files is about 40–60 passes: a few hours of work and a large share of a week's usage, or about a year of weekly scheduled runs"* — and ask on a card. Run by wiki-capture-only on its own, the card offers only the copy choices — everything, or chosen folders — and ingesting is offered afterwards.

- **Copy everything, ingest one part now** *(Recommended)* — name the part: the folder that holds the design and decisions, or the one the person's questions are about. The rest stays pending, for later passes or the scheduled runs.
- **Copy everything, ingest nothing now** — it all waits in the inbox.
- **Copy only chosen folders** — the others go on the exclude list; taking one off the record's `exclude:` line later and running the command again brings it in.
- **Copy and ingest everything now** — pass after pass in this session, with progress after each (*Showing progress* in batch-ingest.md); this one yes covers every pass.

## 3. Copy, and keep a record

Each file is copied — never moved — into `raw/inbox/` under a name built from its path: `backend/README.md` becomes `2026-09-22-backend-readme.md`, `architecture/README.md` becomes `2026-09-22-architecture-readme.md`. A stem any file in `raw/` already has, whatever its extension, gets `-2`, `-3` — so `spec.md` and `spec.pdf` never share one, and a PDF's sidecar can't collide with a document. The copy is byte for byte: no provenance block is added, because the import record carries what the file came with.

Every import keeps one record, `_meta/imports/import-<name>.md`, where `<name>` is the folder's name, made unique across imports (`docs`, `docs-2`):

```markdown
---
folder: /Users/you/projects/app/docs
name: docs
imported: 2026-09-22
git: yes
exclude: node_modules · dist · api-reference
---
- backend/README.md · 3f9a1c0e7b22d415 · 2026-08-30 → 2026-09-22-backend-readme.md
- backend/img/flow.png · 51be0c9d3a7f6e21 · 2026-08-30 → 2026-09-22-backend-img-flow.png (attachment of 2026-09-22-backend-readme.md)
- architecture/overview.md · 9c01d4aa52e0b7f3 · - → 2026-09-22-architecture-overview.md
synced: 2026-09-22 · 3 new · 0 changed · 0 back · 0 gone
```

- **`folder:`** is the folder as the person's computer names it — in Cowork, the path in the connected-folders list, never a `$HOME/mnt/…` path, which changes with every session.
- **One line per file:** its path inside the folder; a fingerprint of its content (the first 16 characters of its SHA-256); the date git records for its last committed change, or `-` (not in git, or with uncommitted edits); and the name of its copy. The copy's name holds wherever the file later moves — `raw/inbox/`, then `raw/` or `raw/assets/`.
- **Lines are only ever added.** A changed file gets a new line; a file gone from the folder gets a `gone` line; each run ends with a `synced:` line. Appending needs no lock, like the log.

One command does the copying and the record, and later the syncing — the same command every time. Set the three values and run it with the shell where the vault and the folder are (in Cowork, the computer's shell):

```bash
V='/path/to/vault'                 # the vault
FOLDER='/path/to/folder'          # the folder, as the person's computer names it — recorded, and matched on every sync
EXCLUDE='node_modules · dist · build'   # first import only: folders or files inside FOLDER, separated by ' · '
FOLDER=${FOLDER%/}
[ -d "$V/raw" ] || V="$HOME/mnt/$(basename "$V")"            # Cowork: connected folders are mounted by name
[ -d "$V/raw" ] || { echo "VAULT NOT REACHABLE: $V"; exit 1; }
L=$FOLDER; [ -d "$L" ] || L="$HOME/mnt/$(basename "$FOLDER")"
[ -d "$L" ] || { echo "FOLDER NOT REACHABLE: $FOLDER"; exit 1; }
cd "$V" || exit 1; V=$(pwd -P); D=$(date +%F); T0=$(date +%s); TMP=${TMPDIR:-/tmp}/wiki-import.$$
mkdir -p _meta/imports raw/inbox
R=$(grep -rlxF -e "folder: $FOLDER" _meta/imports 2>/dev/null | head -n 1)
if [ -z "$R" ]; then                                           # first import: a new record
  B=$(basename "$FOLDER"); N=$B; n=2
  while grep -rqxF -e "name: $N" _meta/imports 2>/dev/null; do N="$B-$n"; n=$((n+1)); done
  R="_meta/imports/import-$N.md"
  G=$(git -c safe.directory='*' -C "$L" rev-parse --is-inside-work-tree 2>/dev/null); [ "$G" = true ] && G=yes || G=no
  ( set -C; printf -- '---\nfolder: %s\nname: %s\nimported: %s\ngit: %s\nexclude: %s\n---\n' "$FOLDER" "$N" "$D" "$G" "$EXCLUDE" > "$R" ) || exit 1
fi
FRESH=; grep -q '^- ' "$R" || FRESH=1
EXCLUDE=$(sed -n 's/^exclude: //p' "$R" | head -n 1)
cd "$L" || exit 1; L=$(pwd -P)
if [ "$L" = "$V" ]; then EXCLUDE="${EXCLUDE:+$EXCLUDE · }/raw · /wiki · /_meta · /outputs · /README.md · /index.md · /overview.md · /patterns.md"
else case "$V" in "$L"/*) EXCLUDE="${EXCLUDE:+$EXCLUDE · }${V#"$L"/}";; esac; fi    # never import the vault into itself
last() { P=$1 awk '{ n = split($0, a, " · "); if (n < 3 || substr(a[1], 1, 2) != "- ") next
  p = substr(a[1], 3); for (i = 2; i <= n - 2; i++) p = p " · " a[i]
  if (p == ENVIRON["P"]) { f = a[n-1]; if (f != "gone") { k = f; c = a[n]; sub(/^.* → /, "", c) } } }
  END { print (f == "" ? "-" : f) " " (k == "" ? "-" : k) " " (c == "" ? "-" : c) }' "$V/$R"; }
: > "$TMP.ev"; : > "$TMP.gd"
if [ "$(git -c safe.directory='*' rev-parse --is-inside-work-tree 2>/dev/null)" = true ]; then
  { git -c safe.directory='*' -c core.quotePath=false diff --name-only --relative HEAD -- .; echo '@-'   # uncommitted: no git date
    git -c safe.directory='*' -c core.quotePath=false log --format='@%cs' --name-only --relative -- .
  } 2>/dev/null | awk 'BEGIN { d = "-" } /^@/ { d = substr($0, 2); next } NF && !($0 in s) { s[$0] = 1; print $0 "\t" d }' > "$TMP.gd"
fi
find . \( -name '.*' ! -name . -o -name node_modules -o -type d ! -name . -exec test -e '{}/_meta/schema.md' \; \) -prune -o -type f -print | sed 's#^\./##' |
EX=$EXCLUDE awk 'BEGIN { n = split(ENVIRON["EX"], e, " · ")        # a name: that file, or that folder at any depth; /name: only at the top; *.js: by file name
    for (i = 1; i <= n; i++) if (substr(e[i], 1, 1) == "/") { t[i] = 1; e[i] = substr(e[i], 2) }
    for (i = 1; i <= n; i++) if (e[i] ~ /[*?]/) { r = e[i]; gsub(/[].^$+(){}|[\\]/, "\\\\&", r); gsub(/\*/, "[^/]*", r); gsub(/\?/, "[^/]", r); g[i] = "^" r "$" } }
  { b = $0; sub(/.*\//, "", b)
    for (i = 1; i <= n; i++) if (e[i] != "" && (i in g ? (index(e[i], "/") ? $0 : b) ~ g[i] : ($0 == e[i] || index($0, e[i] "/") == 1 || (!(i in t) && index($0, "/" e[i] "/"))))) next; print }' |
sort | while IFS= read -r rel; do
  if [ $(( $(date +%s) - T0 )) -ge 100 ]; then echo "MORE: stopped before the time limit — run the same command again"; : > "$TMP.more"; exit 3; fi
  fp=$( (sha256sum 2>/dev/null || shasum -a 256) < "./$rel" | cut -c1-16)
  [ ${#fp} -eq 16 ] || { echo "NOT READ: $rel"; continue; }
  st=$(last "$rel"); f=${st%% *}; st=${st#* }; k=${st%% *}; kc=${st#* }
  [ "$fp" = "$f" ] && continue
  gd=$(P=$rel awk -F'\t' '$1 == ENVIRON["P"] { print $2; exit }' "$TMP.gd"); gd=${gd:--}
  if [ "$f" = gone ] && [ "$fp" = "$k" ]; then                  # back, unchanged: nothing new to ingest
    printf -- '- %s · %s · %s → %s\n' "$rel" "$fp" "$gd" "$kc" >> "$V/$R"; echo "BACK: $rel" >> "$TMP.ev"; continue; fi
  file=${rel##*/}
  case $file in ?*.?*) ext=$(printf '%s' "${file##*.}" | LC_ALL=C tr 'A-Z' 'a-z'); base=${rel%.*};;
    *) LC_ALL=C grep -qI . "./$rel" 2>/dev/null || { echo "NOT TEXT, NOT COPIED: $rel — add it to exclude:"; continue; }; ext=txt; base=$rel;; esac
  slug=$(printf '%s' "$base" | LC_ALL=C tr 'A-Z' 'a-z' | LC_ALL=C sed 's#[^a-z0-9]#-#g; s#--*#-#g; s#^-##' | cut -c1-80 | sed 's#-*$##')
  [ -n "$slug" ] || slug=untitled
  stem="$D-$slug"; n=2                                          # a stem no file in raw/ has, whatever its extension
  while [ -n "$(find "$V/raw" -maxdepth 2 -name "$stem.*" 2>/dev/null | head -n 1)" ]; do stem="$D-$slug-$n"; n=$((n+1)); done
  cp "./$rel" "$V/raw/inbox/.$stem.$ext.part" && mv "$V/raw/inbox/.$stem.$ext.part" "$V/raw/inbox/$stem.$ext" || { echo "NOT COPIED: $rel"; continue; }
  case $kc in *' (attachment of '*) sfx=" (${kc#* (}";; *) sfx=;; esac   # a changed attachment stays one
  printf -- '- %s · %s · %s → %s\n' "$rel" "$fp" "$gd" "$stem.$ext$sfx" >> "$V/$R"
  if [ "$f" = - ]; then echo "NEW: $rel" >> "$TMP.ev"; else echo "CHANGED: $rel" >> "$TMP.ev"; fi
done
[ -e "$TMP.more" ] || awk '/^- / { n = split($0, a, " · "); if (n < 3) next; p = substr(a[1], 3); for (i = 2; i <= n - 2; i++) p = p " · " a[i]; print p }' "$V/$R" |
  sort -u | while IFS= read -r rel; do
    [ -e "./$rel" ] && continue; st=$(last "$rel"); [ "${st%% *}" = gone ] && continue
    printf -- '- %s · gone · %s → -\n' "$rel" "$D" >> "$V/$R"; echo "GONE: $rel" >> "$TMP.ev"
  done
C=; for t in NEW CHANGED BACK GONE; do C="$C$(grep -c "^$t:" "$TMP.ev") $(echo $t | tr 'A-Z' 'a-z') · "; done
[ -e "$TMP.more" ] || printf 'synced: %s · %s\n' "$D" "${C% · }" >> "$V/$R"
echo "${C% · } — record $R"
if [ -n "$FRESH" ]; then grep -v '^NEW:' "$TMP.ev"; else cat "$TMP.ev"; fi
rm -f "$TMP.ev" "$TMP.gd" "$TMP.more"
```

It never imports the vault into itself — a vault inside the folder, or the folder itself, is left out — and it checks both folders before writing anything. **A shell call is cut off after 120 seconds unless given more (180 at most):** the command stops itself after 100 seconds and prints `MORE` — run it again until it doesn't. It continues the same record and never copies a file twice.

**Attachments.** An image a copied document embeds belongs to that document, not to the wiki as a source of its own. After the copy, this prints a line for each such image, to append to the record — the image's copy is then its document's attachment at ingest, and a warning names any image several documents embed:

```bash
R='_meta/imports/import-NAME.md'   # the import record; run from the vault
L=$(sed -n 's/^folder: //p' "$R" | head -n 1); [ -d "$L" ] || L="$HOME/mnt/$(basename "$L")"
V=$(pwd); cd "$L" || exit 1
awk '
function norm(p,   n, a, o, i, m) { n = split(p, a, "/"); m = 0
  for (i = 1; i <= n; i++) { if (a[i] == "" || a[i] == ".") continue; if (a[i] == "..") { if (m > 0) m--; continue } o[++m] = a[i] }
  p = ""; for (i = 1; i <= m; i++) p = p (i > 1 ? "/" : "") o[i]; return p }
function dec(s,   out, h, i, c) { out = ""; h = "0123456789abcdef"
  for (i = 1; i <= length(s); i++) { c = substr(s, i, 1)
    if (c == "%" && i + 2 <= length(s) && index(h, tolower(substr(s, i + 1, 1))) && index(h, tolower(substr(s, i + 2, 1)))) {
      out = out sprintf("%c", (index(h, tolower(substr(s, i + 1, 1))) - 1) * 16 + index(h, tolower(substr(s, i + 2, 1))) - 1); i += 2 }
    else out = out c }
  return out }
function found(parent, t) {
  if (!(t in copy) || t ~ /\.(md|markdown)$/ || (t in marked)) return
  if (!(t in owner) || parent < owner[t]) { if (t in owner) shared[t] = 1; owner[t] = parent } else if (owner[t] != parent) shared[t] = 1 }
function rel(parent, dir, ref) {
  sub(/^[ \t]*</, "", ref); sub(/>[ \t]*$/, "", ref); sub(/[ \t]+["\047(].*$/, "", ref); sub(/[#?].*$/, "", ref)
  if (ref == "" || ref ~ /^[a-zA-Z][a-zA-Z0-9+.-]*:/) return
  ref = dec(ref); found(parent, norm(ref ~ /^\// ? ref : dir "/" ref)) }
/^- / { n = split($0, a, " · "); if (n < 3) next; p = substr(a[1], 3); for (i = 2; i <= n - 2; i++) p = p " · " a[i]
  c = a[n]; sub(/^.* → /, "", c); if (c ~ / \(attachment of /) marked[p] = 1; else delete marked[p]; sub(/ .*$/, "", c)
  if (a[n-1] == "gone") delete copy[p]; else { copy[p] = c; rec[p] = $0 }
  b = p; sub(/^.*\//, "", b); byname[b] = p }
END { for (p in copy) if (p ~ /\.(md|markdown)$/) {
    dir = p; if (!sub(/\/[^\/]*$/, "", dir)) dir = ""
    while ((getline line < p) > 0) {
      s = line; while (match(s, /!\[[^]]*\]\([^)]*\)/)) { r = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        r = substr(r, index(r, "](") + 2); rel(p, dir, substr(r, 1, length(r) - 1)) }
      s = line; while (match(s, /<img[^>]*src="[^"]*"/)) { r = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        sub(/^.*src="/, "", r); rel(p, dir, substr(r, 1, length(r) - 1)) }
      s = line; while (match(s, /!\[\[[^]]*\]\]/)) { r = substr(s, RSTART + 3, RLENGTH - 5); s = substr(s, RSTART + RLENGTH)
        sub(/[|#].*$/, "", r); if (r in copy) found(p, r); else { b = r; sub(/^.*\//, "", b); if (b in byname) found(p, byname[b]) } }
    }
    close(p) }
  for (t in owner) { print rec[t] " (attachment of " copy[owner[t]] ")"; if (t in shared) print "embedded by several documents, given to " owner[t] ": " t | "cat 1>&2" } }' "$V/$R" | sort
```

Links from one copied document to another won't resolve inside `raw/`; that is expected — `raw/` stays as it came, and source pages link by page name.

## 4. Log it

One log entry per import, and one per sync that found anything — never one per file:

```markdown
## [2026-09-22] capture | import docs — 380 files
- record: _meta/imports/import-docs.md · left out: node_modules, dist, api-reference (generated)
```

## 5. What ingest does with it

- **One item per line.** A file the record names is grouped by its line, not by its name: its own item, unless its newest line says `(attachment of <copy>)`. When that document is already ingested — a changed image of an unchanged page — the new copy updates its page instead: add it to the page's `asset:` and move it to `raw/assets/`.
- **Where it came from.** Its source page gets `origin: "<record name>/<path in the folder>"` — quoted, since paths can hold colons. The record name keeps two imported `docs/` folders apart.
- **Who wrote it.** A file from an import is not the owner's own writing just because it has no frontmatter: the author is who the document names, else `unknown` — unless the owner says the folder is their own notes.
- **Its date.** A date the document states — in its text, its metadata or its original file name — wins. Otherwise the record's git date is its `published:`: version control recorded it, so it is not a guess. The copy's date prefix is the import date and is never used, nor is a file's modification time.
- **Its duplicates.** A source page with the same `origin:` is the same source. Compare the item's fingerprint with the line naming the copy behind the page's current `raw:` — for a binary, its original on `asset:`: the same is a duplicate; different is a re-capture that updates that page — `raw:` to the new copy, the old one onto `raw_previous:` (last ten; every capture gets its `## Version history` line), `published:` to the new date. When several copies of one origin are pending, ingest only the newest; the older ones go onto `raw_previous:` unread and leave the inbox with it.

## 6. Subjects from the folder's own structure

When the top-level subfolders are areas — backend and frontend, weeks of a course, clients, projects — rather than formats (`images/`, `pdf/`), at least two of them hold about ten files or more, and no more than about a third of the files would be left without one, offer on a card to group source pages by them. At setup, the answer goes into the schema Step 4 writes: §3's Grouped by cell for sources, §3c with one subject per such subfolder — its kebab-case name, and the line *"sources imported from the folder's `<subfolder>/`"* — and the `subject:` line in the source template. On an existing vault it is a grouping adopted by `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/grouping.md` (*Adopting a grouping*), with the person present and under the lock. Smaller subfolders get no subject and stay at the top. The subject then comes from `origin:`, which settles it plainly — grouping.md's *Assigning a subject*, step 1 — so nothing is guessed from content and lint never argues with it.

## 7. Keeping in step

A folder that keeps changing — a docs repository, a shared drive — drifts from its copies. Every wiki-maintain run runs the command above for each import whose folder the session can reach, and so does a person asking to sync:

- **Changed** files are copied again and get a new line; ingest updates their source page, found by `origin:`.
- **New** files are copied — new pending items.
- **Back**: a file that returned unchanged gets its old copy's line again; nothing new to ingest.
- **Gone** from the folder: a `gone` line, reported once. Nothing in the wiki changes — whether the page still belongs is the owner's call.

After the command, run the attachment helper and append what it prints, so a new document's images stay its attachments. The command prints the counts and the paths. A folder the session can't reach is reported, not an error: a scheduled run only sees the folders connected to it, so the scheduled task needs the imported folders connected as well as the vault.

## 8. Say where things stand

Tell the person, in plain words: how many files were copied and are pending, how many were left out and why, and what happens next — the part being ingested now, and that the rest follows in later passes or with the scheduled runs. Then ingest the chosen part with wiki-ingest-pending, showing progress after each pass. Run by wiki-capture-only on its own, stop after the copy: everything is pending. Run from wiki-setup, stop too: setup's Step 7 ingests the first pass.
