#import "constants.typ": spacing_double

#let apa_content_body(
  body,
  numbered_titles: false,
  indented: true,
  indent_amount: 0.5in,
  spacing_value: spacing_double,
  leading_value: spacing_double,
  enumerated_page: true
) = {
  set text(
    size: 12pt,
    font: "Times New Roman",
    lang: "es"
  )

  set align(left)

  set par(
    leading: leading_value,
    first-line-indent: (
      amount: if indented { indent_amount } else { 0em },
      all: if indented { true } else { false },
    ),
    spacing: spacing_value,
    linebreaks: "optimized"
  )

  set page(
    numbering: if enumerated_page { "1" } else { none },
    number-align: right,
    margin: 1in
  )

  set heading(numbering: if numbered_titles { "1.1." } else { none })
  
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    let choice = (
      repr(spacing_double): ("next": 0.8em, "prev": 0.20em),
    )
    v(choice.at(repr(leading_value)).at("prev"))
    text(
      size: 12pt,
      align(center, it)
    )
    v(choice.at(repr(leading_value)).at("next"))
  }

  show heading.where(level: 2): it => {
    let choice = (
      repr(spacing_double): ("next": 0.8em, "prev": 0.20em),
    )
    v(choice.at(repr(leading_value)).at("prev"))
    text(
      size: 12pt,
      align(left, it)
    )
    v(choice.at(repr(leading_value)).at("next"))
  }

  show heading.where(level: 3): it => {
    let choice = (
      repr(spacing_double): ("next": 0.8em, "prev": 0.20em),
    )
    v(choice.at(repr(leading_value)).at("prev"))
    text(
      size: 12pt,
      style: "italic",
      align(left, it)
    )
    v(choice.at(repr(leading_value)).at("next"))
  }

  body
}

#let apa_bibliography(body) = {
  // Delete previous indentation
  set par(
    first-line-indent: (
      amount: 0in,
      all: false,
    ),
    hanging-indent: 0.5in
  )

  body
}

#let apa_summary(body) = {
  set par(
    first-line-indent: (
      amount: 0.5in,
      all: false,
    )
  )

  body
}

#let apa_itemize(
  body
) = {
  set list(
    marker: [--]
  )

  set par(
    first-line-indent: (
      amount: 1em,
      all: true
    ),
    hanging-indent: 1em
  )
  
  pad(left: 0.5in)[
    #body
  ]
}

#let apa_unmarked-list(
  body
) = {
  set list(
    marker: none,
    body-indent: 0em,
  )
  pad(left: 0.5in)[
    #body
  ]
}

#let apa_figure(
  image_src,
  caption_text,
  caption_position: top,
  body
) = {
  set par(
    leading: spacing_double,
    first-line-indent: (
      amount: 0em,
      all: false,
    ),
    spacing: spacing_double
  )

  show figure.caption: it => {
    let cap = [#it.supplement #context it.counter.display(it.numbering): #it.body]
    align(left, cap)
  }
  
  if image_src != none {
    figure(
      gap: spacing_double,
      caption: if caption_text != none {
        figure.caption(
          position: caption_position,
          caption_text
        )
      } else { none },
      image_src
    )
  }

  body
}
