//
//  ReporteGeneral.swift
//  SNIIV
//
//  Created by admin on 09/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation


class DatosReporteGeneral {
    var datos: [ReporteGeneralPrueba]
    
    init (datos: [ReporteGeneralPrueba]) {
        self.datos = datos
    }
    
    func consultaNacional() -> ReporteGeneralPrueba {
        return ReporteGeneralRepository.consultaNacional()
    }
    
    func consultaEntidad(entidad: Entidad) -> ReporteGeneralPrueba {
        var datoEntidad = datos.filter() {
            return $0.cveeNT == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}
