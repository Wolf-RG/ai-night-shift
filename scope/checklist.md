# Twelve checks before you walk away from tonight's queue

Print this, or paste it as the comment at the top of the queue file. Every item is a thing that has actually cost someone a night.

1. **Four fields, all present.** Source, Output, Method, Done-means. An entry missing one is a wish, not a task.
2. **Every Source was listed, not assumed.** `ls` the folder, count the files, spot-check one URL — at the desk.
3. **Every entry fits the bound** (~10 minutes of agent work). If it doesn't, split it: one section per task, or read-then-write.
4. **Nothing sends, shares, posts, or pays.** Unattended means no outward action, ever.
5. **Nothing touches credentials, settings, or memory.** Those stay interactive.
6. **Nothing needs a browser login.** A headless worker cannot acquire a session at 2am.
7. **Outputs are new paths** (or explicitly versioned). No entry overwrites its own input.
8. **Each entry names a machine-checkable verification.** "Looks good" is not a check; "row count == 0 in the old table" is.
9. **The queue has a stop rule.** When it is empty, the worker stops. It does not invent work to look busy.
10. **The watchdog can tell empty from stuck.** "Pending items exist and nothing moved for an hour" must raise a different signal than "queue is empty".
11. **Alerts are keyed by id with a cooldown.** One incident should not mail you every 30 minutes until you stop reading mail.
12. **A rollback line exists** for anything destructive: what moves where, and the one command that undoes it.

## The one failure this list is built to catch

An over-scoped task does not error. It **degrades** — the worker runs out of room and starts re-emitting its own input as the deliverable. You wake up to a file that looks finished and contains nothing.

Symptom to check in the morning: output size suspiciously close to input size, headings with no content, prose that paraphrases the source instead of transforming it.

See `rules.md` for the splits, and `../watchdog/idle-check.sh` for the empty-vs-stuck distinction.