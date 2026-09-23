#!/bin/sh
# Copy the canonical fixture vault into each behaviour case.
# `context.add_dirs` may only name something inside the case directory, so every
# case that needs a vault keeps its own copy. Edit evals/fixtures/vault, then run this.
cd "$(dirname "$0")" || exit 2
for case in ingest-propagates scope-refusal query-honesty combined-refusal; do
  [ -d "$case" ] || continue
  rm -rf "$case/vault"
  cp -R fixtures/vault "$case/vault"
  printf 'synced: %s/vault\n' "$case"
done
