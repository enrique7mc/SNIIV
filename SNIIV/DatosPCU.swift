//
//  DatosPCU.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosPCU {
    var datos: [PCU]
    
    init (datos: [PCU]) {
        self.datos = datos
    }
    
    func consultaNacional() -> PCU {
        return PCURepository.consultaNacional()
    }
    
    func consultaEntidad(entidad: Entidad) -> PCU {
        let datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}