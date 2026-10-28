# What may run unattended

## Fits

- Reading local files and producing a draft, outline, table, or report.
- Deterministic transforms over a known input set.
- Small code fixes **with a named test command acting as the gate**, where the check is "did a commit land", not the worker's own word.

## Never

- Anything needing a live browser login — a headless worker cannot get that session at 2am.
- Anything that **sends or shares** (mail, posts, messages, payments).
- Changes to the assistant's settings, credentials, or memory. Skills and scripts may be edited by a fenced runner, with each change easy to roll back; settings stay interactive.
- Large, tightly-coupled refactors: split across workers they collide on the same files; as one task they over-scope.

## The degradation symptom

An over-scoped task does not error. It **degrades**: low on room, the worker stops doing the real work and starts re-emitting its own input as if that were the deliverable. You wake up to a file that looks finished and contains nothing.

Watch for: output that paraphrases the input, headings with no content under them, byte size suspiciously close to the input size.

## The two splits

- **One section per task.** A report with named sections gets one worker per section, each with its own checkable output. Never ask one worker to do several sections.
- **Read, then write.** When a task must digest many sources before writing: a gather task reads everything and produces a plain outline (no prose); a draft task writes from the outline only and never re-opens the originals.

## The through-line

If completing the task needs judgement or a credential *as it happens*, it belongs in your day, not the queue.
