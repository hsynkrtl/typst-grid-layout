#import "../src/lib.typ": grid, layout, col

#let compact-s = grid(
  columns: 5,
)

#let entries = grid(
  columns: (1fr, 2fr, 2fr),
  column-gutter: 8pt,
)

#layout(entries)

= Personal

Name  #col(span: 2)  John Smith

Address  #col(span: 2)  Lothringerstr. 14, 56000 Köln, Deutschland

Telephone  #col()  +49 555 998877  #col()  +49 666 998877

= Languages

CEF C2  #col(span: 2)  German

CEF B1  #col(span: 2)  English

#layout(compact-s)

= Compact layout

First  #col()  Second  #col()  Third  #col()  Fourth  #col()  Fifth

#layout()

Normal paragraph flow is restored here.
