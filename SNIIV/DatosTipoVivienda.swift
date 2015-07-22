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
        var datoEntidad = TipoVivienda()
        
        var horizontal: Int64 = datos.map{ return $0.horizontal }.reduce(0, combine: Utils.Sumar)
        datoEntidad.horizontal = horizontal
        
        var vertical: Int64 = datos.map{ return $0.vertical }.reduce(0, combine: Utils.Sumar)
        datoEntidad.vertical = vertical
        
        var total: Int64 = datos.map{ return $0.total }.reduce(0, combine: Utils.Sumar)
        datoEntidad.total = total
        
        
        return datoEntidad
    }
    
    func consultaEntidad(entidad: Entidad) -> TipoVivienda {
        var datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}