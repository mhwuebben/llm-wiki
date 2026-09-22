---
captured: 2026-09-20
source: https://example.com/retry-storms
author: P. Nkemelu
published: 2026-08-15
---

# Retry storms

When every client retries a failed call immediately, a brief outage becomes a sustained one: the retries themselves are the load. Exponential backoff with jitter spreads them out. A retry budget — a cap on the share of traffic that may be retries — bounds the amplification even when backoff is implemented badly. Retries interact with bounded queues: a shed request that is retried at once has not been shed at all.
