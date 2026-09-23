# Obsidian setup

Obsidian is a free markdown editor that reads a folder of files. Nothing in this vault depends on it — but it makes the wiki browsable, and the graph view is the fastest way to see the shape of what's been built.

## The five-minute version

1. Install Obsidian (obsidian.md) and choose **Open folder as vault** → pick the vault folder.
2. **Settings → Files and links**
   - *Default location for new notes*: "In the folder specified below" → `raw/inbox` — a note the person writes is a source, queued for ingest; `wiki/` is Claude's. One side effect to mention: clicking a link to a page that doesn't exist yet makes Obsidian create an empty note there. wiki-ingest-pending lists empty files for the person to delete, so no harm is done — but it's better not to click forward links
   - *Use [[Wikilinks]]*: **on**
   - *Automatically update internal links*: **on** — it keeps links right when a file is renamed or moved *inside Obsidian*. Moves made anywhere else are safe for a different reason: every name in the vault is unique, and links use names, not paths
   - *New link format*: leave it on **Shortest path when possible** (the default), so links you make stay plain `[[name]]`
   - *Default location for new attachments*: "In the folder specified below" → `raw/assets`

   That last one lines up with the wiki's own convention: `raw/assets/` is where binaries live — PDFs and audio filed there by ingest, images pasted there by Obsidian — while `raw/` stays text. Sources still get dropped into `raw/inbox/`, not into `assets/`.
3. Open `index.md`, then `overview.md`. Those are the two front doors.
4. Open the **graph view** (left sidebar, or Ctrl/Cmd+G). The dense cluster is the wiki's pages; hubs are well-connected topics. **A ring of loose dots around it is expected**: those are the raw sources, which source pages name as a plain path rather than a link, plus reports and templates. Nothing is broken, and nothing should be linked to join them. To see only the wiki, suggest typing `-path:"raw/" -path:"_meta/" -path:"outputs/"` into the graph view's search box — suggest it, and say where it goes; don't change the person's Obsidian settings. With that filter on, a dot floating on its own is a real orphan, which the lint pass reports.

Tell the person the loop out loud: Claude edits on one side, Obsidian shows the result on the other. They can keep it open while ingesting and watch pages appear. And say that they can reorganise inside `wiki/` in Obsidian however they like — Claude follows their folders rather than moving pages back.

## Web Clipper — do this during setup, not later

The Web Clipper is a browser extension that saves a page as markdown directly into the vault. It's the fastest way to feed the wiki, and it beats a server-side fetch on paywalled, logged-in and JavaScript-heavy pages because it runs in the browser the person is already signed into.

1. Install the extension (Chrome, Firefox, Safari, Edge).
2. Settings → **General**: confirm the vault is the wiki's vault.
3. Settings → **Templates** → **Import**, and paste the template JSON (or drop the file). The person can't browse the plugin's folder, so show them the full JSON from `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/webclipper-template.json` and save a copy at `_meta/webclipper-template.json`. It clips into `raw/inbox/`, names files `YYYY-MM-DD-title-in-kebab-case`, and writes the provenance properties the ingest expects.
4. Clip one page and confirm it appears in `raw/inbox/`. Then ingest it — the loop only becomes real once they've seen it end to end.

Two things worth showing them:

- **Highlighter** — highlight passages before clipping and only the highlights are saved. Ideal for long pages where two paragraphs matter.
- **Download attachments** — after clipping, Settings → Hotkeys → search "Download attachments for current file" and bind a key. Images land in `raw/assets/` and become readable instead of dead URLs.

## Optional, when they want more

- **Dataview plugin** — turns the frontmatter this wiki already writes into live tables ("all concepts touched this month", "sources not yet linked from overview").
- **Git plugin or a plain git repo** — version history and rollback for a folder of markdown. Cheap insurance before the first big lint pass.

## If they don't use Obsidian

Everything still works: the vault is folders and text files, and no skill depends on Obsidian — Claude follows links itself, by name. `[[wikilinks]]` show as literal text in other editors. To follow one, search for the file by that name — VS Code's Quick Open, GitHub's "Go to file", Finder or Explorer search: every name is unique, so the search finds exactly one file, and `index.md`'s group headings say which folder it is in. When they link to a page themselves, `[[name]]` beats a relative path, because a path breaks when a page moves. VS Code, Typora, Logseq and iA Writer all open the vault. Say this rather than letting a tool install block the first ingest.
