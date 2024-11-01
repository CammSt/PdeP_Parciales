
class Capital {

    var defensores
    const factorDeRiqueza

    method botin(cantidadVikingos) = self.monedasDeOroEnBotin(cantidadVikingos)

    method valeLaPena(cantidadVikingos) = cantidadVikingos * 3 <= self.monedasDeOroEnBotin(cantidadVikingos)

    method monedasDeOroEnBotin(cantidadVikingos) = self.defensoresDerrotados(cantidadVikingos) * factorDeRiqueza
    method defensoresDerrotados(cantidadVikingos) = defensores.max(cantidadVikingos)


    method atacado(cantidadVikingos) {
        self.disminuirDefensores(cantidadVikingos)
    }

    method disminuirDefensores(cantidadVikingos) {
        defensores = defensores - cantidadVikingos
    }

}