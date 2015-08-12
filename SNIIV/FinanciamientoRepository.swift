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
    
    static let TABLA = "Financiamiento"
    private static let COFINANCIAMIENTOS = "Cofinanciamientos y Subsidios"
    private static let CREDITO_INDIVIDUAL = "Crédito Individual"
    
    static func save(dato: Financiamiento) {
        let reporte = db[TABLA]
        reporte.insert(
            cve_ent <- dato.cve_ent,
            organismo <- dato.organismo,
            destino <- dato.destino,
            agrupacion <- dato.agrupacion,
            acciones <- dato.acciones,
            monto <- dato.monto)
    }
    
    static func saveAll(datos: [Financiamiento]) {
        let reporte = db[TABLA]
        db.transaction(.Deferred) { txn in
            for dato in datos {
                if reporte.insert(
                    cve_ent <- dato.cve_ent,
                    organismo <- dato.organismo,
                    destino <- dato.destino,
                    agrupacion <- dato.agrupacion,
                    acciones <- dato.acciones,
                    monto <- dato.monto).statement.failed {
                    return .Rollback
                }
            }
            
            return .Commit
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
        consulta.viviendasNuevas.cofinanciamiento = generaConsulta(viviendasNuevas.filter(agrupacion == COFINANCIAMIENTOS))
        consulta.viviendasNuevas.creditoIndividual = generaConsulta(viviendasNuevas.filter(agrupacion == CREDITO_INDIVIDUAL))
        
        let viviendasUsadas = financiamiento.filter(destino == "Viviendas Usadas")
        consulta.viviendasUsadas.cofinanciamiento = generaConsulta(viviendasUsadas.filter(agrupacion == COFINANCIAMIENTOS))
        consulta.viviendasUsadas.creditoIndividual = generaConsulta(viviendasUsadas.filter(agrupacion == CREDITO_INDIVIDUAL))
        
        let mejoramientos = financiamiento.filter(destino == "Mejoramientos")
        consulta.mejoramientos.cofinanciamiento = generaConsulta(mejoramientos.filter(agrupacion == COFINANCIAMIENTOS))
        consulta.mejoramientos.creditoIndividual = generaConsulta(mejoramientos.filter(agrupacion == CREDITO_INDIVIDUAL))
        
        let otrosProgramas = financiamiento.filter(destino == "Otros programas")
        consulta.otrosProgramas.creditoIndividual = generaConsulta(otrosProgramas.filter(agrupacion == CREDITO_INDIVIDUAL))
        
        consulta.total.monto = financiamiento.sum(monto)!
        consulta.total.acciones = financiamiento.sum(acciones)!
        
        return consulta
    }
    
    private static func generaConsulta(query: Query) -> Consulta {
        var consulta = Consulta()
        consulta.monto = query.sum(monto) ?? 0
        consulta.acciones = query.sum(acciones) ?? 0
        
        return consulta
    }
}
