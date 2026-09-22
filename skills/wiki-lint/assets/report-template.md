# Lint report — {{YYYY-MM-DD}}

**Scope:** {{full pass | delta since YYYY-MM-DD}} · **Pages:** {{n}} ({{count per type — sources, concepts, entities, notes, and any the schema adds}}) · **Last lint:** {{date or "first pass"}}

## The three things worth your attention

1. {{highest-value finding, one line, with the link}}
2. {{second}}
3. {{third}}

## Health at a glance

| Check | Findings | Severity |
|---|---|---|
| Broken links / duplicate names | {{n}} / {{n}} | {{high/medium/low}} |
| Orphan pages | {{n}} | |
| Duplicate pages / sync conflict copies | {{n}} / {{n}} | |
| Missing pages | {{n}} | |
| Contradictions | {{n}} ({{m}} unflagged) | |
| Stale claims / propagation gaps | {{n}} / {{n}} | |
| Uncited claims / support sample | {{n}} / {{x}} of {{m}} sampled claims not supported ({{k}} pages) | |
| Index drift | {{n}} rows | |
| Frontmatter issues / placement and subject proposals | {{n}} / {{n}} | |
| Thin / bloated pages; sources without Entities and concepts; grouping, subject and split proposals | {{n}} / {{n}}; {{n}}; {{n}} | |
| Unprocessed / orphaned sources | {{n}} pending / {{n}} orphaned / {{n}} ghost / {{n}} stray / {{n}} broken embed / {{n}} conflict copies in `raw/` | |
| Out-of-scope / expired sources | {{n}} / {{n}} | |
| Work that left no trace | {{n}} unlogged page changes / {{n}} gaps or notes with material pending / {{n}} sources that propagated nothing | |

## Findings

### Fix on approval — mechanical

{{Broken links, index rows, check 9's mechanical fields — applied as soon as this report was written, before anything was put to you. One line each: page, what was wrong, what it now says. A fix that would have rewritten the text of many pages is listed under judgement instead, waiting for a yes.}}

### Needs your judgement

{{Merges, retirements, splits, superseded claims, duplicate names, placement, subject and grouping proposals, propagation gaps, source pages without an Entities and concepts section, the support sample. One block each — except propagation gaps, source pages without the section, subject proposals and the support sample, which are grouped as below:}}

**{{[[page-a]]}} and {{[[page-b]]}} look like the same thing**
- Evidence: {{shared sources, near-identical summaries}}
- Proposed: merge into {{[[page-a]]}}, alias the other name, repoint {{n}} inbound links
- Risk: {{what you'd lose}}

**Propagation gaps — {{n}} pages, {{m}} missing citations** (check 6)

| Page | Sources naming it without a citation | Proposed |
|---|---|---|
| {{[[page]]}} | {{n}}: {{[[source]]}}, {{[[source]]}}, … | {{one pass over the page: what each source's line says it adds, with the source link — or [[source]] off that source's list}} |

**{{n}} source pages have no Entities and concepts section** (check 10): {{[[source]]}}, {{[[source]]}}, … — proposed: add it to each, from the pages it already links.

**Pages that cite a source that doesn't name them — {{n}} sources** (check 6, the reverse direction): {{[[source]]}} → add {{[[page]]}}, {{[[page]]}}; …

**Subject proposals — {{subject}}: {{n}} pages** (check 9): {{[[source]]}} ({{now}} → {{proposed}}, {{k}} of {{m}} linked pages lean to it), …

**Support sample — {{m}} claims on {{k}} pages** (check 7)

| Page | Tested | Supported | Not supported — claim, source, outcome, proposed fix |
|---|---|---|---|
| {{[[page]]}} | {{3}} | {{2}} | {{claim}} — {{[[source]]}} — {{only in raw / not in the source / contradicted / not backed by raw}} — {{fix}} |

### Contradictions

| Claim | Page A | Page B | What would settle it |
|---|---|---|---|
| {{claim}} | {{[[page]]}} ({{date}}) | {{[[page]]}} ({{date}}) | {{source or check}} |

### Stale

| Page | Claim | Last updated | Why suspect |
|---|---|---|---|

## Gaps and next moves

**Questions the wiki is close to answering**
- {{question}} — needs {{what}}

**Sources worth finding**
- {{specific source}} — would settle {{what}}

**Shape of the wiki**
{{Where it's dense, where it's one page deep, and whether that matches what this wiki is for.}}

## Applied this pass

{{The mechanical fixes applied before this report, plus whatever the person then approved. Also goes in _meta/log.md.}}
