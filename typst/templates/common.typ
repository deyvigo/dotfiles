/*
* Template for common content
  @leading_value and @spacing_values must be in em (consider font size) and same value
*/
#let common_content_body(
  body,
  numbered_titles: true,
  indented: false,
  indent_amount: 0.5in,
  spacing_value: 1em,
  leading_value: 1em,
  enumerated_page: false,
) = {
  set text(
    size: 12pt,
    font: "Times New Roman"
  )

  set align(left)

  set par(
    leading: leading_value,
    first-line-indent: (
      amount: if indented { indent_amount } else { 0em },
      all: if indented { true } else { false },
    ),
    spacing: spacing_value,
  )

  set page(
    numbering: if enumerated_page { "1" } else { none },
    number-align: right
  )

  set heading(numbering: "1.")

  show heading: it => {
    let number = if it.level >= 2 {
      counter(heading).at(it.location())
      .slice(1)
      .map(str)
      .join(".") + ". "
    } else { "" }
    set text(size: 12pt)
    set par(first-line-indent: 0in)
    [#number#it.body]
    v(-leading_value/30)
  }

  show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 5pt,
    radius: 4pt,
  )

  body
}

#let common_flipped_page(body) = {
  set page(
    flipped: true,
  )
  
  body
}
