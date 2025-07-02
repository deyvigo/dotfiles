#let inf_make_cover(
  university,
  faculty,
  eschool,
  logo,
  inform_name,
  teacher_name,
  alumns,
  city,
  year
) = {
  set page(
    paper: "a4",
    margin: (top: 1in, bottom: 1in, left: 1in, right: 1in),
  )

  set text(
    font: "Times New Roman",
    size: 12pt,
    lang: "es"
  )

  set par(
    leading: 1em
  )

  set align(center)

  text(
    size: 16pt,
    weight: "bold",
    university
  )
  linebreak()

  text(
    size: 14pt,
    weight: "bold",
    faculty
  )
  linebreak()

  text(
    size: 14pt,
    weight: "bold",
    eschool
  )
  linebreak()

  if logo != none {
    logo
    linebreak()
  } else {
    linebreak()
  }


  text(
    weight: "bold",
    inform_name
  )
  linebreak()
  linebreak()

  text(
    weight: "bold",
    "Docente: "
  )
  linebreak()

  text(
    teacher_name
  )
  linebreak()

  text(
    weight: "bold",
    if alumns.len() == 1 { "Alumno: " } else { "Alumnos: " }
  )
  linebreak()

  for alumn in alumns {
    text(alumn)
    linebreak()
  }

  v(1fr)
  text(

    city + " - " + year
  )
  pagebreak()
  set align(left)
}
