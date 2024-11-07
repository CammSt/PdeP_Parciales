

class Futbol {
    const dias = 1

    method rejuvenecer(unFilosofo){
      unFilosofo.rejuvenecer(dias)
    }
}

class Polo {
    const dias = 2
    
    method rejuvenecer(unFilosofo){
      unFilosofo.rejuvenecer(dias)
    }
}

class Waterpolo inherits Polo {

    override method rejuvenecer(unFilosofo){
      unFilosofo.rejuvenecer(dias * 2)
    }
}