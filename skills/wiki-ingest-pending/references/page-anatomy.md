# Page anatomy

## The test every page has to pass

Someone who hasn't read the source opens this page in six months. Can they (a) understand the thing, (b) tell where each claim came from, (c) see what it connects to, and (d) know what's still unknown? If yes, the page is done. Length is not the measure.

## Source page

Purpose: replace the need to reopen the original for everyday use, while making the original easy to find when precision matters.

```markdown
---
type: source
title: Attention Is All You Need
aliases: [transformer paper]
tags: [architecture, nlp]
created: 2026-09-20
updated: 2026-09-20
status: solid
raw: raw/2026-09-20-attention.md
asset: [raw/assets/2026-09-20-attention.pdf]
author: Vaswani et al.
published: 2017-06-12
url: https://arxiv.org/abs/1706.03762
---

# Attention Is All You Need

**What it is:** 2017 NeurIPS paper introducing the transformer, a sequence architecture built on attention alone, with no recurrence or convolution.

## Summary

- Replaces recurrence with self-attention, so positions are computed in parallel rather than in sequence — the core practical win.
- Adds multi-head attention: several attention operations in parallel, each attending to a different representation subspace.
- Position information is injected with sinusoidal encodings, since attention itself is order-blind.
- Beats prior state of the art on WMT 2014 EN-DE and EN-FR at a fraction of the training cost.

## Key claims

- Training took 3.5 days on 8 GPUs for the big model — a large reduction against comparable recurrent systems, though the comparison is against 2016-era baselines.
- Attention layers connect any two positions in constant path length, against linear for recurrence. This is the argument for why long-range dependencies get easier.

## Entities and concepts

- [[transformers]] — first full description of the architecture
- [[self-attention]] — mechanism and the scaled dot-product formulation
- [[multi-head-attention]] — why several heads beat one wide one
- [[vaswani-et-al]] — authors, Google Brain / Google Research

## Notable details

- Scaling factor 1/√d_k in the dot-product, to keep softmax gradients from vanishing at large dimension.
- Base model: 6 encoder and 6 decoder layers, d_model 512, 8 heads.

## How it sits with the rest of the wiki

Confirms the direction in [[sequence-models]]. Supersedes the claim on [[rnn-scaling-claims]] that recurrence was the bottleneck-free option for long sequences.

> [!warning] Contradiction
> [[rnn-scaling-claims]] (2015 survey) argues recurrence scales acceptably to long sequences. This paper measures otherwise, on different benchmarks. Unresolved — the benchmarks aren't comparable.

## Open questions

- How much of the gain is the architecture versus the training recipe?
- Does the parallelism advantage hold at small scale?
```

**Failure modes:** a wall of prose; bullets that restate the abstract without saying anything; no links; no numbers; hedging everywhere so no claim is checkable; "this paper discusses several important topics".

## Entity page

Purpose: everything the wiki knows about one actor, accumulated across sources, with the disagreements visible.

Structure that holds up: one-line identification → what we know (each claim with its source link) → relationships (links out) → interpretation (labelled) → open questions.

Rules of thumb:

- Claims are grouped by theme, not by source. A page organised as "what source A said, what source B said" is a filing cabinet, not a wiki page.
- Where two sources disagree about the same fact, both appear, dated.
- The one-liner gets rewritten as understanding improves. It's the sentence that shows up in the index and in query answers, so it earns the attention.

## Concept page

Purpose: the explanation you'd want if you had to teach it, plus the evidence and the contested edges.

Definition → how it works → evidence table → related concepts (with *how* they relate, not just links) → interpretation → open questions.

The evidence table is what separates a concept page from a blog post:

| Claim | Support | Source |
|---|---|---|
| Parallel training cuts wall-clock time | 3.5 days vs weeks, 8 GPUs | [[attention-is-all-you-need]] |
| Advantage narrows below 1B params | single ablation, n=3 | [[small-model-study]] |

Weak evidence stated as weak evidence is worth more than confident prose.

## Note page (filed answers)

Written by wiki-query when an answer is worth keeping — including the synthesis behind a deck or document it makes — and by wiki-dream-ingest for an accepted dream finding — tagged `synthesis`, with the connecting step marked *(inference)*. Every new note starts `status: developing`: a synthesis is not something to defend on its first day. A note is a dated answer — refreshed on purpose when its question comes up again, never rewritten by ingest — and its `answered:` field records when the answer was last written or refreshed. For a filed answer: question as title, answer up front, reasoning below, plus what the wiki couldn't cover — that last section is the best source of the next reading list.

## Style, across all page types

- Present tense for what holds; dated past tense for what was observed.
- Short sections. Tables where things are comparable. No throat-clearing.
- Second person never; this is a reference, not a letter.
- Quote sparingly — a line or two, in quotes, with the link. The wiki compiles; it doesn't copy.
- `status:` is honest: `stub` (a name and a line), `developing` (real content, gaps known), `solid` (would defend it).
- Length: most pages 300–800 words. When a page sprawls, split it along the natural seam and link both halves.
