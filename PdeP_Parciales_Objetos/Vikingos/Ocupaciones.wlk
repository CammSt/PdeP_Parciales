
class Soldado {
  const vidasCobradas
  var property armas

  method puedeSubir() = self.vidasSuficientes() and self.tieneArmas()
  
  method vidasSuficientes() = vidasCobradas > 20
  method tieneArmas() = armas > 0

    method escalarSocialmente() {
      armas += 10
    }
}

class Granjero {
  var property cantidadHijos
  var property hectareas  // minimo 2 hectareas por hijo
  
  method puedeSubir() = self.cantidadSuficientesHectareas()

  method cantidadSuficientesHectareas() =  hectareas >= cantidadHijos * 2

  method escalarSocialmente() {
    cantidadHijos += 2
    hectareas += 2
  }
}
