---
type: source
title: {{Title}}
aliases: []
tags: []
created: {{YYYY-MM-DD}}
updated: {{YYYY-MM-DD}}
status: solid
raw: raw/{{YYYY-MM-DD}}-{{slug}}.md                  # always the markdown in raw/, never raw/inbox/
# raw_previous: []                                  # earlier captures of this source, newest first; omit if none
asset: [raw/assets/{{YYYY-MM-DD}}-{{slug}}.{{ext}}]  # list: the original plus any attachments, under this stem (images Obsidian saved keep their own names); omit if none
# expires: {{YYYY-MM-DD}}                            # add only if the source states its own end date
# scope: "override — {{rule it fails}}"             # only if ingested against schema §1's scope on the owner's say-so
author: {{Author}}
published: {{YYYY-MM-DD}}   # the date the source states (YYYY or YYYY-MM if that is all); omit if unknown — never the capture date
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
