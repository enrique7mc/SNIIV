//
//  DatosTipoVivienda.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosTipoVivienda {
    var datos: [TipoVivienda]
    
    init (datos: [TipoVivienda]) {
        self.datos = datos
    }
    
    func consultaNacional() -> TipoVivienda {
        return TipoViviendaRepository.consultaNacional()
    }
    
    func consultaEntidad(entidad: Entidad) -> TipoVivienda {
        var datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}