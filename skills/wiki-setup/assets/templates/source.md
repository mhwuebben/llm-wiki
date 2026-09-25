---
type: source
title: {{Title}}
aliases: []
tags: []
created: {{YYYY-MM-DD}}
updated: {{YYYY-MM-DD}}
status: solid
raw: raw/{{YYYY-MM-DD}}-{{slug}}.md                  # always the markdown in raw/, never raw/inbox/
# raw_previous: []                                  # the last ten earlier captures, newest first; older ones live in ## Version history; omit if none
asset: [raw/assets/{{YYYY-MM-DD}}-{{slug}}.{{ext}}]  # list: the original plus any attachments, under this stem (images Obsidian saved keep their own names); omit if none
# expires: {{YYYY-MM-DD}}                            # add only if the source states its own end date
# scope: "override — {{the §1 line it matched}}"    # only if the owner had it filed anyway against schema §1's out-of-scope list
# origin: "{{record name}}/{{path inside it}}"      # only for a file from an imported folder (its import record in _meta/imports/)
# sections: {{n}}                                  # only for a source read in sections (schema §10): how many; its key claims are grouped by section
# export: "[[{{export page}}]] · {{item key}}"      # only for an item split from an export (a Kindle clippings file, an .mbox): the export's page and what names this item in it
# items: {{n}}                                     # only on an export's own page: how many items it was split into; no key claims of its own
author: {{Author}}
published: {{YYYY-MM-DD}}   # the date the source states (YYYY or YYYY-MM if that is all); from an imported folder with none stated, its git date; omit if unknown — never the capture date
url: {{url or omit}}
---

# {{Title}}

**What it is:** {{one sentence — type of source, who made it, when, why it's in this wiki}}

## Summary

{{3–6 bullets or short paragraphs. What this source actually says, in your words. Enough that the page is useful without reopening the original.}}

## Key claims

- {{claim}} — {{figure, caveat, or the condition under which it holds}}
- {{claim}}

## Entities and concepts

- [[{{entity}}]] — {{what this source adds about it}}
- [[{{concept}}]] — {{what this source adds about it}}

## Notable details

{{Numbers, dates, definitions, methods, a quoted line or two if the exact wording matters.}}

## How it sits with the rest of the wiki

{{Confirms / extends / contradicts which pages. Use a callout for real contradictions:}}

> [!warning] Contradiction
> This source says X; [[other-source]] says Y.

## Open questions

- {{what this source raises but doesn't answer}}

## Version history

{{One line per capture of this source, newest first — omit the section entirely for a source captured once. Every capture gets its line, including the first, so no file in raw/ is unaccounted for.}}

- {{YYYY-MM-DD}} · raw/{{YYYY-MM-DD}}-{{slug}}.md · {{what changed in the claims, in one sentence — or "no claim changed" for formatting and typo churn}} · {{the reason the source itself gives, in quotes, or "reason not stated"}} · {{only what applies: moved from <old path> · resolves the contradiction on [[page]] · adopts the inference in [[page]] · restates [[page]], citing [[other source]]}}
- {{YYYY-MM-DD}} · raw/{{YYYY-MM-DD}}-{{slug}}.md — first capture
