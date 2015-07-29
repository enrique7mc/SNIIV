//
//  PCURepository.swift
//  SNIIV
//
//  Created by admin on 23/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class PCURepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<Int>("cve_ent")
    static let u1 = Expression<Int64>("u1")
    static let u2 = Expression<Int64>("u2")
    static let u3 = Expression<Int64>("u3")
    static let fc = Expression<Int64>("fc")
    static let nd = Expression<Int64>("nd")
    static let total = Expression<Int64>("total")
    
    private static let TABLA = "PCU"
    
    static func save(pcu: PCU) {
        let tabla = db[TABLA]
        tabla.insert(or: .Replace,
            cve_ent <- pcu.cve_ent,
            u1 <- pcu.u1,
            u2 <- pcu.u2,
            u3 <- pcu.u3,
            fc <- pcu.fc,
            nd <- pcu.nd,
            total <- pcu.total)
    }
    
    static func saveAll(elementos: [PCU]) {
        for e in elementos {
            PCURepository.save(e)
        }
    }
    
    static func deleteAll() {
        let tabla = db[TABLA]
        tabla.delete()
    }
    
    static func loadFromStorage() -> [PCU] {
        let tabla = db[TABLA]
        let all = Array(tabla)
        var result: [PCU] = []
        
        for r in all {
            result.append(PCU(cve_ent: r[cve_ent],
                u1: r[u1],
                u2: r[u2],
                u3: r[u3],
                fc: r[fc],
                nd: r[nd],
                total: r[total]))
        }
        
        return result
    }
    
    static func consultaNacional() -> PCU {
        let reporte = db[TABLA]
        var datoEntidad = PCU()
        
        datoEntidad.u1 = reporte.sum(u1)!
        datoEntidad.u2 = reporte.sum(u2)!
        datoEntidad.u3 = reporte.sum(u3)!
        datoEntidad.fc = reporte.sum(fc)!
        datoEntidad.nd = reporte.sum(nd)!
        datoEntidad.total = reporte.sum(total)!
        
        return datoEntidad
    }
}


