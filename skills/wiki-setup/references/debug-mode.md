# Debug mode

The skills in this plugin are prose. Where that prose is ambiguous, contradictory or missing a case, the only witness is the session that ran into it — and that session ends. Debug mode is how it leaves a note.

**Off by default.** It is on when schema §11's `Debug:` line says `on`, or when the person says so for this session ("run that in debug mode"). Read this file only then.

## The three rules that make it worth reading

1. **It changes nothing about how the run behaves.** No rule is loosened, no step skipped, no alternative tried "to see". Debug mode observes and records. A finding that describes a run nobody else would get is worth nothing, and a vault edited differently because debugging was on is worse than no finding at all.
2. **It reports what tripped this run, not what you would redesign.** The bar is that the problem *bit*: you had to guess, and here is what you guessed. Ideas that did not come up go in *Untriggered*, at most two, and a run with nothing to report says so. Most runs have nothing to report. A debug file that grows every run is a mode that has started inventing.
3. **Every finding is validated before it is written.** Three questions, in this order, and the answers go in the finding:
   - **Did you actually read it?** Open the file in the plugin now, at the section you are about to quote — not a remembered version.
   - **Does another part of the plugin already resolve it?** Search the skill's own references, the schema, and the two cross-cutting files (`locking.md`, this one's neighbours). A rule that exists but wasn't found is a **discoverability** finding, not a missing rule — and the fix is to move or cross-reference it, not to add it.
   - **What version?** This plugin's `.claude-plugin/plugin.json`. A finding without it is unusable: nobody can tell a live bug from one fixed two releases ago.

## What counts

- **ambiguity** — two readings of one instruction, both defensible, and you had to pick.
- **conflict** — two instructions that cannot both be followed.
- **missing-rule** — a case the skill plainly does not cover.
- **discoverability** — the rule exists and the run didn't find it in time.
- **vault-structure** — something about this vault that the plugin's rules did not anticipate.
- **schema-gap** — the vault's own schema is silent or wrong where a skill relies on it.
- **tooling** — a script, command or tool that failed or behaved unlike its documentation.

Not findings: a step that was hard but clear; a preference about wording; anything about the vault's *contents* (that is wiki-lint's and wiki-gaps'); and a mistake you made where the instruction was unambiguous — though "I misread this under load" is a legitimate **discoverability** finding when the text invites it.

## The shape

One block per finding, appended to `outputs/debug-YYYY-MM-DD.md` — created if it isn't there (said as it lands, `+ outputs/debug-…`) and appended to by every later run that day, newest at the bottom. It is append-only, like the log, so it needs no lock and no `-2` name: two sessions appending in the same second risk one garbled block and nothing worse (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/locking.md`, *The log*). Never rewrite it from a copy.

```markdown
## [2026-09-22 14:02] wiki-ingest-pending · ambiguity

- **plugin:** 3.4.0 · **file:** references/batch-ingest.md · **section:** step 2
- **tripped:** yes — had to choose; chose to draft the page and set the subject afterwards
- **the text:** "in the folder schema §3 assigns, which the reader works out after reading"
- **the two readings:** (a) the reader places the file itself; (b) the reader drafts and the main session places it. Both are consistent with the surrounding text.
- **reproduce:** any batch of two or more sources in a vault whose §3 groups source pages by subject. No vault content needed.
- **checked:** read batch-ingest.md step 2 and grouping.md *Placement*; neither says who writes the file. Not resolved elsewhere.
- **recommendation:** in step 2, say "the reader returns the placement; the main session writes the file there" — or the opposite, but say which.
- **confidence:** likely
```

**The recommendation must hold for any vault.** A finding may cite what happened here as evidence — that stays in the owner's own `outputs/` — but the fix is a change to the plugin or to the schema template, phrased so it makes sense to someone who has never seen this vault. Nothing from the vault's contents goes into a recommendation: no page titles as examples, no claims, no personal detail.

## Where it goes

- The file: `outputs/debug-YYYY-MM-DD.md`, appended by every debug run that day, newest at the bottom. Where several parts are connected (`${CLAUDE_PLUGIN_ROOT}/skills/wiki-query/references/parts.md`), it goes in the part a capture landed in, or the one a read-only run was pointed at — one file, never one per part; a run over several parts with none named puts its findings in its reply instead — and `Debug:` is read from that part's §11.
- The run's own report or digest: one line — *"2 debug findings → outputs/debug-2026-09-22.md"* — never the findings themselves, which would bury what the person actually asked for.
- Never into `wiki/`. A finding about the plugin is not knowledge about the owner's domain, and the one thing this vault must not learn is how it is itself built.
- wiki-doctor lists every debug file in `outputs/` with its finding count, so they don't rot unread.

## Handing them over

The file is meant to be given to whoever maintains the plugin, as it is. It is already versioned, quoted and reproducible, which is what makes a prose bug actionable: "the ingest skill is confusing" is not, and "batch-ingest.md step 2 doesn't say who writes the file, and here are the two readings" is.

Where the fix is to the **vault's own schema** rather than to the plugin, say so in the recommendation and name the section: those are the owner's to apply, and wiki-setup's upgrade mode is where they land.
