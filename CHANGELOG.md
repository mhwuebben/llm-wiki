# Changelog

## 3.0.0 — 2026-09-22

LLM Wiki as it stands: twelve skills and two sub-agents that build and keep an AI-maintained second brain in a folder of markdown, after Andrej Karpathy's LLM Wiki idea.

**Getting sources in.** `wiki-capture-only` lands a source in `raw/inbox/` with its provenance, after a scope, completeness and duplicate check, and stops: the item is *pending*. `wiki-ingest-pending` ingests pending items — the ones named, or everything in `raw/inbox/` — reading each in full, writing its source page, propagating it across every page it touches, checking that every page it names cites it, and moving it out of the inbox. `wiki-capture-and-ingest` runs the two back to back for items handed over now. `wiki-maintain` is the routine to schedule: ingest everything pending, lint with only the mechanical fixes, write a digest.

**Using and looking after it.** `wiki-query` answers from the compiled wiki with citations, follows links in both directions without Obsidian, and files good answers back as notes — and, for a deck, document or chart, files the note first and makes the file from it. `wiki-lint` runs thirteen health checks, including a sample of citations tested against their sources. `wiki-dream-only` writes a report of connections the pages imply but no page states; `wiki-dream-ingest` works through a report with the person and files only what they accept; `wiki-dream` runs both in one sitting. `wiki-status`, `wiki-gaps` and `wiki-setup` report, suggest and build.

**Safe to leave running.**

- **One writer at a time.** Every skill that changes the wiki takes the vault lock in `_meta/wiki-lock.md`: a lease with a holder, a declared expiry and a progress line per step. A small script takes, renews and releases it in single commands, so two sessions arriving together get exactly one winner. Contenders wait; no skill holds it across a question to the person; a lease whose holder stopped renewing is taken over a minute after it expires — normally within six minutes — and the next ingest finishes whatever was left half done. Reads, captures, reports and log appends never wait.
- **A backlog for when the vault is out of reach.** A link or note sent while the folder can't be reached goes on a backlog in the Claude project (`wiki-backlog.md`), and the next session that can reach the folder — or the next scheduled `wiki-maintain` run — captures it first.
- **Nothing lands in the wiki unchecked.** Out-of-scope material stays pending until the owner decides, partial captures are not filed as whole, and every dream finding needs the owner's yes.

**Setup** introduces the plugin and its author, interviews before it builds, and hands over the project instructions and the scheduled-task prompt together.
