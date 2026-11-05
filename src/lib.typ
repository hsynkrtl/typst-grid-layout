// Reusable grid layouts for Typst.
//
// A layout is a configuration value. Activating it transforms each paragraph
// into one native Typst grid row. col() marks the start of the next cell.

#let native-grid = grid
#let active-layout = state("typst-grid-layout.active", none)

/// Define a reusable layout.
///
/// - columns: Number of equally sized columns or an array of track sizes.
/// - column-gutter: Space between columns.
/// - debug: Draw cell borders to inspect the grid structure.
#let grid(
  columns: none,
  column-gutter: 0pt,
  debug: false,
) = {
  assert(columns != none, message: "The `columns` argument is required.")
  (
    columns: columns,
    column-gutter: column-gutter,
    debug: debug,
  )
}

/// Activate a layout, or deactivate it when called without an argument.
#let layout(..args) = {
  let positional = args.pos()
  assert(positional.len() <= 1, message: "layout() accepts at most one positional argument.")
  assert(args.named().len() == 0, message: "layout() does not accept named arguments.")
  active-layout.update(if positional.len() == 0 { none } else { positional.at(0) })
}

/// Start a new cell in the current paragraph.
///
/// The content before the first col() call forms the first cell.
/// span controls how many grid columns the new cell occupies.
#let col(span: 1) = {
  assert(span >= 1, message: "A cell span must be at least 1.")
  metadata((
    kind: "typst-grid-layout.column",
    span: span,
  ))
}

#let is-column-marker(item) = item.func() == metadata and item.has("value") and type(item.value) == dictionary and item.value.at("kind", default: none) == "typst-grid-layout.column"

/// Split a paragraph body at col() markers and create native grid cells.
#let make-row(body, spec) = {
  let children = if body.has("children") {
    body.children
  } else {
    (body,)
  }

  let cells = ()
  let current = ()
  let current-span = 1

  for child in children {
    if is-column-marker(child) {
      cells.push(native-grid.cell(
        current.join(),
        colspan: current-span,
      ))
      current = ()
      current-span = child.value.span
    } else {
      current.push(child)
    }
  }

  cells.push(native-grid.cell(
    current.join(),
    colspan: current-span,
  ))

  native-grid(
    columns: spec.columns,
    column-gutter: spec.column-gutter,
    stroke: if spec.debug { 0.5pt + red } else { none },
    ..cells,
  )
}

// Show rules provide the context required to read the active state.
#show par: paragraph => context {
  let spec = active-layout.get()
  if spec == none {
    paragraph
  } else {
    make-row(paragraph.body, spec)
  }
}
