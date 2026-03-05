---
name: drawio-diagram-author
description: Create, edit, review, and refine `.drawio`, `.drawio.xml`, and `.xml` diagrams in this repository (especially block and electrical-component diagrams). Use when users request diagram work or mention flowcharts, architecture diagrams, system design visualization, or visualizing component/service flows. Use for template selection, direct mxGraphModel XML edits, PNG export for visual verification, and iterative mismatch fixing against reference images.
---

# Draw.io Diagram Authoring Skill

Use this skill when asked to create or modify `.drawio`/template XML diagrams in this repo.

## Scope

- Primary: block diagrams and mixed block + electrical diagrams.
- Input source: existing templates in `references/drawio/src/main/webapp/templates/**`.
- Input source: new diagrams from scratch (`<mxfile><diagram><mxGraphModel>...`).
- Iterative visual matching from one or more user-provided reference images.
- Edit only `.drawio` or `.xml` diagram sources. Never manually edit generated `.drawio.png` files.
- Japanese-specific typography guidance is out of scope for this skill.

## Fast Template Selection

Pick the closest template first, then modify content.

Block-focused templates:
- `references/drawio/src/main/webapp/templates/other/block.xml`
- `references/drawio/src/main/webapp/templates/basic/flowchart.xml`
- `references/drawio/src/main/webapp/templates/flowcharts/flowchart_1.xml`

Electrical-focused templates:
- `references/drawio/src/main/webapp/templates/engineering/electrical_1.xml`
- `references/drawio/src/main/webapp/templates/engineering/electrical_2.xml`

If a template already has the right structure, prefer editing it over writing from scratch.

For copy-paste starter patterns (block and electrical), read:
- `references/drawio-patterns.md`
- `references/preferred_shapes.md`

High-value sources for style/template decisions:
- `references/drawio/src/main/webapp/templates/`
- `references/drawio/src/main/webapp/styles/default.xml`

Round bookkeeping templates:
- `references/refinement_templates/target_reference.md`
- `references/refinement_templates/acceptance_checklist.md`
- `references/refinement_templates/round_review.md`

## .drawio Structure To Produce

A valid file is an `<mxfile>` root with one or more `<diagram>` pages.
Each `<diagram>` contains either:

1. Uncompressed XML child node: `<mxGraphModel> ... </mxGraphModel>`.
2. Compressed text content: Base64 text representing `deflateRaw(encodeURIComponent(mxGraphModelXml))`.

Minimal uncompressed shape:

```xml
<mxfile host="app.diagrams.net" version="@DRAWIO-VERSION@" type="device" compressed="false">
  <diagram id="page-1" name="Page-1">
    <mxGraphModel>
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <!-- vertices and edges -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## Cell Authoring Rules

- Always include base cells `<mxCell id="0"/>` and `<mxCell id="1" parent="0"/>`.
- Vertex cell requirements: `vertex="1"`, `parent="1"` (or a container id), and `mxGeometry` with `x`, `y`, `width`, `height`, `as="geometry"`.
- Edge cell requirements: `edge="1"`, `source="..."`, `target="..."`, `parent="1"`, and `mxGeometry relative="1" as="geometry"`.
- `style` is semicolon-separated key/value pairs.
- Escape rich text in `value` if needed (HTML entities).

## Style Guidance For Requested Diagram Types

Block diagrams:
- Use rounded rectangles or process/step shapes.
- Keep palette consistent for functional groups.
- Use orthogonal edges unless user asks for curved wiring.
- External signal arrows (stub arrows entering/leaving a block from outside):
  - Do NOT use text-label vertices as edge `source`/`target`. The orthogonal router cannot keep the line straight when one endpoint is a small text cell at a different position.
  - Instead, use explicit `sourcePoint`/`targetPoint` coordinates in `mxGeometry` and connect only one end to the block via `entryX/entryY` or `exitX/exitY` constraints. This produces a perfectly straight line.
  - Place the text label as a standalone vertex near the arrow endpoint (not connected to the edge).
- Multiple arrows on the same side of a block:
  - Pin each edge to a distinct connection point using `entryX/entryY` (for inputs) or `exitX/exitY` (for outputs) with different Y fractions (e.g. `0.25` and `0.75`).
  - Without explicit constraints the auto-router merges nearby edges into one overlapping path.

Electrical components:
- Reuse electrical template styles/layout direction first.
- Keep connection topology explicit with edge source/target ids.
- Use text labels for component names, ratings, or ports where needed.
- If label anchoring behaves unexpectedly, use explicit `sourcePoint`/`targetPoint` coordinates on edges.

Container/frame spacing:
- Keep at least `24-30px` margin between a background container and internal elements.
- Re-check frame overflow in PNG after geometry or font changes.

## Workflow Modes

Choose one mode explicitly before editing:

1. Fast Path (default for straightforward single-image conversions).
- Use when there is one clear reference and no explicit request for process artifacts.
- Skip creating working copies of `references/refinement_templates/*`.
- Still perform core quality checks:
  - valid XML
  - required base cells
  - no dangling edges
  - visual comparison via exported PNG when export tooling is available
- If visual mismatch remains after 1-2 quick passes, escalate to Full Refinement.

2. Full Refinement (mandatory when rigor/auditability is required).
- Use when any of the following applies:
  - user asks for strict process, review trail, or checklist-driven work
  - multiple/conflicting references
  - ambiguous style contract
  - high-fidelity reproduction is critical
- Round 0 is mandatory before structural edits.

## Subagent Usage (Large Inputs)

Use subagents to keep main-context usage low when the task requires broad scanning of large draw.io source trees.

- Hard rule: avoid loading multiple full diagram XML files in main context unless the user explicitly asks for raw XML inspection.
- Hard rule: if operation scope is broad, delegate extraction/comparison and keep only decisions/deltas in main context.
- Delegate by default when any threshold is hit:
  - file size over `150 KB`
  - more than `2` diagrams/pages in one comparison task
  - more than `3` candidate templates for base selection
- Delegate when searching across `references/drawio/src/main/webapp/**` for template/style internals.
- Delegate when comparing many candidate templates before selecting one base template.
- Delegate when doing repeated export-and-inspect loops for visual refinement.
- Keep returns concise: selected template path, key style tokens, and concrete patch plan (no large raw file dumps).

Main agent should keep only the final decisions and deltas in context.

## Delegation Templates

### Understand Diagram

```
Task: Extract and explain structure in [file.drawio|file.xml]

Approach:
1. Read diagram XML or decode compressed page content when needed
2. Extract semantic elements (labels, containers, connectors, groups)
3. Identify relationships and flow direction
4. Summarize architecture/flow without raw XML dump

Return:
- Components/elements with brief roles
- Connector relationships
- Key layout/style observations relevant to requested task
- No full raw XML unless explicitly requested
```

### Modify Diagram

```
Task: Add/update [component/change] in [file] while preserving existing structure

Approach:
1. Identify target page and related element IDs
2. Apply minimal-delta XML edits
3. Preserve existing valid regions and connector semantics
4. Validate XML integrity and edge references

Return:
- What changed
- IDs affected/created
- Any assumptions made
- Validation status
```

### Create Diagram

```
Task: Create a new Draw.io diagram for [description]

Approach:
1. Select closest base template or start minimal uncompressed mxGraphModel
2. Add required components and connectors
3. Apply consistent style tokens and spacing
4. Export PNG (when tooling available) for verification

Return:
- File path created
- Main components included
- Template source (or scratch)
- Export/verification status
```

### Compare Diagrams

```
Task: Compare [file1] and [file2] for architecture and style differences

Approach:
1. Extract semantic elements and relationships from each
2. Compare structure, flows, and visible style conventions
3. Identify additions/removals/reroutes

Return:
- Key structural differences
- Key style/layout differences
- Recommended merge/next edit plan
- No large XML payloads
```

## Red Flags - Stop and Delegate

- About to open many template/style files only to shortlist candidates.
- About to compare multiple large diagrams side-by-side in main context.
- About to paste full XML into the user response without explicit request.
- About to run repeated inspect loops while keeping every prior dump in context.
- About to read compressed pages from several files just for component names.

If any red flag appears, delegate and request concise semantic summaries.

## Common Rationalizations (Avoid)

| Rationalization | Why it is risky | Correct action |
|---|---|---|
| "It is just one quick XML check" | Quick checks still load high-noise structure and IDs | Delegate extraction of needed fields |
| "Single file means safe to read directly" | A single large diagram can still pollute context | Apply thresholds and delegate when hit |
| "I need full XML to compare" | Most comparisons are semantic, not raw-token complete | Delegate compare and keep diff summary |
| "I will paste XML so user sees everything" | Large payload harms usability and review speed | Return concise summary plus file path |

## Operation Quick Reference

| Operation | Main agent action | Expected subagent return |
|---|---|---|
| Understand | Delegate semantic extraction | Components + relationships summary |
| Modify | Delegate targeted patching | Changes, affected IDs, validation status |
| Create | Delegate template/scratch creation | New file path + component summary |
| Compare | Delegate semantic diff | Structural/style differences + plan |

## PNG Conversion Script

Use [`scripts/convert-drawio-to-png.sh`](scripts/convert-drawio-to-png.sh) for stable PNG export.

```bash
# Single file
bash scripts/convert-drawio-to-png.sh references/example/reproduction.drawio

# Multiple files
bash scripts/convert-drawio-to-png.sh references/block_diagram.drawio references/Electrical.drawio
```

Notes:
- Script auto-detects `drawio`, `draw.io`, or `/Applications/draw.io.app/Contents/MacOS/draw.io`.
- If draw.io CLI is not installed, it prints guided install steps (Homebrew/manual) and exits clearly.
- In sandboxed environments, draw.io CLI export can fail with a crash (for example `Abort trap: 6`).
  - Retry the same export command with elevated permissions before changing diagram content.
  - Continue refinement only after at least one successful PNG export.
- Export contract:
  - Keep transparent background.
  - Use consistent scale across rounds.
  - Re-export and visually verify after any geometry/style edit.

## Quick QA Checklist (Fast Path + Full Refinement)

- XML is valid and base cells (`id=0`, `id=1`) exist.
- No dangling `source`/`target` edge references.
- External signal arrows are straight (no unnecessary bends from auto-routing through text-label vertices).
- Multiple arrows entering/leaving the same block side are visually distinct (not merged/overlapping).
- No text truncation, clipping, or overlap at target export scale.
- Arrow labels are readable and not colliding with connectors.
- Background/frame containers keep internal margin and no overflow.
- Text contrast is readable against fill colors.
- Exported PNG matches latest agreed target reference.

## Workflow (Full Refinement)

Use this mode when rigor or auditability is required.

1. Capture target reference and style contract.
2. Clarify one blocking ambiguity before Round 1 when primary reference/style is unclear.
3. Define binary pass/fail acceptance checks.
4. Choose a base template and switch to uncompressed editing during iteration.
5. Run rounds: `generate -> export png -> inspect -> patch`.
6. Validate XML integrity and no-regression after each round.
7. Exit when all P0/P1 checks pass or work is blocked by missing user input.

Detailed step template and round bookkeeping:
- `references/full-refinement-workflow.md`
- `references/refinement_templates/target_reference.md`
- `references/refinement_templates/acceptance_checklist.md`
- `references/refinement_templates/round_review.md`

## Rapid Convergence Rules

- When multiple reference images exist, treat the latest image as the target unless the user explicitly says otherwise; state this assumption briefly and proceed.
- If primary reference or style direction is ambiguous, ask one concise blocking question before edits.
- Prefer minimal-delta revisions: change only the attributes needed to close visible gaps.
- Do not mix geometry and style changes blindly; separate passes reduce back-and-forth.
- Fix text fitting by adjusting font size/line breaks before resizing blocks.
- Keep connector semantics stable across revisions (direction, endpoints, routing family) unless mismatch is explicit in the target.
- Preserve previously correct regions; avoid global restyling when only local mismatches are reported.
- In Full Refinement mode, require a no-regression check: previously passed checklist items must remain passed.
- In Full Refinement mode, keep each round auditable with explicit inputs, findings, and delta plan.

## Compression/Decompression Contract

When converting page content:

- Compress page model text with `Graph.compress(...)` semantics used by repo:
  `base64(deflateRaw(encodeURIComponent(xml)))`.
- Decompress with reverse operation.

Reference implementations in repo:

- `references/drawio/src/main/webapp/js/grapheditor/Graph.js` (`Graph.compress`, `Graph.decompress`, `Graph.compressNode`)
- `references/drawio/src/main/webapp/js/diagramly/Editor.js` (`Editor.parseDiagramNode`, `Editor.getDiagramNodeXml`)

## Deliverable Expectations

When making diagram changes:

- Modify or create the target `.xml`/`.drawio` file directly.
- Keep formatting stable and readable when uncompressed.
- Briefly summarize template chosen (or scratch), main cells/components added, and whether output is compressed or uncompressed.
- Do not return full diagram XML by default.
- Return concise user-facing output:
  - changed file path(s)
  - what changed semantically
  - validation results (XML/edge checks)
  - export result for visual verification (when tooling is available)
