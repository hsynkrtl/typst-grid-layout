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

  // The public API accepts an integer as a column count, while native Typst
  // grids expect a track-size array. Expand counts into equally sized tracks.
  let tracks = if type(columns) == int {
    assert(columns > 0, message: "The column count must be greater than zero.")
    let tracks = ()
    for _ in range(columns) {
      tracks.push(1fr)
    }
    tracks
  } else {
    assert(type(columns) == array, message: "`columns` must be a positive integer or an array of track sizes.")
    assert(columns.len() > 0, message: "The `columns` array must not be empty.")
    columns
  }

  (
    columns: tracks,
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

/// Create a grid cell with an optional visible debug border.
#let make-cell(body, span, debug) = native-grid.cell(
  body,
  colspan: span,
  inset: if debug { 2pt } else { auto },
  stroke: if debug { 1pt + red } else { none },
)

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
      cells.push(make-cell(current.join(), current-span, spec.debug))
      current = ()
      current-span = child.value.span
    } else {
      current.push(child)
    }
  }

  cells.push(make-cell(current.join(), current-span, spec.debug))

  native-grid(
    columns: spec.columns,
    column-gutter: spec.column-gutter,
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
