//
//  FinanciamientoRepository.swift
//  SNIIV
//
//  Created by admin on 28/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class FinanciamientoRepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<Int>("cve_ent")
    static let organismo = Expression<String>("organismo")
    static let destino = Expression<String>("destino")
    static let agrupacion = Expression<String>("agrupacion")
    static let acciones = Expression<Int64>("acciones")
    static let monto = Expression<Double>("monto")
    
    private static let TABLA = "Financiamiento"
    private static let COFINANCIAMIENTOS = "Cofinanciamientos y Subsidios"
    private static let CREDITO_INDIVIDUAL = "Crédito Individual"
    
    static func save(reporteGeneral: Financiamiento) {
        let reporte = db[TABLA]
        reporte.insert(or: .Replace,
            cve_ent <- reporteGeneral.cve_ent,
            organismo <- reporteGeneral.organismo,
            destino <- reporteGeneral.destino,
            agrupacion <- reporteGeneral.agrupacion,
            acciones <- reporteGeneral.acciones,
            monto <- reporteGeneral.monto)
    }
    
    static func saveAll(datos: [Financiamiento]) {
        for d in datos {
            FinanciamientoRepository.save(d)
        }
    }
    
    static func deleteAll() {
        let reporte = db[TABLA]
        reporte.delete()
    }
    
    static func loadFromStorage() -> [Financiamiento] {
        let reporte = db[TABLA]
        let all = Array(reporte)
        var result: [Financiamiento] = []
        
        for r in all {
            result.append(Financiamiento(cve_ent: r[cve_ent],
                organismo: r[organismo],
                destino: r[destino],
                agrupacion: r[agrupacion],
                acciones: r[acciones],
                monto: r[monto]))
        }
        
        return result
    }
    
    static func consultaNacional() -> ConsultaFinanciamiento {
        return FinanciamientoRepository.consulta()
    }
    
    static func consultaEntidad(entidad: Entidad) -> ConsultaFinanciamiento {
       return FinanciamientoRepository.consulta(filtroOpcional: cve_ent == entidad.rawValue)
    }
    
    private static func consulta(filtroOpcional: Expression<Bool>? = nil) -> ConsultaFinanciamiento {
        var financiamiento = db[TABLA]
        
        if let filtro = filtroOpcional {
            financiamiento = financiamiento.filter(filtro)
        }
        
        var consulta = ConsultaFinanciamiento()
        
        let viviendasNuevas = financiamiento.filter(destino == "Viviendas Nuevas")
        consulta.viviendasNuevas.cofinanciamiento.monto = viviendasNuevas.filter(agrupacion == COFINANCIAMIENTOS).sum(monto)!
        consulta.viviendasNuevas.cofinanciamiento.acciones = viviendasNuevas.filter(agrupacion == COFINANCIAMIENTOS).sum(acciones)!
        consulta.viviendasNuevas.creditoIndividual.monto = viviendasNuevas.filter(agrupacion == CREDITO_INDIVIDUAL).sum(monto)!
        consulta.viviendasNuevas.creditoIndividual.acciones = viviendasNuevas.filter(agrupacion == CREDITO_INDIVIDUAL).sum(acciones)!
        
        let viviendasUsadas = financiamiento.filter(destino == "Viviendas Usadas")
        consulta.viviendasUsadas.cofinanciamiento.monto = viviendasUsadas.filter(agrupacion == COFINANCIAMIENTOS).sum(monto)!
        consulta.viviendasUsadas.cofinanciamiento.acciones = viviendasUsadas.filter(agrupacion == COFINANCIAMIENTOS).sum(acciones)!
        consulta.viviendasUsadas.creditoIndividual.monto = viviendasUsadas.filter(agrupacion == CREDITO_INDIVIDUAL).sum(monto)!
        consulta.viviendasUsadas.creditoIndividual.acciones = viviendasUsadas.filter(agrupacion == CREDITO_INDIVIDUAL).sum(acciones)!
        
        let mejoramientos = financiamiento.filter(destino == "Mejoramientos")
        consulta.mejoramientos.cofinanciamiento.monto = mejoramientos.filter(agrupacion == COFINANCIAMIENTOS).sum(monto)!
        consulta.mejoramientos.cofinanciamiento.acciones = mejoramientos.filter(agrupacion == COFINANCIAMIENTOS).sum(acciones)!
        consulta.mejoramientos.creditoIndividual.monto = mejoramientos.filter(agrupacion == CREDITO_INDIVIDUAL).sum(monto)!
        consulta.mejoramientos.creditoIndividual.acciones = mejoramientos.filter(agrupacion == CREDITO_INDIVIDUAL).sum(acciones)!
        
        let otrosProgramas = financiamiento.filter(destino == "Otros programas")
        consulta.otrosProgramas.creditoIndividual.monto = otrosProgramas.filter(agrupacion == CREDITO_INDIVIDUAL).sum(monto)!
        consulta.otrosProgramas.creditoIndividual.acciones = otrosProgramas.filter(agrupacion == CREDITO_INDIVIDUAL).sum(acciones)!
        
        consulta.total.monto = financiamiento.sum(monto)!
        consulta.total.acciones = financiamiento.sum(acciones)!
        
        return consulta
    }
}
