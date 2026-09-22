# Eval suite

Thirteen cases for `claude plugin eval`. Ten check that a message routes to the right skill; three check that a skill behaves, against a fixture vault.

```bash
claude plugin eval .                             # everything, 3 runs each
claude plugin eval . --tag routing --runs 1      # routing only, one run each
claude plugin eval . --case 'scope-refusal' --scaffold --allow-tools Write Edit
```

## What the cases assert

**Routing** (`--tag routing`) — one prompt each, graded with `tool_used` on the `Skill` tool: the right skill fires, and the skill it is most often confused with does not. They need no vault and no write tools; ten cases at one run each cost about a dollar.

**Behaviour** (`--tag behaviour`) — each copies `fixtures/vault` into the run's workspace with its `scaffold.sh`, so they need `--scaffold`:

| case | asserts |
|---|---|
| `scope-refusal` | asked to ingest an invoice, the run refuses, names the scope rule it fails, and writes no page for it (`--allow-tools Write Edit`) |
| `query-honesty` | asked about a subject the vault doesn't hold, the answer says so instead of answering from general knowledge as if the wiki held it |
| `ingest-propagates` | one pending item is ingested: a source page is written, an existing concept page gets the claim with a link, the file leaves `raw/inbox/`, the index and log are updated, and the second pending item is left alone (`--allow-tools Write Edit Bash`) |

`ingest-propagates` grants a shell, so it only runs where the sandbox backend exists (`bubblewrap` and `socat` on Linux) — without it the harness refuses the run rather than running unconfined.

## Continuous integration

`github-workflow.yml` here is the GitHub Actions workflow, kept outside `.github/` so that pushing it needs no `workflow` token scope. Copy it to `.github/workflows/evals.yml` in a checkout whose credentials have that scope, and set `ANTHROPIC_API_KEY` as a repository secret. It runs the routing cases on every pull request that touches a skill, and the behaviour cases in a job that installs the sandbox the shell-granting case needs.

## The fixture vault

`fixtures/vault` is the canonical copy: a small, real vault — schema with a vault id and an out-of-scope list, an index, an overview, one concept page, one source page, its raw file, both `_meta` scripts, and two items pending in `raw/inbox/` (one in scope, one not). Edit it there, then run `sh evals/sync-fixtures.sh` to copy it into each behaviour case, since `scaffold.sh` may only reach files inside its own case directory.

## Notes for whoever extends this

- A negative `tool_used` grader needs **both** `min: 0` and `max: 0`; `max: 0` alone reads as "1..0" and can never pass.
- `file_exists` has no negative form — assert absence with a `regex` grader over `target: files` and `match: not_contains`.
- `scaffold_script` is a **path** to a script in the case directory, not inline shell. It runs with the workspace as its working directory, so it reaches its own fixture through `$(dirname "$0")`.
- Judged (`llm`) graders vote three times and cost a fraction of a cent each; keep their criteria concrete enough that a judge can fail them for a specific reason.
