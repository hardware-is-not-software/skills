# Full Refinement Workflow Reference

Use this reference when strict process traceability is required.

## Round 0 Setup

1. Create a working copy of `references/refinement_templates/target_reference.md`.
2. Record original prompt, all references, and one primary target reference.
3. Record style contract: shape family, palette, typography, connector style.
4. Create a working copy of `references/refinement_templates/acceptance_checklist.md`.
5. Convert expectations into binary checks (pass/fail).

## Editing Loop

For each round:

1. Create a working copy of `references/refinement_templates/round_review.md`.
2. Apply Pass A (structure): layout, hierarchy, connection routing.
3. Apply Pass B (visual): typography, fill/stroke, spacing, alignment.
4. Export PNG with stable settings.
5. Compare against acceptance checklist and record unresolved deltas only.
6. Run integrity checks:
   - unique ids
   - no dangling edge source/target
   - required base cells present
   - no text truncation/overflow
   - no low-contrast text
   - no unintended regressions from previously passed checks

## Exit Criteria

- Stop when all P0/P1 checklist items pass.
- Stop when blocked by missing user input that can materially affect output quality.
- Prefer `compressed="false"` while iterating; compress only on request or to match surrounding files.
