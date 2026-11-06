# typst-grid-layout

A prototype DSL for reusable grid layouts in Typst.

## API

Define layouts with `grid()`:

```typ
#import "src/lib.typ": grid, layout, col, apply

#show: apply

#let compact-s = grid(
  columns: 5,
)

#let entries = grid(
  columns: (1fr, 2fr, 2fr),
  column-gutter: 8pt,
)
```

Apply the paragraph transformation with `#show: apply`. Activate a layout with
`layout(name)`. Call `layout()` to deactivate it.

```typ
#show: apply

#layout(entries)

= Personal

Name  #col(span: 2)  John Smith

Address  #col(span: 2)  Lothringerstr. 14, 56000 Köln, Deutschland

Telephone  #col()  +49 555 998877  #col()  +49 666 998877

#layout(compact-s)

First  #col()  Second  #col()  Third  #col()  Fourth  #col()  Fifth

#layout()
```

## Semantics

- Every paragraph while a layout is active becomes one full-width native Typst grid.
- The content before the first `col()` is the first cell.
- Each `col()` starts another cell; `span` defaults to `1`.
- A paragraph without `col()` is rendered as a single-cell grid.
- Import `apply` and register it with `#show: apply` to enable the paragraph transformation in your document.
- Headings are not transformed.
- `grid(columns: 5)` creates five equally sized columns. An array such as `(1fr, 2fr, 2fr)` defines individual track sizes.
- Each paragraph is a separate grid. Fractional tracks use the available width, so rows with the same layout configuration align their columns.

## Prototype limitations

Rows are separate grids, so row-level settings and content-driven cross-row track sizing are not implemented. Cell contents also need to fit within the configured columns and spans.

The example in [examples/basic.typ](examples/basic.typ) demonstrates the intended syntax.

Compile it from the repository root so Typst allows the example to import `src/lib.typ`:

```sh
typst compile --root . examples/basic.typ
```

Run the test cases with PowerShell (Typst must be on `PATH`):

```powershell
.\tests\run.ps1
```
