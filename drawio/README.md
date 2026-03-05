# Claude Skill for draw io

Create diagrams .drawio format using LLM.

## Prompt Guide

Style reference requirement:
- Prompt should include a style reference as either:
  - reference `.drawio` file, or
  - reference image (`.png`/`.jpg`), or
  - explicit verbal style contract.
- If style reference is missing, ask the user before editing:
  - Do you want to provide a reference image,
  - give a verbal style direction,
  - or use the default style?

Use this prompt pattern when converting an image to draw.io:

```text
Create drawio diagram and use SKILL.md instructions.
Convert the attached image to a .drawio file.
Match layout, connectors, and styling as closely as possible.
Output as uncompressed XML (compressed="false").
Save as: <target-file-name>.drawio
```

For iterative refinement, use:

```text
Use SKILL.md and update the existing .drawio to match this new reference image.
Keep geometry unless mismatch is visible; adjust style/text first.
```

To export a draw.io file to PNG, use the repo script:
```bash
bash scripts/convert-drawio-to-png.sh references/example/reproduction.drawio
```

If `drawio` is not installed, the script prints install guidance automatically.
If `drawio` is installed but export fails, the script also prints troubleshooting steps.

Manual install options:
```bash
# macOS
brew install --cask drawio
```

Then verify:
```bash
drawio --version
# or
draw.io --version
```

Use this prompt pattern when converting text requirements to draw.io:

```text
Create drawio diagram and use SKILL.md instructions.
Create a .drawio diagram from this text description:
<paste system/components/flows here>

Requirements:
- Use clear block structure and orthogonal connectors.
- Keep naming exactly as provided.
- Group related components visually.
- Output as uncompressed XML (compressed="false").
- Save as: <target-file-name>.drawio
```

## Match Criteria Checklist

Use this checklist before finalizing a reproduction:
- Layout and topology match the reference.
- Text labels and font scale are visually consistent with the reference.
- Line and arrow thickness are consistent with the reference.
- Export dimensions/scale are aligned with the target (allow small export tolerance).
