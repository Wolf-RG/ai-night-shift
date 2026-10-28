# 03 · Two triggers, one model state: `load` → 500, state stuck on `loading`

**Symptom.** `load` returned HTTP 500. The state file stayed on `loading` for hours. Every later check read that file and concluded "still starting".

**Cause.** A `systemd` timer and a manually started script both decided the model needed reloading, at the same minute, and both wrote the same state file.

**Fix.** A single file lock around the whole reload, non-blocking:

```sh
exec 9>/tmp/reload.lock
flock -n 9 || { echo "another reload in progress"; exit 0; }
```

Two details that bit afterwards:

- The script re-invokes itself for a sub-step; the child inherited the lock attempt and deadlocked against its parent. Pass an environment flag (`NO_LOCK=1`) so the child skips the lock it already holds.
- `exit 0` on contention is deliberate: contention is not a failure, and a failed unit triggers restart storms.

**Rule.** Every path that mutates shared state takes the lock first — not "eventually", not "in the retry".
