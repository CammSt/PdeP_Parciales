
class Argumento {
    const property descripcion
    const property naturalezas 

    method esEnriquecedor() = naturalezas.all{ naturaleza => naturaleza.esEnriquecedora(self) }
    
    method descripcionLargoMinimo(unNumero) = descripcion.size() >= unNumero

    method esPregunta() = descripcion.get(descripcion.size() - 1) == "?"
}