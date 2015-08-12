//
//  SubsidiosRepository.swift
//  SNIIV
//
//  Created by admin on 28/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class SubsidioRepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<Int>("cve_ent")
    static let tipo_ee = Expression<String>("tipo_ee")
    static let modalidad = Expression<String>("modalidad")
    static let acciones = Expression<Int64>("acciones")
    static let monto = Expression<Double>("monto")
    
    static let TABLA = "Subsidio"
    private static let COFINANCIAMIENTOS = "Cofinanciamientos y Subsidios"
    private static let CREDITO_INDIVIDUAL = "Crédito Individual"
    
    static func save(reporteGeneral: Subsidio) {
        let reporte = db[TABLA]
        reporte.insert(or: .Replace,
            cve_ent <- reporteGeneral.cve_ent,
            tipo_ee <- reporteGeneral.tipo_ee,
            modalidad <- reporteGeneral.modalidad,
            acciones <- reporteGeneral.acciones,
            monto <- reporteGeneral.monto)
    }
    
    static func saveAll(datos: [Subsidio]) {
        for d in datos {
            SubsidioRepository.save(d)
        }
    }
    
    static func deleteAll() {
        let reporte = db[TABLA]
        reporte.delete()
    }
    
    static func loadFromStorage() -> [Subsidio] {
        let reporte = db[TABLA]
        let all = Array(reporte)
        var result: [Subsidio] = []
        
        for r in all {
            result.append(Subsidio(cve_ent: r[cve_ent],
                tipo_ee: r[tipo_ee],
                modalidad: r[modalidad],
                acciones: r[acciones],
                monto: r[monto]))
        }
        
        return result
    }
    
    static func consultaNacional() -> ConsultaSubsidio {
        return SubsidioRepository.consulta()
    }
    
    static func consultaEntidad(entidad: Entidad) -> ConsultaSubsidio {
        return SubsidioRepository.consulta(filtroOpcional: cve_ent == entidad.rawValue)
    }
    
    private static func consulta(filtroOpcional: Expression<Bool>? = nil) -> ConsultaSubsidio {
        var subsidio = db[TABLA]
        
        if let filtro = filtroOpcional {
            subsidio = subsidio.filter(filtro)
        }
        
        var consulta = ConsultaSubsidio()
        
        consulta.nueva = generaConsulta(subsidio.filter(modalidad == "Nueva"))
        consulta.usada = generaConsulta(subsidio.filter(modalidad == "Usada"))
        consulta.autoproduccion = generaConsulta(subsidio.filter(modalidad == "Autoproducción"))
        consulta.mejoramiento = generaConsulta(subsidio.filter(modalidad == "Mejoramiento"))
        consulta.lotes = generaConsulta(subsidio.filter(modalidad == "Lotes con servicio"))
        consulta.otros = generaConsulta(subsidio.filter(modalidad == "Otros"))
        consulta.total = generaConsulta(subsidio)
        
        return consulta
    }
    
    private static func generaConsulta(query: Query) -> Consulta {
        var consulta = Consulta()
        consulta.monto = query.sum(monto) ?? 0
        consulta.acciones = query.sum(acciones) ?? 0
        
        return consulta
    }
}