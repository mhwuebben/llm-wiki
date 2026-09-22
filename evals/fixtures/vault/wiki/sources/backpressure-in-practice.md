---
type: source
title: Backpressure in practice
created: 2026-09-02
updated: 2026-09-02
status: solid
raw: raw/2026-09-02-backpressure-in-practice.md
author: J. Rivera
published: 2025-11-04
---

# Backpressure in practice

**What it is:** a practitioner's account of shedding load at the edge of a service.

## Summary

- An unbounded queue hides overload as latency until callers time out.

## Key claims

- A queue with no upper bound turns overload into unbounded latency — rather than a visible, early failure.

## Entities and concepts

- [[backpressure]] — names the mechanism and gives the unbounded-queue failure mode.

## Open questions

- Does shedding at the edge beat rate limiting upstream?
