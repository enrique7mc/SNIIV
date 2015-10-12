//
//  DatosValorVivienda.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosValorVivienda {
    var datos: [ValorVivienda]
    
    init (datos: [ValorVivienda]) {
        self.datos = datos
    }
    
    func consultaNacional() -> ValorVivienda {
        return ValorViviendaRepository.consultaNacional()
    }
    
    func consultaEntidad(entidad: Entidad) -> ValorVivienda {
        let datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}