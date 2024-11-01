

class Aldea {
    var crucifijosEnIglesias

    method botin(_cantidadVikingos) = crucifijosEnIglesias

    method valeLaPena(cantidadVikingos) = crucifijosEnIglesias >= 15

    method atacado(cantidadVikingos) {
        self.quitarCrucifijos()
    }

    method quitarCrucifijos() {
        crucifijosEnIglesias = 0
    }
}

class AldeaAmurallada inherits Aldea {
    const vikingosRequeridos
    override method valeLaPena(cantidadVikingos) = super(cantidadVikingos) and cantidadVikingos >= vikingosRequeridos
}

