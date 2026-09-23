# Eval suite

Fifteen cases for `claude plugin eval`. Eleven check that a message routes to the right skill; four check that a skill behaves, against a fixture vault.

```bash
claude plugin eval .                             # everything, 3 runs each
claude plugin eval . --tag routing --runs 1      # routing only, one run each
claude plugin eval . --case 'scope-refusal' --scaffold --allow-tools Write Edit
```

## What the cases assert

**Routing** (`--tag routing`) — one prompt each, graded with `tool_used` on the `Skill` tool: the right skill fires, and the skill it is most often confused with does not. They need no vault and no write tools; eleven cases at one run each cost about a dollar.

**Behaviour** (`--tag behaviour`) — each copies `fixtures/vault` into the run's workspace with its `scaffold.sh`, so they need `--scaffold`:

| case | asserts |
|---|---|
| `scope-refusal` | asked to ingest an invoice, the run refuses, names the scope rule it fails, and writes no page for it (`--allow-tools Write Edit`) |
| `query-honesty` | asked about a subject the vault doesn't hold, the answer says so instead of answering from general knowledge as if the wiki held it |
| `combined-refusal` | with two wikis connected — its `scaffold.sh` copies the fixture twice, as `research` and `personal`, the second under another vault id — asked to lint one, the run refuses, says to lint it from that wiki's own project, and writes no lint report (`--allow-tools Write Edit`) |
| `ingest-propagates` | one pending item is ingested: a source page is written, an existing concept page gets the claim with a link, the file leaves `raw/inbox/`, the index and log are updated, and the second pending item is left alone (`--allow-tools Write Edit Bash`) |

`ingest-propagates` grants a shell, so it only runs where the sandbox backend exists (`bubblewrap` and `socat` on Linux) — without it the harness refuses the run rather than running unconfined.

## When to run them

Before a release that touched a skill, and after any change to routing wording — a skill's `description` is what decides whether it fires at all, so the routing cases are the ones that catch a bad edit. The whole routing pass at one run each is about a dollar and a couple of minutes; the behaviour cases cost a few cents each but need `--scaffold`, and the ingest case needs a sandbox backend (`bubblewrap` and `socat` on Linux).

There is no CI workflow here on purpose: this plugin is released by hand, each eval run spends model credits, and a suite that runs on every push would cost more than it catches. Run it when the thing it tests changed.

## The fixture vault

`fixtures/vault` is the canonical copy: a small, real vault — schema with a vault id and an out-of-scope list, an index, an overview, one concept page, one source page, its raw file, both `_meta` scripts, and two items pending in `raw/inbox/` (one in scope, one not). Edit it there, then run `sh evals/sync-fixtures.sh` to copy it into each behaviour case, since `scaffold.sh` may only reach files inside its own case directory.

## Notes for whoever extends this

- A negative `tool_used` grader needs **both** `min: 0` and `max: 0`; `max: 0` alone reads as "1..0" and can never pass.
- `file_exists` has no negative form — assert absence with a `regex` grader over `target: files` and `match: not_contains`.
- `scaffold_script` is a **path** to a script in the case directory, not inline shell. It runs with the workspace as its working directory, so it reaches its own fixture through `$(dirname "$0")`.
- Judged (`llm`) graders vote three times and cost a fraction of a cent each; keep their criteria concrete enough that a judge can fail them for a specific reason.
