
object estoica {
    method esEnriquecedora(_unArgumento) = true
}

object moralista {
    method esEnriquecedora(unArgumento) = unArgumento.descripcionLargoMinimo(10)
}

object esceptica {
    method esEnriquecedora(unArgumento) = unArgumento.esPregunta()
}

object cinica {
    method esEnriquecedora(_unArgumento) = 1.randomUpTo(100) <= 30
}