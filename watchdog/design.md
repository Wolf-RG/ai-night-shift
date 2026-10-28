# Making "did nothing" visible

A watchdog that only checks "is the process alive" will report green all night while nothing happens. These are the six things that turned silence into a signal.

1. **Idle proof, not liveness.** Distinguish *empty queue* (healthy idle) from *pending items but no progress* (stuck). Only the second is an alert. Concretely: `pending + running > 0` and `idle_hours > 1` ⇒ BAD.
2. **Alert by id, with cooldown.** Key alerts on a stable id, not on the message text; 2h cooldown; reset the cooldown when the alert clears. Otherwise one incident mails you every 30 minutes forever, and you stop reading mail.
3. **Fresh vs stale state.** If the state file was not rewritten this round, do not mail a conclusion derived from it. Recompute first; a cached number is a rumour.
4. **`WARN` is not `RUNNING`.** "There is an unread letter waiting" is not "everything is fine". A console that paints WARN as RUNNING trains you to ignore it.
5. **Per-row time windows.** A job that only runs 22:00–07:00 must not be declared DEAD at noon. Every monitored row needs its own window.
6. **Staleness by hash.** If a "reviewed" ledger stores file fingerprints, store **absolute** paths and a content hash. Relative paths silently invalidate every fingerprint the day you change directory — and then the whole ledger reads as stale at once.
