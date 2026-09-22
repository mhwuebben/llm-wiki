# Project instructions and the scheduled task

Two blocks to hand over, together. The first goes in the **project instructions** field of the Claude project that owns this vault: it is what makes every future session route correctly without being told — the difference between a wiki that compounds and a folder Claude occasionally writes to. The second is the prompt of the scheduled task that keeps the wiki up to date (*The scheduled task*, below).

Replace `{{VAULT FOLDER}}` with the folder's actual name — the folder as it is named on disk, since a session resolves it literally and a renamed or moved vault silently routes work into the wrong place. Change nothing else: the routing rules are load-bearing, the first paragraph is what stops a session editing `raw/` or writing an uncited claim, and the scope rule is what stops it filing things that were never wiki material.

---

```
This project maintains an LLM wiki at local folder "{{VAULT FOLDER}}". Read _meta/schema.md before any wiki work. raw/ is immutable — read and cite it, never edit, rename or delete it. Every factual claim on a wiki page carries a link to the source page it came from; synthesis that isn't in any source is marked as inference. Never silently overwrite what an earlier source said — record the contradiction on both pages.

Route every message before doing anything else, and load the llm-wiki skills rather than working from a remembered version of them:

- A question — about a topic, about what my notes say, about anything I might already know — goes to the wiki-query skill first. Answer from the wiki, cite the pages, and say plainly what the wiki doesn't cover before reaching for the web or general knowledge.

- A question or request about the wiki itself goes to its own skill: how it is doing → wiki-status; what it is missing or what to read next → wiki-gaps; duplicates, contradictions or broken links → wiki-lint; bringing it up to date or running the routine → wiki-maintain; upgrading it after a plugin update → wiki-setup.

- A note, a file, a screenshot, a pasted text or a link goes to the wiki-capture-and-ingest skill — unless I say to only save, park or clip it for later, which goes to wiki-capture-only. For a link, fetch the contents — a URL is not a source until its text is in raw/. Capture and ingest in the same pass; never leave it pending in raw/inbox unless I asked for that.

- A whole folder to bring in — a docs folder, an export, a shared drive — goes to the wiki-capture-and-ingest skill, which imports it as the wiki-capture-only skill's folder import says: how big it is first, then the part I choose.

- A request to ingest what is already pending in raw/inbox goes to the wiki-ingest-pending skill — the items I name, or everything when I say "process what's waiting".

- A request to turn what the wiki knows into a deck, a document, a briefing or a chart goes to the wiki-query skill first, before any file is made: the synthesis is filed as a note, then the file is made from that note into outputs/.

- A request for new connections or insights, or for what my notes add up to, goes to the wiki-dream skill; going through a dream report that is already written goes to wiki-dream-ingest — neither to wiki-query, which answers the question asked.

- If the vault folder can't be reached — no linked computer, the folder not connected — don't drop a link or a note I send: put it on the backlog in the project doc wiki-backlog.md, one line each — the date · ingest, or save if I said only to save it · the link, not fetched, or "pasted note" with my text verbatim indented below it, or a file's name with re-attach — and tell me. Whenever the folder can be reached and wiki-backlog.md has lines, drain it before anything else I ask, as the wiki-capture-only skill says: each line by its route, oldest first, and ask me for any file marked re-attach.

- Before capturing anything, check it against the schema's out-of-scope list. If it is admin rather than knowledge — a ticket, a boarding pass, an invoice, a receipt, a statement, a calendar entry, a task list, a credential, key or account detail — or if it is another living person's personal data — a CV, an application, an ID or medical or financial record, a private message thread, a contact file, a photograph of someone other than me — do not capture it. Say which scope rule it fails and what you'd do instead, and wait. Capture it only if I tell you to anyway, and then record scope: "override — <the rule it fails>" in its provenance; ingest carries it onto the source page.

If a message carries both — a link plus a question about it — capture and ingest first, then answer from the wiki that now includes it.
```

---

## Where it goes

- **Claude desktop / claude.ai** — open the project, then Settings → project instructions, and paste it there. It applies to every conversation in that project, on every device.
- **Claude Code** — the same text works as a `CLAUDE.md` at the vault root.

Setting it on the *project* rather than in a single chat is the point: a session started next month from a phone gets the same routing.

## The scheduled task

In Cowork, a scheduled task on the project, weekly for an active vault or monthly for a quiet one, with this prompt — `{{VAULT FOLDER}}` replaced as above:

```
Run the wiki-maintain skill on the LLM wiki in the folder {{VAULT FOLDER}}. This is an unattended scheduled run: don't wait for answers; put anything that needs a decision in the digest.
```

Set the task to approve automatically — otherwise a scheduled run stops at its first file write — and to run on the computer that holds the folder, with the vault and every imported folder connected. Update the Maintain line in schema §11 to the cadence chosen.

Later, once the vault has ten or so sources, a monthly dream pass can be scheduled the same way. It writes a report and applies nothing; the person works through it with wiki-dream-ingest:

```
Run the wiki-dream-only skill on the LLM wiki in the folder {{VAULT FOLDER}}. This is an unattended scheduled run: write the report and apply nothing.
```

## Why each rule is there

- **Read the schema first.** The schema is the vault's own conventions, and it is meant to be edited by its owner. A session that skips it applies this plugin's defaults over the owner's decisions.
- **`raw/` is immutable.** Everything in `wiki/` can be regenerated from `raw/`. Nothing can regenerate `raw/`.
- **Questions route to the wiki first.** Without this, a session answers from general knowledge and the compiled vault earns nothing. The instruction to say what the wiki *doesn't* cover is what keeps the answer honest rather than plausible.
- **Sources route to wiki-capture-and-ingest.** The failure mode this pattern exists to avoid is an inbox that grows without being processed. Routing straight through it means a dropped link is in the wiki, not parked.
- **Pending items route to wiki-ingest-pending.** Clips, drops and things saved for later wait in `raw/inbox/`; naming the skill keeps "process what's waiting" from being read as a question.
- **Fetch the link.** A URL in `raw/` is a bookmark. A URL's *text* in `raw/` is a source that can still be cited in a year when the page is gone.
- **Questions about the wiki itself route to their own skills.** "How's my wiki doing?" and "any duplicates?" are questions too; without this rule they go to wiki-query, which answers from the pages rather than checking the vault.
- **"Save it for later" is honoured.** Routing everything straight through is the default because an unprocessed inbox is the failure mode — but when the person explicitly asks only to park something, that is their call.
- **Decks and documents route to wiki-query.** Otherwise a slides or document tool builds the file straight from the chat, and the reasoning behind it is lost with the file. Filing the note first keeps the argument, with its citations, in the wiki.
- **Connections route to wiki-dream.** "What does it all add up to?" is phrased like a question, so without this rule it goes to wiki-query, which answers in chat. Dream applies the stricter test — both halves quoted from source-backed lines, nothing from outside the vault — and files nothing the person hasn't accepted in wiki-dream-ingest.
- **The backlog.** A session in the cloud, with the computer closed, can't write to the vault; without this rule a link sent from a phone is answered and forgotten. Draining first means the backlog never grows old unnoticed.
- **Capture and ingest before answering.** Otherwise the answer is built from a wiki that is one source out of date, and the person cannot tell.
- **The scope test.** Without it the routing rule above is unconditional: every file becomes a source. Ingest is not parking — it writes a source page, propagates across the index and overview, and leaves the content in a dozen greppable files that lint reads and any deck or export draws on. That is the wrong home for a ticket and a bad one for an invoice or a contract. The test is cheap because the schema already lists what does not belong; the rule just makes a session actually look.
