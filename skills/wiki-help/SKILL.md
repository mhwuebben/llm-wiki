---
name: wiki-help
description: "Explain how to use the LLM wiki plugin itself — which skill does what, when to use each and what to say to trigger it, how to do things (turn on debug mode, upgrade a vault, schedule the routine, combine several wikis, start a delphi pass, review sources before they are filed), and what the person is looking at (the vault's folders, pending and ingested, the Obsidian graph and the ring of unlinked dots around it). Read-only; writes nothing but a debug file when debug mode is on. Use when someone asks how to use the plugin or a skill, what a skill is for, the difference between two skills, what to say to get something done, or why the vault or its graph looks the way it does. Use wiki-query for questions about the wiki's content, wiki-status for how the wiki is doing, and wiki-doctor when something about the setup is not working."
---

# Wiki Help

Questions about the plugin, not about the person's notes: *"how do I turn on debug mode?"*, *"what's the difference between status and doctor?"*, *"what do I say to get a digest?"*, *"why is there a ring of dots around my graph?"*. Answer them from the plugin itself, briefly, and hand over the exact sentence to say where there is one.

**Read-only.** This skill changes nothing: no page, no schema, no setting, no log line — the one exception is a debug file when debug mode is on. When the answer is "run lint" or "upgrade the vault", say so and stop — the person decides whether to go on, and the skill that owns that work does it. It runs the same way with one wiki connected or several.

## Answering

1. **Which skill does what** — read the `description:` line of every `${CLAUDE_PLUGIN_ROOT}/skills/*/SKILL.md` now, rather than answering from memory: those lines are what decides which skill a message reaches, and they change between releases. Answer in plain words: what the skill is for, whether it writes anything, and one or two sentences that reach it. `references/how-to.md`, *What to say*, has sentences that are known to route.
2. **How to do something** — `references/how-to.md` has the recipes. Give the steps and the sentence to say; where a recipe needs a file edited — schema §11, say — name the file, the line and the value, and offer to have the owning skill make the change.
3. **What they are looking at** — the vault's folders, what *pending* and *ingested* mean, the graph view: `references/how-to.md`, *Reading the vault*. Look at the vault when the question is about this one — count what is in `raw/`, `outputs/` and `_meta/templates/`, say whether the pages they call orphans really are — but only read.
4. **Something is actually wrong** — a scheduled run that stopped, instructions that don't route, a script that fails: that is wiki-doctor's, not this skill's. A problem inside the pages — real orphans, duplicates, broken links — is wiki-lint's. Say which, in one line.
5. **A question the plugin doesn't answer** — say so, and point at the README, `docs/how-it-works.md` and the issue tracker named in `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/assets/about.md`. Never invent a feature, a setting or a command.

Keep answers short: the answer, the sentence to say, and at most one next step. A table only for "which skill for what" across several skills.

## Never recommend

- **Linking raw files with `[[ ]]`**, to join them to the graph or for any other reason. A source page names its raw file in `raw:` as a plain path on purpose (schema §6). The fix for how the graph looks is a filter in the graph view, never a change to the wiki.
- **Changing the wiki so a picture looks different.** The graph is a view; the vault's structure serves its citations, its searches and its lint checks.
- **A step around a skill.** If a skill is the way to do it, the answer names the skill.

## Debug mode

When schema §11's `Debug:` line says `on`, or the person asks for this run to be in debug mode, also record what these instructions made you guess — `${CLAUDE_PLUGIN_ROOT}/skills/wiki-setup/references/debug-mode.md`. It changes nothing about how this skill runs. That file is the one thing this skill writes.
