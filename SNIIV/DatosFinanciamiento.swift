//
//  DatosFinanciamiento.swift
//  SNIIV
//
//  Created by admin on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosFinanciamiento {
    var datos: [Financiamiento]
    
    init (datos: [Financiamiento]) {
        self.datos = datos
    }
    
    func consultaNacional() -> ConsultaFinanciamiento {
        return ConsultaFinanciamiento(financiamientos: datos)
    }
    
    func consultaEntidad(entidad: Entidad) -> ConsultaFinanciamiento {
        var datosEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return ConsultaFinanciamiento(financiamientos: datosEntidad)
    }
}

struct ConsultaFinanciamiento {
    let viviendasNuevas: FinanciamientoResultado
    let viviendasUsadas: FinanciamientoResultado
    let mejoramientos: FinanciamientoResultado
    let otrosProgramas: FinanciamientoResultado
    let total: Consulta
    
    init(financiamientos: [Financiamiento]) {
        viviendasNuevas = ConsultaFinanciamiento.obtieneFinanciamiento(financiamientos, filtro: { $0.destino == "Viviendas Nuevas" })
        viviendasUsadas = ConsultaFinanciamiento.obtieneFinanciamiento(financiamientos, filtro: { $0.destino == "Viviendas Usadas" })
        mejoramientos = ConsultaFinanciamiento.obtieneFinanciamiento(financiamientos, filtro: { $0.destino == "Mejoramientos" })
        otrosProgramas = ConsultaFinanciamiento.obtieneFinanciamiento(financiamientos, filtro: { $0.destino == "Otros programas" })
        total = ConsultaFinanciamiento.obtieneConsulta(financiamientos, filtro: { f in return true })
    }
    
    private static func obtieneFinanciamiento(financiamientos: [Financiamiento], filtro: (Financiamiento -> Bool)) -> FinanciamientoResultado {
        let cofinanciamiento = ConsultaFinanciamiento.obtieneConsulta(financiamientos, filtro: { $0.agrupacion == "Cofinanciamientos y Subsidios" && filtro($0) })
        let creditoIndividual = ConsultaFinanciamiento.obtieneConsulta(financiamientos, filtro: { $0.agrupacion == "Crédito Individual" && filtro($0) })
        
        return FinanciamientoResultado(cofinanciamiento: cofinanciamiento, creditoIndividual: creditoIndividual)
    }
    
    private static func obtieneConsulta(financiamientos: [Financiamiento], filtro: (Financiamiento -> Bool)) -> Consulta {
        var acciones: Int64 = ConsultaFinanciamiento.calculaAcciones(financiamientos, filtro: filtro)
        var monto: Double = ConsultaFinanciamiento.calculaMontos(financiamientos, filtro: filtro)
        return Consulta(acciones: acciones, monto: monto)
    }
    
    private static func calculaAcciones(financiamientos: [Financiamiento], filtro: (Financiamiento -> Bool)) -> Int64 {
        return financiamientos.filter(filtro).map{ $0.acciones }.reduce(0, combine: Utils.Sumar)
    }
    
    private static func calculaMontos(financiamientos: [Financiamiento], filtro: (Financiamiento -> Bool)) -> Double {
        return financiamientos.filter(filtro).map{ $0.monto }.reduce(0, combine: Utils.Sumar)
    }
    
    struct FinanciamientoResultado {
        let cofinanciamiento: Consulta
        let creditoIndividual: Consulta
    }
}