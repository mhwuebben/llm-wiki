# {{Wiki name}}

An LLM wiki: a knowledge base that Claude builds and maintains, and you read.

## How it works

Three layers:

- **`raw/`** — your sources, never changed by Claude. Text lives here directly — clips, pasted articles, your own notes — so the whole layer stays greppable. Everything that isn't text (PDFs, slides, images, audio) sits in **`raw/assets/`** with a short provenance note left behind in `raw/` — except attachments, like the images inside a clip, which belong to their parent and need no note of their own. Drop new ones in `raw/inbox/`.
- **`wiki/`** — Claude's pages. Summaries, entity pages, concept pages, filed answers. All interlinked, all traceable back to `raw/`. Claude owns this; you're free to edit but don't have to.
- **`_meta/schema.md`** — the conventions Claude follows. Argue with it; it's meant to evolve.

Two front doors: **[[index]]** (everything, cataloged) and **[[overview]]** (what we know so far).

## The loop

| You say | What happens |
|---|---|
| "Add this article" — or just drop a link (with the project instructions in place) | it's captured, a source page is written, and every affected page across the wiki is updated, in one pass |
| "Save this for later" | it's cleaned up and filed in `raw/inbox/` — pending, to be ingested later |
| "Process what's waiting" | everything pending in `raw/inbox/` gets ingested |
| "What does the wiki say about X?" | answered from the compiled pages, with citations — and the good answers get filed back |
| "Make a deck on X" | the answer is filed as a note first, then the deck is made from it into `outputs/` |
| "Lint the wiki" | contradictions, stale claims, orphans and gaps get found — and fixed once you approve |
| "Bring the wiki up to date" — or the scheduled run | everything pending gets ingested, the vault gets linted, and you get a digest of what changed since last time |
| "What does it all add up to?" | connections your pages already imply get proposed, and you decide which ones get written down |
| "Go through the dream report" — after a scheduled dream pass | the proposals waiting for you, one at a time; only what you accept is filed |
| A link sent while this folder is out of reach — the computer closed | it goes on the project's backlog and is captured the next time a session can reach the folder |

## One writer at a time

`_meta/wiki-lock.md` shows whether Claude is writing to the vault right now — what it is doing, with a line per step — or is free. Two sessions don't write at once: the second waits, and a session that died is taken over within minutes. That holds on one computer; a sync service between devices is slower than the lock, so let one device do the writing routines.

## Any editor works

Obsidian makes this pleasant, but nothing depends on it: it is folders of markdown. To follow a `[[link]]` in another editor, search for the file by that name — VS Code's Quick Open, GitHub's "Go to file", Finder or Explorer search. Every name is unique, so the search finds exactly one file, and the index's group headings say which folder it is in. Reorganise inside `wiki/` however you like — Claude follows your folders. When you link to a page yourself, write `[[name]]`, not a path: a name survives a move, a path doesn't.

## Who does what

You curate sources, ask the questions, and decide what matters. Claude does the summarising, cross-referencing, filing and bookkeeping — the work that makes people abandon wikis.

## Started

{{YYYY-MM-DD}}
