# /learn — Gotchas

## 1. Creating a state file

NEVER create a state file. Pipeline state is derived from the file system on every
invocation. If you find yourself writing JSON or YAML to track "current step," stop.

## 2. Skipping states

The routing table is sequential — first match wins. If input exists but research
doesn't, you MUST route to `/learn:research`, never to `/learn:structure`. Do not
jump ahead because files "look close enough."

## 3. Batch processing in State 3

Process ONE topic at a time: `/learn:structure {slug} {topic}` then
`/learn:review {slug} {topic}`, then move to the next incomplete topic.
Never run structure on all topics before starting review.

## 4. Missing slug argument

When no `{system-slug}` is provided, scan `2-LEARN/input/` for existing
`learn-input-*.md` files and present options. Do not error silently or assume a default.
