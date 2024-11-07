

class Discusion {
    const partido1
    const partido2

    method esBuena() = partido1.esBueno() && partido2.esBueno()
}

class Partido {
    const filosofo
    const property argumentos

    method esBueno() = filosofo.estaEnLoCorrecto() && self.porcentajeArgumentosEnriquecedores() >= 0.5

    method porcentajeArgumentosEnriquecedores() {
        const cantidadArgumentos = argumentos.size()
        const cantidadArgumentosEnriquecedores = argumentos.count{ argumento => argumento.esEnriquecedor() }

        return cantidadArgumentosEnriquecedores.div(cantidadArgumentos)
    }
}