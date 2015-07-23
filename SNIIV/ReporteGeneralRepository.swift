//
//  ReporteGeneralRepository.swift
//  SNIIV
//
//  Created by admin on 23/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class ReporteGeneralRepository {
    static let db: Database = DBConfig.getInstance().db
    static let cve_ent = Expression<String>("cve_ent")
    static let accFinan = Expression<String>("accFinan")
    static let mtoFinan = Expression<String>("mtoFinan")
    static let accSubs = Expression<String>("accSubs")
    static let mtoSubs = Expression<String>("mtoSubs")
    static let vv = Expression<String>("vv")
    static let vr = Expression<String>("vr")

    
    static func save(reporteGeneral: ReporteGeneralPrueba) {
        let reporte = db["ReporteGeneral"]
        reporte.insert(or: .Replace,
            cve_ent <- reporteGeneral.cveeNT,
            accFinan <- reporteGeneral.accFinan,
            mtoFinan <- reporteGeneral.mtoFinan,
            accSubs <- reporteGeneral.accSubs,
            mtoSubs <- reporteGeneral.mtoSubs,
            vv <- reporteGeneral.vv,
            vr <- reporteGeneral.vr)
    }
    
    static func deleteAll() {
        let reporte = db["ReporteGeneral"]
        reporte.delete()
    }
    
    static func loadFromStorage() -> [ReporteGeneralPrueba] {
        let reporte = db["ReporteGeneral"]
        let all = Array(reporte)
        println(all.count)
        var result: [ReporteGeneralPrueba] = []
        
        for r in all {
            result.append(ReporteGeneralPrueba(cveeNT: r[cve_ent],
                accFinan: r[accFinan],
                mtoFinan: r[mtoFinan],
                accSubs: r[accSubs],
                mtoSubs: r[mtoSubs],
                vv: r[vv],
                vr: r[vr]))
        }
        
        return result
    }
}