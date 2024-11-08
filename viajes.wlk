class Viaje{
    const property idiomas = []

    method esfuerzo()
    method broncearse()
    method dias()
    method esInteresante() = idiomas.size() > 1 
    method esRecomendadaParaSocio(socio) = self.esInteresante() and socio.leAtrae(self) and not socio.actividades().contains(self)
}

class ViajePlaya inherits Viaje {
    const property largo

    override method dias() = largo / 500
    override method esfuerzo() = largo>1200
    override method broncearse() = true   
}

class ExcursionCiudad inherits Viaje {
    const property cantidadDeAtracciones

    override method dias() = cantidadDeAtracciones / 2  
    override method esfuerzo() = cantidadDeAtracciones.between(5,8)
    override method broncearse() = false 
    override method esInteresante() = super() || cantidadDeAtracciones == 5
}

class ExcursionCiudadTropical inherits ExcursionCiudad {
    override method dias() = super() + 1 
    override method broncearse() = true 
}

class SalidaTrekking inherits Viaje{
    const property kilometros 
    const property diasDeSol

    override method dias() = kilometros / 50
    override method esfuerzo() = kilometros > 80
    override method broncearse() = diasDeSol > 200 or (kilometros.between(100, 200) and kilometros > 120)
    override method esInteresante() = super() && diasDeSol > 140 
}


class ClaseDeGimnasia inherits Viaje{
    method initialize() {
        idiomas.clear()
        idiomas.add("español")
            if(idiomas!=["español"]) self.error("solo se permite en español")
    }

    override method dias() = 1
    override method esfuerzo() = true
    override method broncearse() = false 

    override method esRecomendadaParaSocio(socio) = socio.edad().between(20, 30)
}

class TallerLiterario inherits Viaje{
    const property libros = []

    override method dias() = libros.size()+1
    
    override method esfuerzo() =
    libros.any({l => l.cantidadDePaginas() > 500}) or 
    (libros.size() > 1 and libros.map({l => l.nombreDelAutor()}).asSet().size() == 1)

    override method broncearse() = false
    override method esRecomendadaParaSocio(socio) = socio.idiomasConocidos().size() > 1  
}

class Libro {
    const property paginas
    const property autor  
}

class Socio{
    const property actividades = []
    const maximoActividades
    var edad
    const property idiomasConocidos = []

    method maximoActividades() = maximoActividades
    method edad() = edad 

    method esAdoradorDelSol() = actividades.all({actividad => actividad.broncearse()})
    method actividadesEsforzadas() = actividades.find({actividad => actividad.esfuerzo()})
    method realizarActividad(actividad) {
        if(actividades.size() < maximoActividades){
            actividades.add(actividad)
        }else{
            self.error("Llegastes al maximo de actividades")
        }
    } 

    method leAtrae(actividad)
}

class SocioTranquilo inherits Socio {
    override method leAtrae(actividad) = actividad.dias() >= 4
}

class SocioCoherente inherits Socio{
    override method leAtrae(actividad) {
        if(self.esAdoradorDelSol()){
            return actividad.broncearse()
        }

        return actividad.esfuerzo()
    }
}

class SocioRelajado inherits Socio {
    override method leAtrae(actividad) {
        return !idiomasConocidos.intersection(actividad.idiomas()).isEmpty()
    }
}