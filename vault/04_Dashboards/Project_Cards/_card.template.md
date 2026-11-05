---
type: project-card-template
project: "{{Project Name}}"
area: "{{Area / Sub-area}}"
status: active
stage: "One or two sentences on where it stands today. Quote this value: it will contain a colon sooner or later."
progress: 10
blocker: "What is actually stopping it, and who it is on. Empty string if nothing."
next: "The single next physical action, specific enough to do without opening anything else. Prefix with the person: OPERATOR: ... or US: ..."
link: "[[{{Project Name}} Handoff]]"
updated: "{{today}}"
---

One paragraph on what this project is and why it exists. The frontmatter above is what the board renders; this body is for context.

Handoff: [[{{Project Name}} Handoff]]

## Card rules

- Change `type:` to `project-card` when you copy this. The board ignores `project-card-template` so this file never renders.

- `status` is one of `waiting` (on the operator), `active`, `paused`, `closed`. Add `closed: YYYY-MM-DD` when closing.
- Move `updated:` every time anything above changes. A card that has not moved in 14 days is probably lying.
- Quote any value with a colon, an emoji, or a leading special character. `check-cards.sh --fix` repairs single-line offenders.
- Delete this section when you copy the template.
