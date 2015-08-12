//
//  TipoViviendaRepository.swift
//  SNIIV
//
//  Created by admin on 24/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class TipoViviendaRepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<Int>("cve_ent")
    static let horizontal = Expression<Int64>("horizontal")
    static let vertical = Expression<Int64>("vertical")
    static let total = Expression<Int64>("total")
    
    static let TABLA = "TipoVivienda"
    
    static func save(tipo: TipoVivienda) {
        let tabla = db[TABLA]
        tabla.insert(or: .Replace,
            cve_ent <- tipo.cve_ent,
            horizontal <- tipo.horizontal,
            vertical <- tipo.vertical,
            total <- tipo.total)
    }
    
    static func saveAll(elementos: [TipoVivienda]) {
        for e in elementos {
            TipoViviendaRepository.save(e)
        }
    }
    
    static func deleteAll() {
        let tabla = db[TABLA]
        tabla.delete()
    }
    
    static func loadFromStorage() -> [TipoVivienda] {
        let tabla = db[TABLA]
        let all = Array(tabla)
        var result: [TipoVivienda] = []
        
        for r in all {
            result.append(TipoVivienda(cve_ent: r[cve_ent],
                horizontal: r[horizontal],
                vertical: r[vertical],
                total: r[total]))
        }
        
        return result
    }
    
    static func consultaNacional() -> TipoVivienda {
        let reporte = db[TABLA]
        var datoEntidad = TipoVivienda()
        
        datoEntidad.horizontal = reporte.sum(horizontal)!
        datoEntidad.vertical = reporte.sum(vertical)!
        datoEntidad.total = reporte.sum(total)!
        
        return datoEntidad
    }
}

