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
    static let cve_ent = Expression<Int>("cve_ent")
    static let accFinan = Expression<Int64>("accFinan")
    static let mtoFinan = Expression<Int64>("mtoFinan")
    static let accSubs = Expression<Int64>("accSubs")
    static let mtoSubs = Expression<Int64>("mtoSubs")
    static let vv = Expression<Int64>("vv")
    static let vr = Expression<Int64>("vr")
    
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
    
    static func saveAll(reportes: [ReporteGeneralPrueba]) {
        for r in reportes {
            ReporteGeneralRepository.save(r)
        }
    }
    
    static func deleteAll() {
        let reporte = db["ReporteGeneral"]
        reporte.delete()
    }
    
    static func loadFromStorage() -> [ReporteGeneralPrueba] {
        let reporte = db["ReporteGeneral"]
        let all = Array(reporte)
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
    
    static func consultaNacional() -> ReporteGeneralPrueba {
        let reporte = db["ReporteGeneral"]
        var datoEntidad = ReporteGeneralPrueba()
        
        datoEntidad.accFinan = reporte.sum(accFinan)!
        datoEntidad.mtoFinan = reporte.sum(mtoFinan)!
        datoEntidad.accSubs = reporte.sum(accSubs)!
        datoEntidad.mtoSubs = reporte.sum(mtoSubs)!
        datoEntidad.vv = reporte.sum(vv)!
        datoEntidad.vr = reporte.sum(vr)!
        
        return datoEntidad
    }
}