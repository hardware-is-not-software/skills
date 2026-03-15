# Preferred Shapes and Styles

This file is derived from:
- `references/Electrical.drawio`
- `references/block_diagram.drawio`

Use this together with `SKILL.md` (`drawio-diagram-author`): start from template, keep edits uncompressed while iterating, and reuse these styles for consistency.

## Selection Order

1. Reuse an existing template under `references/drawio/src/main/webapp/templates/`.
2. Reuse styles from this file before inventing new ones.
3. Keep a single visual language per diagram (block or electrical).

## Block Diagram Preferences

Observed pattern from `block_diagram.drawio`:
- Neutral instrument/control boxes
- Subtle shadow
- Consistent gray palette
- Elbow routing for signal flow

### Preferred block box style

```text
whiteSpace=wrap;html=1;shadow=1;fontSize=18;fillColor=#f5f5f5;strokeColor=#666666;
```

### Preferred emphasized header/title box style

```text
whiteSpace=wrap;html=1;shadow=1;fontSize=20;fillColor=#f5f5f5;strokeColor=#666666;strokeWidth=2;dashed=1;
```

### Preferred block connector style

```text
edgeStyle=elbowEdgeStyle;rounded=0;html=1;startArrow=none;startFill=0;jettySize=auto;orthogonalLoop=1;fontSize=18;elbow=vertical;
```

Use `elbow=vertical` when fanout branches from one controller/matrix to multiple instruments.

## Electrical Diagram Preferences

Observed pattern from `Electrical.drawio`:
- Real electrical symbols from `mxgraph.electrical.*`
- Wiring with orthogonal edges and no arrowheads
- Verdana typography (`fontSize=12` for symbols/wires, `fontSize=16` for labels)

### Preferred wiring edge style (main)

```text
edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;labelBackgroundColor=none;startArrow=none;startFill=0;startSize=5;endArrow=none;endFill=0;endSize=5;jettySize=auto;orthogonalLoop=1;strokeWidth=1;fontFamily=Verdana;fontSize=12
```

### Preferred measurement/annotation arrow style

```text
endArrow=classic;html=1;labelBackgroundColor=none;strokeWidth=1;fontFamily=Verdana;fontSize=16
```

### Preferred text label style for component IDs (R1, R2, ...)

```text
text;html=1;resizable=0;points=[];autosize=1;align=left;verticalAlign=top;spacingTop=-4;fontSize=16;fontFamily=Verdana
```

### Preferred base electrical symbol style fragment

```text
verticalLabelPosition=bottom;shadow=0;dashed=0;align=center;html=1;verticalAlign=top;
```

Add `shape=...` and optional `rotation=...` as needed.

## Preferred Electrical Shapes

Frequently used in `Electrical.drawio`:
- `mxgraph.electrical.miscellaneous.monocell_battery`
- `mxgraph.electrical.resistors.resistor_1`
- `mxgraph.electrical.logic_gates.logic_gate` (`operation=and|or|xor`, optional `negating=1`)

Also present and approved in the same file:
- `mxgraph.electrical.capacitors.capacitor_1`
- `mxgraph.electrical.inductors.inductor_3`
- `mxgraph.electrical.electro-mechanical.switchDisconnector`
- `mxgraph.electrical.diodes.diode`
- `mxgraph.electrical.mosfets1.mosfet_ic_n`
- `mxgraph.electrical.mosfets1.mosfet_ic_p`
- `mxgraph.electrical.miscellaneous.crystal_1`
- `mxgraph.electrical.radio.aerial_-_antenna_1`
- `mxgraph.electrical.signal_sources.vdd`
- `mxgraph.electrical.signal_sources.vss2`
- `mxgraph.electrical.logic_gates.buffer2`
- `mxgraph.electrical.logic_gates.d_type_flip-flop`
- `mxgraph.electrical.logic_gates.d_type_flip-flop_with_clear_2`
- `mxgraph.electrical.logic_gates.inverter_2`

## Shape Variant Gotchas

These distinctions cause the most wasted iterations. Check before choosing a shape.

### MOSFETs: IC-package vs bare symbol

| Need | Shape | Appearance |
|---|---|---|
| Bare schematic NMOS | `mxgraph.electrical.transistors.nmos` (w=70, h=110, fixed aspect) | Gate/drain/source lines, no circle |
| Bare schematic PMOS | `mxgraph.electrical.transistors.pmos` (w=70, h=110, fixed aspect) | Same, reversed arrow |
| IC-package NMOS | `mxgraph.electrical.mosfets1.mosfet_ic_n` (w=100, h=110) | Enclosed in circle |
| IC-package PMOS | `mxgraph.electrical.mosfets1.mosfet_ic_p` (w=100, h=110) | Enclosed in circle |

### Op-amp: no generic stencil exists

The `mxgraph.electrical.op_amps.*` library contains only specific circuits (Comparator, Inverting Amplifier, Integrator, etc.) — **not** a bare triangle op-amp. For a generic op-amp symbol, use a built-in triangle with manual +/- labels (see copy-paste example below).

### Ground symbols

| Need | Shape | Connection point |
|---|---|---|
| Standard signal ground (3 lines) | `mxgraph.electrical.signal_sources.signal_ground` (w=40, h=30) | **Top**: N at (0.5, 0) |
| VSS rail marker | `mxgraph.electrical.signal_sources.vss2` (w=60, h=40) | **Bottom**: S at (0.5, 1) — wire connects at the bottom, not top |

`vss2` connects at the **bottom** — do not use it as a standard ground expecting a top connection.

### Voltage / current sources

| Need | Shape | Notes |
|---|---|---|
| Battery (two-plate symbol) | `mxgraph.electrical.miscellaneous.monocell_battery` | Long/short plates, N=(0.5,0) S=(0.5,1) |
| DC source circle with arrow | `mxgraph.electrical.signal_sources.dc_source_2` | Shows current-direction arrow inside |
| DC source circle with +/- | Use plain `ellipse` + manual +/- text labels | No stencil provides this out of the box |

## Connection Point Reference (Pin Coordinates)

Coordinates are `(fractionX, fractionY)` relative to shape geometry. Multiply by `(width, height)` and add `(x, y)` for absolute position.

### NMOS bare (`transistors.nmos`)

- **Gate (W):** `(0, 0.5)` — left edge, mid-height
- **Drain (NE):** `(1, 0)` — right edge, top
- **Source (SE):** `(1, 1)` — right edge, bottom
- Arrow at **source** (bottom), pointing **right** (away from body)

### PMOS bare (`transistors.pmos`)

- **Gate (W):** `(0, 0.5)` — left edge, mid-height
- **Source (NE):** `(1, 0)` — right edge, top (connects to VDD)
- **Drain (SE):** `(1, 1)` — right edge, bottom
- Arrow at **source** (top), pointing **left** (toward body)

PMOS has Source and Drain **swapped** compared to NMOS (Source at top, Drain at bottom).

### MOSFET IC N/P (`mosfets1.mosfet_ic_n` / `mosfets1.mosfet_ic_p`)

- **Gate (G):** `(0, 0.72)` — left edge, below center
- **Drain (D):** `(0.7, 0)` — right-of-center, top
- **Source (S):** `(0.7, 1)` — right-of-center, bottom

### Resistor (`resistors.resistor_1`)

- **Left terminal:** `(0, 0.5)`
- **Right terminal:** `(1, 0.5)`
- With `rotation=-90`: left becomes **top**, right becomes **bottom**, rotated around geometry center.

### Signal Ground (`signal_sources.signal_ground`)

- **Top (N):** `(0.5, 0)`

## Minimal Copy-Paste Examples

### Block node

```xml
<mxCell id="blk-1" parent="1" value="Instrument" style="whiteSpace=wrap;html=1;shadow=1;fontSize=18;fillColor=#f5f5f5;strokeColor=#666666;" vertex="1">
  <mxGeometry x="600" y="450" width="120" height="60" as="geometry"/>
</mxCell>
```

### Electrical resistor (vertical)

```xml
<mxCell id="r-new" parent="1" value="" style="verticalLabelPosition=bottom;shadow=0;dashed=0;align=center;html=1;verticalAlign=top;strokeWidth=1;shape=mxgraph.electrical.resistors.resistor_1;rounded=1;comic=0;labelBackgroundColor=none;fontFamily=Verdana;fontSize=12;rotation=-90;" vertex="1">
  <mxGeometry x="350" y="240" width="100" height="20" as="geometry"/>
</mxCell>
```

### Generic op-amp (triangle with +/- labels)

No bare op-amp stencil exists. Build from a triangle and two text labels.

```xml
<mxCell id="opamp" value="" style="shape=triangle;direction=east;whiteSpace=wrap;html=1;fillColor=none;strokeWidth=1;perimeter=trianglePerimeter;" parent="1" vertex="1">
  <mxGeometry x="250" y="105" width="130" height="110" as="geometry"/>
</mxCell>
<mxCell id="opamp_minus" value="&lt;b&gt;&amp;minus;&lt;/b&gt;" style="text;html=1;resizable=0;points=[];autosize=1;align=center;verticalAlign=middle;fontSize=18;fontFamily=Verdana;" parent="1" vertex="1">
  <mxGeometry x="262" y="118" width="30" height="30" as="geometry"/>
</mxCell>
<mxCell id="opamp_plus" value="&lt;b&gt;+&lt;/b&gt;" style="text;html=1;resizable=0;points=[];autosize=1;align=center;verticalAlign=middle;fontSize=18;fontFamily=Verdana;" parent="1" vertex="1">
  <mxGeometry x="262" y="168" width="30" height="30" as="geometry"/>
</mxCell>
```

Pin positions for a 130×110 triangle at (250, 105): (-) input ≈ (250, 138), (+) input ≈ (250, 182), output ≈ (380, 160).

### Bare NMOS transistor

```xml
<mxCell id="q1" value="" style="verticalLabelPosition=bottom;shadow=0;dashed=0;align=center;html=1;verticalAlign=top;strokeWidth=1;shape=mxgraph.electrical.transistors.nmos;rounded=1;labelBackgroundColor=none;fontFamily=Verdana;fontSize=12;" parent="1" vertex="1">
  <mxGeometry x="420" y="105" width="70" height="110" as="geometry"/>
</mxCell>
```

Pin positions: Gate (420, 160), Drain (490, 105), Source (490, 215).

### Bare PMOS transistor

```xml
<mxCell id="q1" value="" style="verticalLabelPosition=bottom;shadow=0;dashed=0;align=center;html=1;verticalAlign=top;strokeWidth=1;shape=mxgraph.electrical.transistors.pmos;rounded=1;labelBackgroundColor=none;fontFamily=Verdana;fontSize=12;" parent="1" vertex="1">
  <mxGeometry x="420" y="105" width="70" height="110" as="geometry"/>
</mxCell>
```

Pin positions: Gate (420, 160), **Source** (490, 105), **Drain** (490, 215). Note reversed S/D vs NMOS.

### DC voltage source (circle with +/-)

No stencil gives a circle with +/- markers. Use a plain ellipse and overlay text.

```xml
<mxCell id="vsrc" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=none;strokeWidth=1;aspect=fixed;" parent="1" vertex="1">
  <mxGeometry x="65" y="170" width="60" height="60" as="geometry"/>
</mxCell>
<mxCell id="vsrc_plus" value="&lt;b&gt;+&lt;/b&gt;" style="text;html=1;resizable=0;points=[];autosize=1;align=center;verticalAlign=middle;fontSize=18;fontFamily=Verdana;" parent="1" vertex="1">
  <mxGeometry x="80" y="172" width="30" height="25" as="geometry"/>
</mxCell>
<mxCell id="vsrc_minus" value="&lt;b&gt;&amp;minus;&lt;/b&gt;" style="text;html=1;resizable=0;points=[];autosize=1;align=center;verticalAlign=middle;fontSize=18;fontFamily=Verdana;" parent="1" vertex="1">
  <mxGeometry x="80" y="202" width="30" height="25" as="geometry"/>
</mxCell>
```

Terminals: top (95, 170), bottom (95, 230).

### Signal ground

```xml
<mxCell id="gnd" value="" style="verticalLabelPosition=bottom;shadow=0;dashed=0;align=center;html=1;verticalAlign=top;strokeWidth=1;shape=mxgraph.electrical.signal_sources.signal_ground;rounded=1;labelBackgroundColor=none;fontFamily=Verdana;fontSize=12;" parent="1" vertex="1">
  <mxGeometry x="75" y="260" width="40" height="30" as="geometry"/>
</mxCell>
```

Connection: top at (95, 260).

### Electrical wire

```xml
<mxCell id="w-new" parent="1" source="a" target="b" edge="1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;labelBackgroundColor=none;startArrow=none;startFill=0;startSize=5;endArrow=none;endFill=0;endSize=5;jettySize=auto;orthogonalLoop=1;strokeWidth=1;fontFamily=Verdana;fontSize=12">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

## Guardrails

- Keep base cells present: `id="0"` and `id="1" parent="0"`.
- Prefer `compressed="false"` while editing.
- Do not mix block palette (`#f5f5f5/#666666`) and colorful styles unless explicitly requested.
- For electrical diagrams, keep arrows off on wires unless indicating direction/current.
