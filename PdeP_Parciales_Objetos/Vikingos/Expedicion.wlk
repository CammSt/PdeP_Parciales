
class Expedicion {
    const objetivosInvolucrados
    const vikingos

    method valeLaPena() = objetivosInvolucrados.all{ objetivo => objetivo.valeLaPena(vikingos.size())}

    method realizar() {
        if(self.valeLaPena()) {
            const botin = objetivosInvolucrados.map{ objetivo => objetivo.botin(vikingos.size()) }.sum()
            objetivosInvolucrados.forEach{ objetivo => objetivo.atacado(vikingos.size())}
            self.dividirBotin(botin)
        }
    }

    method dividirBotin(botin) {
        const botinPorVikingo = botin / vikingos.size()
        vikingos.forEach{ vikingo => vikingo.recibirBotin(botinPorVikingo)}
    }
}

