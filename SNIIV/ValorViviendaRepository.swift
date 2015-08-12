//
//  ValorViviendaRepository.swift
//  SNIIV
//
//  Created by admin on 23/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class ValorViviendaRepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<Int>("cve_ent")
    static let economica = Expression<Int64>("economica")
    static let popular = Expression<Int64>("popular")
    static let tradicional = Expression<Int64>("tradicional")
    static let media_residencial = Expression<Int64>("media_residencial")
    static let total = Expression<Int64>("total")
    
    static let TABLA = "ValorVivienda"
    
    static func save(valor: ValorVivienda) {
        let tabla = db[TABLA]
        tabla.insert(or: .Replace,
            cve_ent <- valor.cve_ent,
            economica <- valor.economica,
            popular <- valor.popular,
            tradicional <- valor.tradicional,
            media_residencial <- valor.media_residencial,
            total <- valor.total)
    }
    
    static func saveAll(elementos: [ValorVivienda]) {
        for e in elementos {
            ValorViviendaRepository.save(e)
        }
    }
    
    static func deleteAll() {
        let tabla = db[TABLA]
        tabla.delete()
    }
    
    static func loadFromStorage() -> [ValorVivienda] {
        let tabla = db[TABLA]
        let all = Array(tabla)
        var result: [ValorVivienda] = []
        
        for r in all {
            result.append(ValorVivienda(cve_ent: r[cve_ent],
                economica: r[economica],
                popular: r[popular],
                tradicional: r[tradicional],
                media_residencial: r[media_residencial],
                total: r[total]))
        }
        
        return result
    }
    
    static func consultaNacional() -> ValorVivienda {
        let reporte = db[TABLA]
        var datoEntidad = ValorVivienda()
        
        datoEntidad.economica = reporte.sum(economica)!
        datoEntidad.popular = reporte.sum(popular)!
        datoEntidad.tradicional = reporte.sum(tradicional)!
        datoEntidad.media_residencial = reporte.sum(media_residencial)!
        datoEntidad.total = reporte.sum(total)!
        
        return datoEntidad
    }
}

