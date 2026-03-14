---
name: drawio-diagram-author
description: Create, edit, review, and refine `.drawio`, `.drawio.xml`, and `.xml` diagrams in this repository (especially block and electrical-component diagrams). Use when users request diagram work or mention flowcharts, architecture diagrams, system design visualization, or visualizing component/service flows. Use for template selection, direct mxGraphModel XML edits, PNG export for visual verification, and iterative mismatch fixing against reference images.
---

# Draw.io Diagram Authoring Skill

Use this skill when asked to create or modify `.drawio`/template XML diagrams in this repo.

## Scope

- Primary: block diagrams and mixed block + electrical diagrams.
- Priority input source: project-local references in `custom_references/` when that folder exists.
- Input source: existing templates in `references/drawio/src/main/webapp/templates/**`.
- Input source: new diagrams from scratch (`<mxfile><diagram><mxGraphModel>...`).
- Iterative visual matching from one or more user-provided reference images.
- Edit only `.drawio` or `.xml` diagram sources. Never manually edit generated `.drawio.png` files.

## Custom References Requirement

Before selecting templates, colors, fonts, or layout conventions, always check whether `custom_references/` exists in this skill directory.

If `custom_references/` exists:
- Read its contents first and treat them as the highest-priority project-specific style guidance.
- Look for reference diagrams, screenshots, notes, and style definitions such as `.drawio`, `.png`, `.jpg`, and `.md`.
- Prefer those references over generic defaults when they provide relevant guidance.
- If the folder contains multiple relevant references, synthesize them into one consistent style and mention that you used them.

Do not skip this lookup. It is a required early step for diagram work in this repository.

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
- `custom_references/`
- `references/drawio/src/main/webapp/templates/`
- `references/drawio/src/main/webapp/styles/default.xml`

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
  - Do NOT use text-label vertices as edge `source`/`target`. The orthogonal router creates bends when one endpoint is a small text cell at a misaligned position.
  - Instead, use explicit `sourcePoint`/`targetPoint` coordinates in `mxGeometry` and connect only one end to the block via `entryX/entryY` or `exitX/exitY` constraints.
  - Place the text label as a standalone vertex near the arrow endpoint (not connected to the edge).
- Multiple arrows on the same side of a block:
  - Pin each edge to a distinct connection point using `entryX/entryY` (for inputs) or `exitX/exitY` (for outputs) with different Y fractions (e.g. `0.25` and `0.75`).
  - Without explicit constraints the auto-router merges nearby edges into one overlapping path.
  - Treat `1 -> N` fanout from one block as a special case: distinct `entryY`/`exitY` values are required but may still be insufficient.
  - If the exported PNG shows a shared trunk segment before branches split, add explicit `mxPoint` waypoints so each branch is visually separate from the first segment leaving the block.
  - Unless the user explicitly asks for a bus, do not allow outputs to share any overlapping connector segment.

External signal arrow patterns (input arrow into left side at 25%, output arrow from left side at 75%):

```xml
<!-- Input: straight arrow from fixed point into block at entryY=0.25 -->
<mxCell id="lbl_in" value="sig_in" style="text;html=1;resizable=0;points=[];autosize=1;align=right;verticalAlign=middle;fontSize=16;fontFamily=Verdana;" parent="1" vertex="1">
  <mxGeometry x="10" y="135" width="80" height="30" as="geometry"/>
</mxCell>
<mxCell id="e_in" style="html=1;endArrow=block;endFill=1;startArrow=none;startFill=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" parent="1" target="block1" edge="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="100" y="150" as="sourcePoint"/>
  </mxGeometry>
</mxCell>

<!-- Output: straight arrow from block at exitY=0.75 to fixed point -->
<mxCell id="lbl_out" value="sig_out" style="text;html=1;resizable=0;points=[];autosize=1;align=right;verticalAlign=middle;fontSize=16;fontFamily=Verdana;" parent="1" vertex="1">
  <mxGeometry x="10" y="195" width="80" height="30" as="geometry"/>
</mxCell>
<mxCell id="e_out" style="html=1;endArrow=block;endFill=1;startArrow=none;startFill=0;exitX=0;exitY=0.75;exitDx=0;exitDy=0;" parent="1" source="block1" edge="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="100" y="210" as="targetPoint"/>
  </mxGeometry>
</mxCell>
```

Fanout anti-merge pattern (three distinct outputs, no shared trunk):

```xml
<mxCell id="e_out_a" style="html=1;endArrow=block;endFill=1;startArrow=none;startFill=0;exitX=1;exitY=0.2;exitDx=0;exitDy=0;" parent="1" source="block1" target="sinkA" edge="1">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="760" y="140"/>
      <mxPoint x="880" y="140"/>
    </Array>
  </mxGeometry>
</mxCell>
<mxCell id="e_out_b" style="html=1;endArrow=block;endFill=1;startArrow=none;startFill=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" parent="1" source="block1" target="sinkB" edge="1">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="760" y="200"/>
      <mxPoint x="880" y="200"/>
    </Array>
  </mxGeometry>
</mxCell>
<mxCell id="e_out_c" style="html=1;endArrow=block;endFill=1;startArrow=none;startFill=0;exitX=1;exitY=0.8;exitDx=0;exitDy=0;" parent="1" source="block1" target="sinkC" edge="1">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="760" y="260"/>
      <mxPoint x="880" y="260"/>
    </Array>
  </mxGeometry>
</mxCell>
```

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
  - no unintended merged connectors in any `1 -> N` fanout
  - visual comparison via exported PNG when export tooling is available
- If visual mismatch remains after 1-2 quick passes, escalate to Full Refinement.

2. Full Refinement (mandatory when rigor/auditability is required).
- Use when any of the following applies:
  - user asks for strict process, review trail, or checklist-driven work
  - multiple/conflicting references
  - ambiguous style contract
  - high-fidelity reproduction is critical
- Round 0 is mandatory before structural edits.

## Subagent Delegation

Delegate to subagents to keep main context clean. Never load multiple full diagram XMLs in main context unless the user explicitly asks for raw XML.

Delegate when any threshold is hit:
- file size > `150 KB`, or > `2` diagrams in one comparison, or > `3` candidate templates
- searching across `references/drawio/src/main/webapp/**` for templates/styles
- repeated export-and-inspect loops for visual refinement

Keep only decisions and deltas in main context; request concise semantic summaries from subagents.

| Operation | Delegate for | Expected return |
|---|---|---|
| Understand | Semantic extraction from diagram XML | Components + relationships summary |
| Modify | Targeted patching of existing diagram | Changes, affected IDs, validation status |
| Create | Template selection or scratch creation | New file path + component summary |
| Compare | Structural/style diff of two diagrams | Differences + recommended edit plan |

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
- `1 -> N` fanout does not share a trunk segment unless the target style explicitly calls for a bus.
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

Additional rules for Full Refinement:
- Require a no-regression check: previously passed checklist items must remain passed.
- Keep each round auditable with explicit inputs, findings, and delta plan.

## Rapid Convergence Rules

- When multiple reference images exist, treat the latest image as the target unless the user explicitly says otherwise.
- If primary reference or style direction is ambiguous, ask one concise blocking question before edits.
- Prefer minimal-delta revisions: change only the attributes needed to close visible gaps.
- Do not mix geometry and style changes in the same pass; separate passes reduce back-and-forth.
- Fix text fitting by adjusting font size/line breaks before resizing blocks.
- Keep connector semantics stable across revisions unless mismatch is explicit in the target.
- Preserve previously correct regions; avoid global restyling when only local mismatches are reported.

## Compression/Decompression Contract

Compress: `base64(deflateRaw(encodeURIComponent(xml)))`. Decompress: reverse.
Reference: `Graph.compress`/`Graph.decompress` in `references/drawio/src/main/webapp/js/grapheditor/Graph.js`.

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
