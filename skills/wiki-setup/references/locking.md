# The vault lock

Two sessions writing one vault at the same time — a scheduled maintain run and a person's ingest, two chats, two devices — can each overwrite what the other just wrote: `overview.md`, `index.md`, a concept page, an inbox item half moved. The vault lock makes writers take turns.

It is a **lease**: taken for a few minutes, renewed as the work shows progress, and taken over once it has plainly lapsed. A session that crashes blocks the vault for minutes, not forever; one that is merely slow keeps it for as long as it keeps renewing.

## What needs it

- **Needs the lock:** any change to a file other operations also write — pages in `wiki/`, `index.md`, `overview.md`, `patterns.md`, `_meta/schema.md`, `_meta/templates/`, `_meta/moves/` — and moving a file out of `raw/inbox/`. In practice: the writing part of every ingest, wiki-lint's fixes, wiki-query's filing of a note, wiki-dream-ingest's applying of findings, wiki-setup's upgrade changes and any grouping move — and an unattended wiki-maintain run, for the whole run.
- **Doesn't:** reading anything; creating a new file under a name no one else uses — a capture into `raw/inbox/`, a report or digest in `outputs/` (create it no-clobber, *New files* below); and appending to the log (*The log*) or to an import record (`_meta/imports/`). Captures, reports and the read-only skills never wait.

**Never hold it across a question.** A person can take hours to answer, and a lease can't be renewed while waiting. Settle every question first — the check-in, the yes for a batch, the approvals — then take the lock, write, and release it. If a question comes up while you hold it, finish the page you are on, release, ask, and take it again after the answer, re-reading what you will change.

## The script and the file

Everything goes through one small script, so that reading, deciding and writing happen in a single command:

```bash
sh _meta/wiki-lock.sh take "<operation>" [minutes]           # WON <token> | HELD … | UNREADABLE
sh _meta/wiki-lock.sh renew <token> "<progress>" [minutes]   # OK | LOST
sh _meta/wiki-lock.sh release <token>                        # RELEASED | LOST
sh _meta/wiki-lock.sh status                                 # FREE | HELD … | STALE …
```

- **Where:** `_meta/wiki-lock.sh`, copied from `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/wiki-lock.sh` by setup and by upgrade mode. If it is missing, write it from there first — it is plain text, and the plugin's copy is always the current one.
- **Which shell:** one that runs where the vault's files are — in Cowork, the computer's shell with the folder mounted, not an isolated environment that can't see it (`grouping.md`, *Moving files*, step 1). The script finds the vault from its own path, so it runs from any directory.
- **State:** `_meta/wiki-lock.md`, which anyone can open to see what is running. It is never deleted — some environments don't let Claude delete files, and a lock released by deleting it would stick. Held, it reads:

```markdown
---
status: held
holder: ingest-20260922T140211Z-a3f1
operation: ingest — 7 items
since: 2026-09-22T14:02:11Z
expires: 2026-09-22T14:12:30Z
expires_at: 1790085150
---
- 2026-09-22T14:02:11Z taken
- 2026-09-22T14:05:02Z 1/7 attention-is-all-you-need — source page written
- 2026-09-22T14:07:30Z 1/7 propagating: transformers, self-attention, overview
```

Free, it holds `status: free` and one `Last:` line. The script keeps the last ten progress lines; the log is the permanent record.

## Taking it

1. **`take "<operation>"`**, with a short description: `"ingest — 7 items"`, `"lint — apply 12 fixes"`. The script reads the file, takes the lease only if it is free or stale, waits five seconds and checks that its token is still there — so two sessions arriving together end up with exactly one winner.
2. **`WON <token>`:** it is yours. Keep the token for every later call. Then **re-read each shared file right before you change it**, and change it in place — with the Edit tool, or a read-modify-write command, which may cover several files in one call as long as it re-reads each one inside itself — never by writing back a copy read before you took the lock. What you read before may have changed while you waited or talked.
3. **`HELD …`:** another session is writing. Don't write. Tell the person what holds it — the operation, the last progress line and until when — and offer to wait, running `take` again about once a minute, or to do the read-only part in the meantime. **Unattended**, retry the same way for up to ~10 minutes; then stop, write nothing, and say in the run's report that the vault was busy, and with what.
4. **`LOST …`:** another session took it at the same moment. Treat it as held.
5. **`UNREADABLE`** (from any command): the file is empty or half-written — often a sync still arriving. Wait a few seconds and run the same command again; never create the file over it.
6. **Already held by this session.** A skill that another skill runs inside the same session — wiki-ingest-pending and wiki-lint inside an unattended wiki-maintain run, a grouping move inside an upgrade — doesn't take the lock again: it uses the token its caller got, renews it, and leaves releasing to the caller. The same operation name in someone else's token is not yours.

## Holding it

- **Renew before every shared write, and at least every few minutes:** `renew <token> "<what you are about to do>"` — with a count when there is one: `"ingest 22/380 — propagating [[transformers]]"`. It checks the lease is still yours and moves `expires:` 5 minutes ahead, adding your progress line. Anyone who opens the file sees what is happening; a successor after a crash sees where you stopped.
- **Declare a long wait before it starts.** Before a step that may run past 5 minutes without a chance to renew — reading a long source, waiting for sub-agents — renew with the minutes it needs, at most 30: `renew <token> "waiting for 6 readers" 20`. Readers and auditors can't renew for you.
- **`LOST` means stop.** The lease lapsed and another session has taken it over, or released it — it may already be finishing or redoing your work. Stop writing at once, don't release anything, and tell the person what you had done so far.

## Stale leases

A lease more than 60 seconds past its `expires:` is stale: its holder stopped showing signs of life. `take` then takes it over — it prints `TAKING OVER` with the old holder, and carries the old progress lines into the new file. Name it on your log entry: `- recovered: lock from <old token> — <operation>, last progress <time>`.

Then deal with what the old holder left:

- **An ingest of everything pending, or a maintain run,** finishes an interrupted ingest before its own work: any item still in `raw/inbox/` that a source page already points at — a whole pass's worth, where one was interrupted (wiki-ingest-pending, *Before you start*, step 4). The old progress lines say where it stopped.
- **Any other operation** — an ingest of named items included — names the interrupted work in its report and leaves it: the next ingest finds it the same way, and a half-edited page is for the next lint.
- **An interrupted grouping move** — a `_meta/moves/` record newer than the last `schema` log entry — resumes only with the person present (`grouping.md`, *Moving files*).

A live lease is never taken over, however long ago `since:` was: a long run that keeps renewing is alive. After a crash, the vault stays blocked only for the rest of the lease plus a minute — normally under six minutes.

## Releasing

`release <token>` as soon as the writing is done — finished, stopped early or failed. It only frees a lease that is still yours, and leaves anyone else's alone. Always release: a lease left held blocks the next writer until it expires.

## The log

`_meta/log.md` is append-only, and appending needs no lock. With a shell, append each entry in one write:

```bash
cat >> _meta/log.md <<'EOF'

## [2026-09-22] capture | Attention Is All You Need
- raw/inbox/2026-09-22-attention.pdf + sidecar · pdf
EOF
```

On a local disk two such appends can't interleave; across a sync service the worst case is one garbled entry. Without a shell, append with the Edit tool, which re-reads the file first. Never rewrite the log from a copy.

## New files

A report, a digest or a capture has a name no one else should be using — but two runs on the same day can pick the same one. Create it no-clobber, so the write fails instead of overwriting: `set -C; cat > "outputs/digest-2026-09-22.md" <<'EOF'` … `EOF`. If it fails, take the next free name (`-2`, `-3`).

## Without a shell

Some environments have only file tools. Then read and write `_meta/wiki-lock.md` in the forms above with those tools, and wait 30 seconds, not 5, before reading it back to confirm your token is still there. Take the time from the session's clock; make the token the operation plus that time, with no invented random part.

## Limits

- **One copy of the vault.** The lock protects writers that see the same files. A sync service between devices (iCloud, Dropbox, OneDrive, Obsidian Sync) can take longer to carry the file across than `take` waits, so two devices can both believe they hold it. Run the writing routines on one device; lint's check for sync conflict copies (check 3) catches what slips through.
- **Cooperative.** Only skills that follow this file honour it. An editor with a page open doesn't, and the person's own edits are theirs to make.
