

class Filosofo {
  const property nombre
  var property dias
  const property actividades
  const property honorificos
  var property nivelIluminacion

  method edad() = dias.div(365)

  method presentarse() = "Hola, mi nombre es " + nombre + ", " + honorificos.join(', ') 

  method estaEnLoCorrecto() = nivelIluminacion > 1000

  method disminuirIluminacion(unaCantidad) {
    nivelIluminacion -= unaCantidad
  }

  method aumentarIluminacion(unaCantidad) {
    nivelIluminacion += unaCantidad
  }

  method agregarHonorifico(unHonorifico) {

    if(honorificos.contains(unHonorifico)) {
      throw new DomainException(message = "El honorifico ya existe")
    }

    honorificos.add(unHonorifico)
  }

  method rejuvenecer(unosDias) {
    dias -= unosDias
  }

  method vivirUnDia() {
    self.realizarActividades()
    self.agregarDiaVivido()
  }

  method realizarActividades() {
    actividades.forEach{ actividad => actividad.realizarsePor(self)}
  }

  method agregarDiaVivido() {
    dias = dias + 1
    self.verificarEdad()
  }

  method verificarEdad() {
    if(dias >= 60 * 365) {
      self.agregarHonorifico("El Sabio")
    }
  }
}


class FilosofoContemporaneo inherits Filosofo {
  const property amanteDeLaBotanica

  override method presentarse() = "Hola"

  override method nivelIluminacion() = super() * self.coeficienteDeIluminacion()

  method coeficienteDeIluminacion() = if(amanteDeLaBotanica) 5 else 1
}