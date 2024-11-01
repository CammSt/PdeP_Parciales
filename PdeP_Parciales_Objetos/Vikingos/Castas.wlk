class Jarl {
    const armas

    method puedeSubir() = !self.tieneArmas()
    method tieneArmas() = armas.size() > 0

    method escalarSocialmente(vikingo) {
        vikingo.casta(new Karl())
        vikingo.modificarOcupacion()
    }
}

class Karl {
    method puedeSubir() = true

    method escalarSocialmente(vikingo) { 
        vikingo.casta(new Thrall())
        vikingo.modificarOcupacion()
    }
}

class Thrall {
    method puedeSubir() = true

    method escalarSocialmente(_vikingo) {
        // no hace nada
    }
}