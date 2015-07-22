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
        var datoEntidad = ValorVivienda()
        
        var economica: Int64 = datos.map{ return $0.economica }.reduce(0, combine: Utils.Sumar)
        datoEntidad.economica = economica
        
        var popular: Int64 = datos.map{ return $0.popular }.reduce(0, combine: Utils.Sumar)
        datoEntidad.popular = popular
        
        var tradicional: Int64 = datos.map{ return $0.tradicional }.reduce(0, combine: Utils.Sumar)
        datoEntidad.tradicional = tradicional
        
        var media_residencial: Int64 = datos.map{ return $0.media_residencial }.reduce(0, combine: Utils.Sumar)
        datoEntidad.media_residencial = media_residencial
        
        var total: Int64 = datos.map{ return $0.total }.reduce(0, combine: Utils.Sumar)
        datoEntidad.total = total
        
        
        return datoEntidad
    }
    
    func consultaEntidad(entidad: Entidad) -> ValorVivienda {
        var datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}