
class Vikingo {
  var property casta
  var property ocupacion
  var property dinero

  method puedeSubir() {
    if(ocupacion.puedeSubir() and casta.puedeSubir()) {
      return true
    }
    throw new DomainException( message = "No puede subir a la expedición")
  }

  method recibirBotin(botin) {
    dinero += botin
  }

  method escalarSocialmente() {
    casta.escalarSocialmente(self)
  }

  method modificarOcupacion() {
    ocupacion.escalarSocialmente()
  }
  
}