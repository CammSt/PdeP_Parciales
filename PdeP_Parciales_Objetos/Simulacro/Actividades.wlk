

class TomarVino {

    method realizarsePor(unFilosofo) {
        unFilosofo.disminuirIluminacion(10)
        unFilosofo.agregarHonorifico("El Borracho")
    }
}

class JuntarseEnElAgora {
    var property compania

    method realizarsePor(unFilosofo) {
        const decimaParte = compania.nivelIluminacion() / 10
        unFilosofo.aumentarIluminacion(decimaParte)
    }
}

class AdmirarPaisaje {

    method realizarsePor(unFilosofo) {
        // no hace nada
    }
}

class MeditarBajoUnaCascada {
    var property metros 

    method realizarsePor(unFilosofo) {
        const aumento = 10 * metros
        unFilosofo.aumentarIluminacion(aumento)
    }
}

class PracticarDeporte {
    var property deporte

    method realizarsePor(unFilosofo) {
        deporte.rejuvenecer(unFilosofo)
    } 
}

