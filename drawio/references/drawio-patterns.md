# Draw.io Patterns (Block + Electrical)

Use these snippets when building diagrams from scratch or when patching template pages.

## Contents

1. Single-page uncompressed skeleton
2. Basic block trio with orthogonal connectors
3. Electrical chain (source -> switch -> resistor -> load -> ground)
4. Label and style notes

## 1) Single-page uncompressed skeleton

```xml
<mxfile host="app.diagrams.net" version="@DRAWIO-VERSION@" type="device" compressed="false">
  <diagram id="page-1" name="Page-1">
    <mxGraphModel grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## 2) Basic block trio with orthogonal connectors

Append inside `<root>` after ids `0` and `1`.

```xml
<mxCell id="b1" value="Input" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=12;" parent="1" vertex="1">
  <mxGeometry x="80" y="120" width="120" height="60" as="geometry"/>
</mxCell>
<mxCell id="b2" value="Processor" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontSize=12;" parent="1" vertex="1">
  <mxGeometry x="280" y="120" width="140" height="60" as="geometry"/>
</mxCell>
<mxCell id="b3" value="Output" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;fontSize=12;" parent="1" vertex="1">
  <mxGeometry x="500" y="120" width="120" height="60" as="geometry"/>
</mxCell>

<mxCell id="e1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=block;endFill=1;" parent="1" source="b1" target="b2" edge="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
<mxCell id="e2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=block;endFill=1;" parent="1" source="b2" target="b3" edge="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

## 3) Electrical chain (source -> switch -> resistor -> load -> ground)

This is a pragmatic, repo-safe electrical layout using generic shapes plus electrical labels.
If your environment has electrical stencil styles, you can replace styles later.

```xml
<mxCell id="src" value="24V DC Source" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" parent="1" vertex="1">
  <mxGeometry x="80" y="280" width="110" height="52" as="geometry"/>
</mxCell>

<mxCell id="sw" value="S1 (Switch)" style="rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" parent="1" vertex="1">
  <mxGeometry x="230" y="282" width="74" height="54" as="geometry"/>
</mxCell>

<mxCell id="r1" value="R1 220Ω" style="shape=hexagon;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
  <mxGeometry x="340" y="286" width="110" height="52" as="geometry"/>
</mxCell>

<mxCell id="load" value="Lamp (Load)" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" parent="1" vertex="1">
  <mxGeometry x="430" y="290" width="50" height="50" as="geometry"/>
</mxCell>

<mxCell id="gnd" value="GND" style="shape=triangle;direction=south;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;" parent="1" vertex="1">
  <mxGeometry x="520" y="298" width="46" height="46" as="geometry"/>
</mxCell>

<mxCell id="w1" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;endArrow=none;" parent="1" source="src" target="sw" edge="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
<mxCell id="w2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;endArrow=none;" parent="1" source="sw" target="r1" edge="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
<mxCell id="w3" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;endArrow=none;" parent="1" source="r1" target="load" edge="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
<mxCell id="w4" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;endArrow=none;" parent="1" source="load" target="gnd" edge="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

## 4) Label and style notes

- `value` supports escaped HTML, for example `&lt;b&gt;Controller&lt;/b&gt;`.
- Keep `parent="1"` unless intentionally nesting into containers.
- For clean editing/reviews, prefer uncompressed pages (`compressed="false"`).
- Before finalizing, verify edge endpoints (`source`/`target`) point to existing ids.
