# CLAUDE.md

Guidance for working on this repository — the **LLM Wiki** plugin for Claude Cowork and Claude Code. For what the plugin does, read `README.md`; for how a vault is laid out and why, `docs/how-it-works.md`; for what changed when, `CHANGELOG.md`.

## What this repo is

A Claude plugin written almost entirely in prose. There is no build, no package manager, no dependencies and no runtime code of its own — the skills *are* the program, and Claude executes them by reading them. The only executable code is two POSIX `sh` scripts that `wiki-setup` copies into each vault, plus the eval scaffolding.

The plugin builds and maintains a user's *vault*: a folder of markdown with immutable sources in `raw/`, Claude-owned pages in `wiki/`, and a schema in `_meta/schema.md`. None of that lives here — this repo only holds the instructions that create and maintain it.

## Layout

```
.claude-plugin/
  plugin.json          plugin manifest — name, version, description, author
  marketplace.json     marketplace listing (installs as llm-wiki@mhwuebben-plugins) — version appears twice
skills/<name>/
  SKILL.md             frontmatter (name, description) + the instructions Claude follows
  references/          detail a skill reads on demand, linked from its SKILL.md
  assets/              files a skill copies or fills in (templates, report skeletons, scripts)
agents/
  wiki-reader.md       sub-agent: reads one source (or a section, or a change) and drafts one page
  wiki-auditor.md      sub-agent: audits a slice of a vault read-only for a lint pass
docs/how-it-works.md   user-facing reference: the vault layout, one source end to end, install, upgrade, fork
evals/                 test suite for `claude plugin eval` (see evals/README.md)
CHANGELOG.md           one entry per release, newest first
```

Fourteen skills. Where a question would be answered by one of them, read that skill rather than guessing:

| Area | Skills |
|---|---|
| Getting sources in | `wiki-capture-only`, `wiki-capture-and-ingest`, `wiki-ingest-pending`, `wiki-maintain` |
| Using and looking after the wiki | `wiki-query`, `wiki-lint`, `wiki-dream`, `wiki-dream-only`, `wiki-dream-ingest`, `wiki-status`, `wiki-doctor`, `wiki-gaps`, `wiki-help` |
| Building and upgrading a vault | `wiki-setup` |

Files other skills lean on, which are effectively shared definitions:

- `skills/wiki-setup/references/schema-template.md` — the schema every vault gets. **Its section numbers (§1–§12) are referenced all over the plugin.**
- `skills/wiki-lint/references/checks.md` — lint checks **1–14**, referenced by number from lint, maintain, status, ingest, the auditor agent and the search script.
- `skills/wiki-setup/references/locking.md` — the vault lock and how log entries are appended.
- `skills/wiki-setup/references/debug-mode.md` — what every skill does in debug mode.
- `skills/wiki-query/references/parts.md` — several vaults as parts of one brain; a project that combines them is read-only except for captures.
- `skills/wiki-ingest-pending/references/batch-ingest.md` — *Showing progress*: how every skill announces files it creates (`+ path`) and moves (`→ old → new`).
- `skills/wiki-setup/assets/project-instructions.md` — the text users paste into their Cowork project; it routes messages to skills.
- `skills/wiki-setup/assets/wiki-search.sh`, `wiki-lock.sh` — the two scripts copied into every vault's `_meta/`.

## Rules the plugin guarantees — don't break them in an edit

These are promises made in the README and relied on across skills. A change that weakens one is a design change, not an edit, and needs the author's say-so.

- **`raw/` is immutable.** Nothing edits, renames or deletes a file there; the only permitted touch is flipping an existing `ingested:` flag.
- **Every factual claim on a wiki page cites a source page.** Claude's own synthesis is marked as inference.
- **Contradictions are shown, never averaged**; superseded claims move to `## History`, never vanish.
- **Judgement calls wait for the owner.** Unattended runs (`wiki-maintain`, scheduled dream passes) apply only fixes with one right answer.
- **One writer at a time.** Every skill that changes shared pages takes the vault lock via `_meta/wiki-lock.sh`, and never holds it across a question to the person.
- **One skill owns each kind of write.** A step that belongs to another skill is done by invoking that skill, not by doing it inline.
- **Scope is the owner's list.** Schema §1's out-of-scope list is the whole gate — no fixed categories. A match is asked about once (*file it anyway* / *skip it*) and a forced item carries `scope: "override — …"`. Nothing is refused on Claude's own judgement, and unattended runs never override.
- **Several wikis connected → a reading room.** Reads cross vaults; the only write is a capture into one vault's inbox. Ingest, lint, maintain, dream passes, imports and upgrades refuse there and name the vault's own project.
- **No hooks, no MCP servers.** The README promises "only instructions you can read". Don't add either.

## Editing conventions

- **A skill's `description:` decides whether it fires at all.** Each one ends by naming the sibling to use instead, to keep routing sharp. After changing any description, run the routing evals (below).
- **Cross-references:** within a skill, `references/<file>.md` or `assets/<file>`; across skills, always `${CLAUDE_PLUGIN_ROOT}/skills/<skill>/...` or `${CLAUDE_PLUGIN_ROOT}/agents/...`. Point at sections by their heading in italics — `locking.md` (*The log*).
- **Every SKILL.md has a `## Debug mode` section** and says what it does when several vaults are connected. Keep both when adding a skill.
- **Renumbering is expensive.** Adding, removing or reordering a schema section, a lint check or a numbered skill step means grepping the whole repo for `§N`, `check N` and `step N` references and fixing each one.
- **Counts are written out in prose and must move together:** "fourteen skills" (`README.md`, `marketplace.json`), "fourteen checks" (`skills/wiki-lint/SKILL.md` twice, `agents/wiki-auditor.md`, `README.md`), "two sub-agents" (`README.md`, `marketplace.json`), "sixteen cases, eleven routing, five behaviour" (`evals/README.md`).
- **Examples are generic.** Never put a real vault's name, a real person's data or anything from a user's wiki into shipped text.
- **Voice.** User-facing docs (`README.md`, `docs/`, `CHANGELOG.md`, what skills tell the person) are plain, direct and in British spelling (*organisation*, *licence*, *summarise*), addressed to "you". Skills address Claude in the imperative. Short sentences, em dashes, no emoji, no marketing adjectives. Match the file you're in.

### The shell scripts

`skills/wiki-setup/assets/wiki-search.sh` and `wiki-lock.sh` run on the user's machine — Linux or macOS — so:

- POSIX `sh` only; no bashisms. Anything with GNU/BSD differences needs a fallback (see `iso()` in `wiki-lock.sh`: `date -d` then `date -r`).
- The usage header is also the help text: unknown subcommands print a fixed line range of the file (`sed -n '6,12p'` in `wiki-search.sh`, `sed -n '5,8p'` in `wiki-lock.sh`). Adding a subcommand means updating that range.
- Skills cite subcommands by name (`backlinks`, `cites`, `pending`, `raw`, `take`, `renew`, …) — rename one and grep for every caller.
- Smoke-test against a copy of the fixture vault, never inside `evals/`:
  ```sh
  cp -R evals/fixtures/vault "$TMPDIR/v" && cp skills/wiki-setup/assets/*.sh "$TMPDIR/v/_meta/"
  cd "$TMPDIR/v" && sh _meta/wiki-search.sh pending && sh _meta/wiki-search.sh raw backpressure && sh _meta/wiki-lock.sh status
  ```
- A change to a script is a vault upgrade: `wiki-setup`'s upgrade mode replaces the vault's copy, `wiki-doctor` compares it with the plugin's, and the changelog's *Upgrading* paragraph says so.

## Things that must stay in sync

| When you change… | …also update |
|---|---|
| A skill's behaviour | `README.md` skill table and prose if they describe it; `docs/how-it-works.md`; `skills/wiki-help/references/how-to.md` if it gives a recipe for it; `skills/wiki-setup/assets/project-instructions.md` if routing changes |
| The schema template | `wiki-setup` upgrade mode (so existing vaults get the line); the changelog's *Upgrading an existing vault* paragraph; `evals/fixtures/vault/_meta/schema.md` if the evals depend on it |
| `wiki-search.sh`, `wiki-lock.sh` or `assets/templates/*` | the copies in `evals/fixtures/vault/_meta/`, then `sh evals/sync-fixtures.sh` |
| Anything in `evals/fixtures/vault` | run `sh evals/sync-fixtures.sh` — each behaviour case keeps its own copy; never hand-edit `evals/<case>/vault/` |
| A new behaviour eval case | add it to the list in `evals/sync-fixtures.sh` and to the table in `evals/README.md` |
| Adding or removing a skill | the counts above; README tables; `wiki-help`; `project-instructions.md`; a routing eval case for it |

## Testing

There is no CI, on purpose: each eval run spends model credits, and releases are made by hand. Run the suite when the thing it tests has changed — before a release that touched a skill, and after any change to a `description:` line.

```bash
claude plugin eval . --tag routing --runs 1      # routing only — about a dollar, a couple of minutes
claude plugin eval .                             # everything, 3 runs each
claude plugin eval . --case 'scope-refusal' --scaffold --allow-tools Write Edit
```

Behaviour cases need `--scaffold`; `ingest-propagates` also needs `Bash` and a sandbox backend (`bubblewrap` and `socat` on Linux). `evals/README.md` has the grader gotchas — read it before writing a case.

For a prose change with no eval, re-read the edited skill end to end as the model would: does every step still name a real file, section, check and subcommand?

## Releasing

Every change that reaches users is a release. One commit per release:

1. Bump `version` in `.claude-plugin/plugin.json` **and** both places in `.claude-plugin/marketplace.json` — marketplace installs don't pick up a change without it. Minor for new or changed behaviour, patch for docs and fixes.
2. Add a `## X.Y.Z — YYYY-MM-DD` entry at the top of `CHANGELOG.md`: bullets that lead with a bold sentence saying what changed for the user, then why. If an existing vault needs anything — a schema line, re-pasted project instructions, a replaced script, a new task prompt — end with an **Upgrading an existing vault.** paragraph that says exactly what.
3. Commit as `LLM Wiki X.Y.Z: <what changed, in plain words>` — e.g. `LLM Wiki 3.12.0: you decide what is blocked, and filing anyway is one answer`.
