//
//  DatosAvanceObra.swift
//  SNIIV
//
//  Created by admin on 20/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosAvanceObra {
    var datos: [AvanceObra]
    
    init (datos: [AvanceObra]) {
        self.datos = datos
    }
    
    func consultaNacional() -> AvanceObra {
        return AvanceObraRepository.consultaNacional()
    }
    
    func consultaEntidad(entidad: Entidad) -> AvanceObra {
        var datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}