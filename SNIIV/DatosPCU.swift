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
        var datoEntidad = PCU()
        
        var u1: Int64 = datos.map{ return $0.u1 }.reduce(0, combine: Utils.Sumar)
        datoEntidad.u1 = u1
        
        var u2: Int64 = datos.map{ return $0.u2 }.reduce(0, combine: Utils.Sumar)
        datoEntidad.u2 = u2
        
        var u3: Int64 = datos.map{ return $0.u3 }.reduce(0, combine: Utils.Sumar)
        datoEntidad.u3 = u3
        
        var fc: Int64 = datos.map{ return $0.fc }.reduce(0, combine: Utils.Sumar)
        datoEntidad.fc = fc
        
        var nd: Int64 = datos.map{ return $0.nd }.reduce(0, combine: Utils.Sumar)
        datoEntidad.nd = nd
        
        var total: Int64 = datos.map{ return $0.total }.reduce(0, combine: Utils.Sumar)
        datoEntidad.total = total
        
        
        return datoEntidad
    }
    
    func consultaEntidad(entidad: Entidad) -> PCU {
        var datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}