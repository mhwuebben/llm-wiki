# How to

Recipes for the questions people ask about the plugin. Each gives what to say, or what to change, and nothing more. Where a recipe and a skill disagree, the skill wins: say so, and tell the person which one you followed.

## What to say

Sentences that reach each skill. Any wording with the same meaning works; these are known to route (the eval suite's routing cases test several of them).

| To … | Say | Skill |
|---|---|---|
| add a link, file or note now | *"Add this to my wiki: <link>"* | wiki-capture-and-ingest |
| keep something for later | *"Just park this for later, don't process it yet"* | wiki-capture-only |
| bring in a folder you have | *"Import this folder into the wiki"* | wiki-capture-and-ingest (folder import) |
| process what's waiting | *"Process what's waiting"* | wiki-ingest-pending |
| ask the wiki | *"What do my notes say about <topic>?"* | wiki-query |
| turn an answer into a deck or brief | *"Make that a deck"* | wiki-query (files the note first) |
| see how it's doing | *"How's my wiki doing?"* | wiki-status |
| check the setup | *"My weekly run hasn't happened — is the setup right?"* | wiki-doctor |
| clean up | *"Check it for duplicates and broken links"* | wiki-lint |
| find what's missing | *"What should I read next?"* | wiki-gaps |
| run the routine now | *"Bring the wiki up to date"* | wiki-maintain |
| find connections, and decide on them | *"What do my notes add up to?"* | wiki-dream |
| go through a dream report | *"Let's go through the dream report"* | wiki-dream-ingest |
| start a new wiki | *"Set up an LLM wiki here — it's for <topic>"* | wiki-setup |
| ask how to use the plugin | *"How do I …?"* | wiki-help |

## The skills people mix up

- **wiki-status vs wiki-doctor** — status says how the *wiki* is doing: pages, what's pending, what waits for a decision, when the routines last ran. Doctor says whether the *machinery around it* is sound: the schema against the plugin version, the project instructions, the scheduled tasks and whether the folder is attached to them. Things look wrong → status; something doesn't run → doctor.
- **wiki-lint vs wiki-maintain** — lint checks and repairs the pages, and asks about anything that needs judgement. Maintain is the routine that ingests what's waiting, runs lint's mechanical fixes and writes a digest; it's the one to schedule.
- **wiki-gaps vs wiki-dream** — gaps says what the wiki *doesn't* know and what to read. Dream finds what the pages *already* add up to that no page says.
- **wiki-dream vs wiki-dream-only vs wiki-dream-ingest** — dream-only writes a report and applies nothing (the one to schedule); dream-ingest goes through a report with you; dream does both in one sitting.
- **wiki-capture-only vs wiki-capture-and-ingest** — the first saves an item for later; the second saves it and ingests it now.

## Recipes

- **Turn on debug mode** — for one run: add *"in debug mode"* to the request. For every run: set the `Debug:` line in schema §11 of `_meta/schema.md` to `on`. Findings go to `outputs/debug-YYYY-MM-DD.md`; wiki-doctor lists them. Turn it off again after testing.
- **Upgrade after a plugin update** — first sync the marketplace (Cowork → Customize → Plugins), then say *"upgrade my wiki"* in the wiki's own project. It proposes each schema change for approval and shows the current project instructions and task prompts to re-paste. With several wikis, upgrade each from its own project. wiki-doctor says which are behind.
- **Schedule the routine** — wiki-setup hands over the task prompt; ask *"give me the scheduled task prompt"* if it's lost. Weekly suits an active vault. Attach the vault folder to the task itself, set it to approve automatically, and run it on the computer that holds the folder. Add a monthly dream pass once there are about ten sources.
- **Review sources before they are filed** — set the Ingest line in schema §11 to `discuss takeaways with me before writing`. A scheduled run then only lists what's pending.
- **Combine several wikis** — keep each wiki in its own project; that's where it's ingested, linted and maintained. For a project that reads across them, connect the folders and say *"this project combines several wikis — give me the project instructions"*. That project only reads and captures.
- **A delphi pass** — in a project combining several wikis, ask an important question and add *"ask all the brains properly"* or *"delphi"*. Each wiki answers alone, then sees the others' quoted claims.
- **Clip from the browser** — the Obsidian Web Clipper, with the template setup saved to `_meta/webclipper-template.json`: import it in the clipper's settings. Clips land in `raw/inbox/` and are ingested by the next run, or by *"process what's waiting"*.
- **Keep an imported folder current** — change, regenerate or reorganise the folder however you like, then say *"sync the <folder> folder"*, or let the scheduled run do it. Changed files update their source pages from what changed, in one run; moved files keep their pages; files that disappear are reported, and nothing is deleted.
- **File something your out-of-scope list blocks** — say *"add this anyway"* (or *"ingest it anyway"* for something already waiting in the inbox). It is filed like any other source, with the decision on record, and never raised again.
- **Change what is blocked** — schema §1's *Out of scope* list is yours: ask *"stop blocking <category>"* or *"also block <category>"*, and wiki-setup makes the change to the schema and logs it.
- **A very long document** — just add it. Past about 15,000 words (schema §10's *Read in sections past* line) it is read in sections and ingested in one pass: one source page, with its claims grouped and cited by section. Nothing to run twice.
- **Send something while away from the computer** — just send it. With the folder out of reach it waits on the backlog (`wiki-backlog.md` in the Claude project) and is captured by the next session that reaches the folder.
- **See what is running or waiting** — ask *"how's my wiki doing?"*: wiki-status shows the run in progress, what is pending and what waits for a decision.

## Reading the vault

- **Pending** — a file in `raw/inbox/`, not yet ingested. **Ingested** — it has left the inbox and a source page's `raw:` points at it.
- **`raw/`** holds your sources, untouched; **`wiki/`** holds Claude's pages; **`_meta/`** the schema, log, templates and scripts; **`outputs/`** reports, digests and decks.

### The graph view

Obsidian draws every file as a dot and every `[[link]]` as a line. So a vault's graph usually shows:

- **The dense cluster** — the wiki's pages, linked to each other. Large dots are hubs.
- **A ring of loose dots around it** — mostly the raw sources. Each source page names its raw file as a plain path in `raw:`, not as a link, so the graph draws no line to it. Reports in `outputs/` and the vault's own README files sit there too. **This is expected, and nothing is broken.**
- **Pale dots** — links to pages that don't exist yet, including the placeholders in `_meta/templates/`.

To see only the wiki, type this into the graph view's search box (it can be saved as a graph filter):

```
-path:"raw/" -path:"_meta/" -path:"outputs/"
```

Then a dot floating on its own is a real orphan: a wiki page nothing links to, which wiki-lint's orphan check reports and proposes a fix for. Count before saying so — look in `wiki/` for pages with no links in — rather than reading it off the picture.

**Never fix the picture by changing the wiki.** Linking raw files to join the ring to the cluster would break a deliberate design (schema §6) and gain nothing but a tidier image.
