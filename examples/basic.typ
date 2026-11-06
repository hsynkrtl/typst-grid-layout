#import "../src/lib.typ": grid, layout, col, apply

#show: apply

#let compact-s = grid(
  columns: 5,
  column-gutter: 6pt,
  debug: true,
)

#let entries = grid(
  columns: (0.7fr, 1fr, 1.5fr, 3fr, 1fr, 1fr),
  column-gutter: 8pt,
  debug: true,
)

#let contact = grid(
  columns: (1fr, 2fr, 1fr, 2fr),
  column-gutter: 10pt,
  debug: true,
)


#layout(entries)

= Project overview

ID
#col() Category
#col() Project
#col() Description
#col() Period
#col() Status

01
#col() Backend
#col() Customer portal
#col() Development of a REST-based service for managing customer accounts, permissions, and profile data.
#col() 2022–2023
#col() Completed

02
#col() Automotive
#col() Infotainment
#col() Integration of vehicle services and implementation of automated tests for several software components.
#col() 2024–2025
#col() Completed

03
#col() Platform
#col() Build tooling
#col() Maintenance and improvement of the build pipeline, dependency management, and developer tooling.
#col() 2025–2026
#col() In progress

04
#col() Research
#col() Prototype
#col() A short proof of concept.
#col() 2026
#col() Paused

01 #col() 02 #col() 03 #col() 04 #col() 05 #col() 06 #col() 07 #col() 08 #col() 09 #col() 10

11 #col() 12 #col() 13 #col() 14 #col() 15 #col() 16 #col() 17 #col() 18 #col() 19 #col() 20

21 #col(span: 2) 22 23 #col() 24 #col() 25 #col() 26 #col() 27 #col() 28 #col() 29 #col() 30

= Contact details

#layout(contact)

Name
#col() Hüseyin Kartal
#col() E-mail
#col() huseyin.kartal\@example.com

Street
#col() Apprichstraße 18, 86199 Augsburg
#col() Country
#col() Germany

Telephone
#col() +49 555 998877
#col() Mobile
#col() +49 666 998877

= Spanning cells

#layout(entries)

Summary
#col(span: 3) This text occupies three grid columns and is intentionally longer to make the span visible.
#col() Updated
#col() 2026

= Compact layout

#layout(compact-s)

Code
#col() Short
#col() A somewhat longer value
#col() Another value
#col() End

A
#col() B
#col() C
#col() D
#col() E

Longer text in the first cell
#col() 2
#col() The third cell contains a longer description
#col() 4
#col() The fifth cell

#layout()

Normal paragraph flow is restored here. This paragraph should no longer be split into grid cells, even though it contains several words and has a different length from the examples above.
