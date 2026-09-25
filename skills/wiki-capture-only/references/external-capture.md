# External capture — sources that arrive without Claude

Most sources land in the vault without this skill touching them: the Obsidian Web Clipper, a drag-and-drop, a sync from another device, an export from a read-later app. That's the normal case, not a workaround. The wiki doesn't care how a file arrived — it cares that the file is in `raw/`, that its provenance is recorded, and that Claude can tell what has already been ingested.

## Obsidian Web Clipper

The Web Clipper is a browser extension that saves a page as markdown straight into the vault. It's the fastest capture path for web reading and works perfectly with this setup — including on paywalled or login-walled pages, where a server-side fetch fails and a logged-in browser succeeds.

Configure it once:

1. Install the Web Clipper extension (Chrome, Firefox, Safari, Edge).
2. Open its settings → **General** and make sure the vault is the one holding the wiki.
3. Open **Templates** → **Import**, and paste in the JSON from `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/webclipper-template.json` (shipped with the wiki-setup skill; setup also saves a copy at `_meta/webclipper-template.json`, since the person can't browse the plugin's folder). It sets:
   - **Note location**: `raw/inbox`
   - **Note name**: `{{date|date:"YYYY-MM-DD"}}-{{title|kebab|safe_name}}`
   - **Properties**: the provenance fields the wiki expects — `captured`, `source_type`, `title`, `author`, `published`, `url`, `site`, `description`, `captured_by`, `ingested`
4. Clip something and check it lands in `raw/inbox/`.

Two extras worth knowing:

- **Highlighter** — highlight passages in the browser before clipping and `{{content}}` contains just the highlights. Excellent for long pages where only two paragraphs matter. The source page should note that the capture is highlights, not the full article, so nobody later mistakes a partial for the whole.
- **Images** — clipped markdown references images by URL, which rot. In Obsidian: Settings → Files and links → attachment folder = `raw/assets/`, then Settings → Hotkeys → bind "Download attachments for current file". Hit it after clipping and the images come local, where Claude can actually look at them. They land straight in `raw/assets/` under Obsidian's names — the one route that skips the inbox — and at ingest they are listed on the clip's `asset:` as attachments, never renamed.

## Other routes in

| Route | What to know |
|---|---|
| **Drag and drop into `raw/inbox/`** | Works for anything. No frontmatter, so the ingest infers what it can and asks about the rest. |
| **Obsidian mobile / share sheet** | Same as the clipper; check the note location setting points at `raw/inbox`. |
| **Obsidian Sync, iCloud, Dropbox** | Fine, but a file can exist as a placeholder before it has downloaded. If a read comes back empty or truncated, that's usually why — wait for the sync rather than filing an empty source page. |
| **Read-later exports** (Readwise, Instapaper, Kindle highlights) | Usually one file per item or one big export. Big exports are split at ingest, not at capture — one source page per item, not one page for the export. |
| **Email-to-vault, scanners, voice memo apps** | Anything that writes a file into the folder works. Whatever metadata the tool writes, keep it; the ingest maps it. |
| **A folder of documents that predates the wiki** | Import it by `folder-import.md`: a size estimate and a first slice, unique names, and an import record that keeps where each file came from. Never move the originals. |

## Adopting a file the wiki didn't write

At ingest, an externally captured file needs four things established. None of them require editing the file.

**0. Scope.** A clip, a sync or a drag-and-drop never went through capture's scope check, so ingest applies it: the schema's §1 out-of-scope list, the owner's own. A file that matches stays in `raw/inbox/`, untouched, until the person says *file it anyway* or *skip it* — asked once, and a skipped file simply stays where it is; one whose provenance already carries `scope: "override — …"` was decided at capture.

**1. Provenance.** Read whatever frontmatter is there and map it to the wiki's fields:

| Clipper / common field | Wiki field |
|---|---|
| `source` or `url` | `url` |
| `created` | `captured` |
| `published` | `published`, as ISO-8601 — a clipper's `2024-03-05T09:00+01:00` or `March 5, 2024` becomes `2024-03-05`; `2024` stays `2024`. None → leave it out; the clip date goes in `captured`, never here |
| `author` | `author` |
| `site`, `publisher` | publisher, noted on the source page |
| `description`, `excerpt` | used for the source page's one-liner, not copied as a claim |
| `tags` | tags, after checking them against the vault's existing tags |

Missing author, missing date, unknown origin: record that honestly on the source page (`author: unknown`) rather than inferring. If the origin matters and can't be recovered, ask.

**2. Don't rewrite the file.** `raw/` is immutable, and that applies to files other tools wrote. The mapped provenance lives on the **source page**, which is Claude's to write. The one permitted touch is flipping `ingested:` from `false` to the date, and only on a file that already has that field — never adding frontmatter to someone else's file, never reformatting a clip.

**3. Ingested state.** The reliable test is not a frontmatter flag, because externally captured files may not have one. In order:

- A source page — any page with `type: source`, wherever it sits — whose `raw:` field — or, for an earlier capture of a changed source, its `raw_previous:` list or a `## Version history` line — points at the file → **ingested**. This is the definition; everything else is a convenience.
- The file is still in `raw/inbox/` → treat it as pending, and confirm against the check above before ingesting (something may have been ingested without being moved).
- `ingested:` in the file's own frontmatter → a hint, trusted only when it agrees with the source-page check.

After ingesting, the item moves out of the inbox: a text file moves to `raw/`, a binary moves to `raw/assets/` and its sidecar to `raw/`. The move is the human-visible signal, the source page's `raw:` field (always pointing at markdown in `raw/`, with `asset:` listing everything it owns in `raw/assets/`) is the machine-checkable one, and the log entry is the history.

## Duplicates

External capture produces duplicates far more often than Claude-driven capture: the same article clipped twice, once from the newsletter and once from the site, or a sync that re-copies a file under a new name. Before ingesting anything from the inbox, check the URL, the `origin:` of a file from an imported folder, and the title against existing source pages — a match on title alone needs the same author and edition or period too, because recurring titles (an annual report, a newsletter issue) are new sources, not re-captures. A genuine re-capture of a *changed* source is a new file that updates the existing source page — `raw:` moves to it, the old file goes on `raw_previous:`, and the page says what changed. Not an overwrite, and not a second page.

## What to tell someone setting this up

Clipping is the habit that keeps the vault fed, and the inbox is the queue. Clip freely; ingest the same day with `wiki-ingest-pending`, and let the scheduled `wiki-maintain` run sweep up what's left. The failure mode isn't clipping too much — it's an inbox that never gets processed, which is why `wiki-ingest-pending` and `wiki-maintain` exist.
