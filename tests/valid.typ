#import "../src/lib.typ": grid, layout, col, apply

#show: apply

#let equal-columns = grid(columns: 3)
#assert(equal-columns.columns.len() == 3)
#assert(equal-columns.columns.at(0) == 1fr)

#let custom-columns = grid(
  columns: (1fr, 2fr, 1fr),
  column-gutter: 6pt,
  debug: true,
)
#assert(custom-columns.columns == (1fr, 2fr, 1fr))
#assert(custom-columns.column-gutter == 6pt)
#assert(custom-columns.debug)

#layout(custom-columns)

First cell
#col(span: 2) Spanning cell

Single cell row

#layout()

Normal paragraph after layout
