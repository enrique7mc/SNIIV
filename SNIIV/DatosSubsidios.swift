//
//  DatosSubsidios.swift
//  SNIIV
//
//  Created by admin on 22/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosSubsidios {
    var datos: [Subsidio]
    
    init (datos: [Subsidio]) {
        self.datos = datos
    }
    
    func consultaNacional() -> ConsultaSubsidio {
        return ConsultaSubsidio(subsidios: datos)
    }
    
    func consultaEntidad(entidad: Entidad) -> ConsultaSubsidio {
        var datosEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return ConsultaSubsidio(subsidios: datosEntidad)
    }
}

typealias Consulta = (Int64, Double)

struct ConsultaSubsidio {
    let nueva: Consulta
    let usada: Consulta
    let autoproduccion: Consulta
    let mejoramiento: Consulta
    let lotes: Consulta
    let otros: Consulta
    let total: Consulta
    
    init(subsidios: [Subsidio]) {
        nueva = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { $0.modalidad == "Nueva" })
        usada = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { $0.modalidad == "Usada" })
        autoproduccion = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { $0.modalidad == "Autoproducción" })
        mejoramiento = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { $0.modalidad == "Mejoramiento" })
        lotes = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { $0.modalidad == "Lotes con servicio" })
        otros = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { $0.modalidad == "Otros" })
        total = ConsultaSubsidio.obtieneConsulta(subsidios, filtro: { s in return true })
    }
    
    static func obtieneConsulta(subsidios: [Subsidio], filtro: (Subsidio -> Bool)) -> Consulta {
        var acciones: Int64 = ConsultaSubsidio.calculaAcciones(subsidios, filtro: filtro)
        var monto: Double = ConsultaSubsidio.calculaMontos(subsidios, filtro: filtro)
        return (acciones, monto)
    }
    
    static func calculaAcciones(subsidios: [Subsidio], filtro: (Subsidio -> Bool)) -> Int64 {
        return subsidios.filter(filtro).map{ $0.acciones }.reduce(0, combine: Utils.Sumar)
    }
    
    static func calculaMontos(subsidios: [Subsidio], filtro: (Subsidio -> Bool)) -> Double {
        return subsidios.filter(filtro).map{ $0.monto }.reduce(0, combine: Utils.Sumar)
    }
}