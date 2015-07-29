//
//  AvanceObraRepository.swift
//  SNIIV
//
//  Created by admin on 23/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class AvanceObraRepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<Int>("cve_ent")
    static let viv_proc_m50 = Expression<Int64>("viv_proc_m50")
    static let viv_proc_50_99 = Expression<Int64>("viv_proc_50_99")
    static let viv_term_rec = Expression<Int64>("viv_term_rec")
    static let viv_term_ant = Expression<Int64>("viv_term_ant")
    static let total = Expression<Int64>("total")
    
    private static let TABLA = "AvanceObra"
    
    static func save(avanceObra: AvanceObra) {
        let tabla = db[TABLA]
        tabla.insert(or: .Replace,
            cve_ent <- avanceObra.cve_ent,
            viv_proc_m50 <- avanceObra.viv_proc_m50,
            viv_proc_50_99 <- avanceObra.viv_proc_50_99,
            viv_term_rec <- avanceObra.viv_term_rec,
            viv_term_ant <- avanceObra.viv_term_ant,
            total <- avanceObra.total)
    }
    
    static func saveAll(elementos: [AvanceObra]) {
        for e in elementos {
            AvanceObraRepository.save(e)
        }
    }
    
    static func deleteAll() {
        let tabla = db[TABLA]
        tabla.delete()
    }
    
    static func loadFromStorage() -> [AvanceObra] {
        let tabla = db[TABLA]
        let all = Array(tabla)
        var result: [AvanceObra] = []
        
        for r in all {
            result.append(AvanceObra(cve_ent: r[cve_ent],
                viv_proc_m50: r[viv_proc_m50],
                viv_proc_50_99: r[viv_proc_50_99],
                viv_term_rec: r[viv_term_rec],
                viv_term_ant: r[viv_term_ant],
                total: r[total]))
        }
        
        return result
    }
    
    static func consultaNacional() -> AvanceObra {
        let reporte = db[TABLA]
        var datoEntidad = AvanceObra()
        
        datoEntidad.viv_proc_m50 = reporte.sum(viv_proc_m50)!
        datoEntidad.viv_proc_50_99 = reporte.sum(viv_proc_50_99)!
        datoEntidad.viv_term_rec = reporte.sum(viv_term_rec)!
        datoEntidad.viv_term_ant = reporte.sum(viv_term_ant)!
        datoEntidad.total = reporte.sum(total)!
        
        return datoEntidad
    }
}
