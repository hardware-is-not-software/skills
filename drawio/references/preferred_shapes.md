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
