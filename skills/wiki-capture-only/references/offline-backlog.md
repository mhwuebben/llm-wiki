# When the vault can't be reached

A session can run where the vault isn't: a cloud session while the laptop is closed, a chat on a phone, a conversation whose computer isn't linked. Nothing can be captured then — capture reads the schema and checks the vault before it writes, and the vault is where it writes. But a link handed over then shouldn't be lost either. It goes on the **backlog**, and the next session that can reach the vault captures it.

## Where the backlog lives

Outside the vault, somewhere every later session can read. In a Claude project, that is the project doc `wiki-backlog.md` (it may be listed as `claude/wiki-backlog.md`). Where there is no such place, say plainly that the vault can't be reached and that the link has to be handed over again once it can — don't promise to keep what can't be kept.

## What goes on it

One line per item, oldest at the top:

```markdown
- 2026-09-22 · ingest · https://example.com/article — "mainly the pricing section"
- 2026-09-22 · save · https://example.com/paper.pdf
- 2026-09-23 · ingest · pasted note
    > The text of the note, verbatim, indented under its line.
- 2026-09-23 · ingest · quarterly-report.pdf · re-attach
```

- **The date, the route and the item.** The route is `ingest` — wiki-capture-and-ingest, the default — or `save` — wiki-capture-only, when the person asked only to save, park or clip it for later. Anything the person said about it goes after it, in quotes.
- **Links only.** Nothing is fetched now; the text is captured when the backlog is drained. A page that changes or disappears in the meantime is captured as it is then, or fails — say so when you add it.
- **Pasted text or a note of the person's own** is the source itself, and nothing else holds it: keep it verbatim, indented under its line.
- **An attached file** can't be kept there. List its name with `re-attach`, and ask the person to hand it over again once the vault can be reached.
- **Obviously out of scope** — a boarding pass, an invoice, another person's CV — is refused now, with the rule named, as capture would (wiki-capture-only, step 2). The schema's own list is checked when the backlog is drained.

Then tell the person in one line: the vault can't be reached right now, the item is on the backlog, and it will be captured the next time a session can reach the vault.

## Draining it

Whenever a session can reach the vault and the backlog has lines: before the person's own request, and at the start of every wiki-maintain run. The drain itself takes no vault lock — captures only create new files, and the ingests take the lock for their own writes — but the backlog doc is shared: **re-read it right before every write-back, and change only the lines you are handling.** A line added meanwhile from a phone must survive; adding a line works the same way.

1. **Settle the questions first.** With the person present, show the lines, get a yes if there are more than three items, and ask for the file of each `re-attach` line. Unattended, leave `re-attach` lines for the person.
2. **Capture, oldest first:** each line with wiki-capture-only — the link, or the pasted text as pasted text, with the person's note. A pasted note keeps its line's date: for the person's own writing that is the day it was written (`published:`), and `captured:` is today. Re-read the doc first; a line already gone was drained by another session.
3. **Take each line off** once its item has landed or been turned away, by writing the doc back without it. Some lines stay, with the reason and the date added: a fetch whose failure may pass (a timeout, a site that was down); a `re-attach` line until its file is handed over; and, unattended, a line that fails the scope test — the person decides, as with any out-of-scope item, and the digest names it.
4. **Ingest what was meant for it:** the items whose route was `ingest`, named exactly, with wiki-ingest-pending — its check-in and its lock apply as usual, and step 1's yes covers its list. `save` items stay pending. Inside a wiki-maintain run, skip this step: the run ingests everything pending next, and is already authorised to.
5. **Report** what came in from the backlog, one line each, and what stayed and why.

## Making it automatic

Two things drain the backlog without anyone asking:

- **The project instructions** tell every session that can reach the vault to drain it first — so it happens the next time the person talks to the project with the computer on and the folder connected.
- **The scheduled wiki-maintain run** drains it at its start. It can only do so when the computer is on at the scheduled time; a run that can't reach the vault changes nothing, and the next one catches up.
