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
        nueva = ConsultaSubsidio.obtieneConsulta(subsidios, modalidad: "Nueva")
        usada = ConsultaSubsidio.obtieneConsulta(subsidios, modalidad: "Usada")
        autoproduccion = ConsultaSubsidio.obtieneConsulta(subsidios, modalidad: "Autoproducción")
        mejoramiento = ConsultaSubsidio.obtieneConsulta(subsidios, modalidad: "Mejoramiento")
        lotes = ConsultaSubsidio.obtieneConsulta(subsidios, modalidad: "Lotes con servicio")
        otros = ConsultaSubsidio.obtieneConsulta(subsidios, modalidad: "Otros")
        total = ConsultaSubsidio.obtieneTotalConsulta(subsidios)
    }
    
    static func obtieneConsulta(subsidios: [Subsidio], modalidad: String) -> Consulta {
        var acciones: Int64 = ConsultaSubsidio.calculaAcciones(subsidios, modalidad: modalidad)
        var monto: Double = ConsultaSubsidio.calculaMontos(subsidios, modalidad: modalidad)
        return (acciones, monto)
    }
    
    static func obtieneTotalConsulta(subsidios: [Subsidio]) -> Consulta {
        var acciones: Int64 = ConsultaSubsidio.calculaTotalAcciones(subsidios)
        var monto: Double = ConsultaSubsidio.calculaTotalMontos(subsidios)
        return (acciones, monto)
    }
    
    static func calculaAcciones(subsidios: [Subsidio], modalidad: String) -> Int64 {
        return subsidios.filter{ $0.modalidad == modalidad }.map{ $0.acciones }.reduce(0, combine: Utils.Sumar)
    }
    
    static func calculaMontos(subsidios: [Subsidio], modalidad: String) -> Double {
        return subsidios.filter{ $0.modalidad == modalidad }.map{ $0.monto }.reduce(0, combine: Utils.Sumar)
    }
    
    static func calculaTotalAcciones(subsidios: [Subsidio]) -> Int64 {
        return subsidios.map{ $0.acciones }.reduce(0, combine: Utils.Sumar)
    }
    
    static func calculaTotalMontos(subsidios: [Subsidio]) -> Double {
        return subsidios.map{ $0.monto }.reduce(0, combine: Utils.Sumar)
    }
}