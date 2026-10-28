#!/usr/bin/env bash
# idle-check.sh — tell "nothing to do" apart from "stuck", from a timer.
#
#   idle-check.sh <queue.md> <progress.stamp> [idle_limit_seconds]
#
#   exit 0 = EMPTY      queue has no pending items (healthy idle)
#   exit 1 = OK         pending items exist, progress is recent
#   exit 2 = STUCK      pending items exist, no progress for > limit
#   exit 3 = MISSING    the queue file itself is not readable
#
# Queue format: a line starting with "- [ ]" is pending; "- [x]" is done.
# Progress stamp: any file whose mtime you touch when real work lands.
#
# The point: liveness ("is the process alive") answers the wrong question.
# A worker can be alive, idle, and producing nothing — that is the failure
# this script exists to make visible. A watchdog that only checks liveness
# reports green all night while nothing happens.

set -uo pipefail

QUEUE=${1:?usage: idle-check.sh <queue.md> <progress.stamp> [idle_limit_seconds]}
STAMP=${2:?missing progress stamp path}
LIMIT=${3:-3600}

if [ ! -r "$QUEUE" ]; then
  echo "MISSING queue=$QUEUE — cannot judge idle without the queue"
  exit 3
fi

pending=$(grep -c '^- \[ \]' "$QUEUE" 2>/dev/null) || pending=0
done_=$(grep -c '^- \[x\]' "$QUEUE" 2>/dev/null) || done_=0

if [ "${pending:-0}" -eq 0 ]; then
  echo "EMPTY pending=0 done=${done_:-0} — nothing queued; this is healthy idle"
  exit 0
fi

if [ ! -e "$STAMP" ]; then
  echo "STUCK pending=$pending — no progress stamp at all: the run never started"
  exit 2
fi

now=$(date +%s)
mtime=$(stat -c %Y "$STAMP" 2>/dev/null || stat -f %m "$STAMP" 2>/dev/null || echo 0)
idle=$(( now - mtime ))

if [ "$idle" -gt "$LIMIT" ]; then
  echo "STUCK pending=$pending done=$done_ idle=${idle}s > ${LIMIT}s — queued work is not moving"
  exit 2
fi

echo "OK pending=$pending done=$done_ idle=${idle}s"
exit 1