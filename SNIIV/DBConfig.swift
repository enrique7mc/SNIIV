//
//  DBConfig.swift
//  SNIIV
//
//  Created by admin on 23/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class DBConfig {
    private static let instance: DBConfig = DBConfig()
    let db: Database
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first as! String
        
        self.db = Database("\(path)/sniiv.sqlite3")
    }
    
    static func getInstance() -> DBConfig {
        return DBConfig.instance
    }
    
    func initialize() {
        initializeReporteGeneral()
        initializeFechas()
        initializeAvanceObra()
        initializePCU()
        initializeTipoVivienda()
        initializeValorVivienda()
    }
    
    private func initializeReporteGeneral() {
        let reporteGeneral = db["ReporteGeneral"]
        let cve_ent = Expression<String>("cve_ent")
        let accFinan = Expression<String>("accFinan")
        let mtoFinan = Expression<String>("mtoFinan")
        let accSubs = Expression<String>("accSubs")
        let mtoSubs = Expression<String>("mtoSubs")
        let vv = Expression<String>("vv")
        let vr = Expression<String>("vr")
        
        db.create(table: reporteGeneral, ifNotExists: true) {
            t in
            t.column(cve_ent)
            t.column(accFinan)
            t.column(mtoFinan)
            t.column(accSubs)
            t.column(mtoSubs)
            t.column(vv)
            t.column(vr)
        }
    }
    
    private func initializeFechas() {
        let fechas = db["Fechas"]
        let fecha_finan = Expression<String>("fecha_finan")
        let fecha_subs = Expression<String>("fecha_subs")
        let fecha_vv = Expression<String>("fecha_vv")
        
        db.create(table: fechas, ifNotExists: true) {
            t in
            t.column(fecha_finan)
            t.column(fecha_subs)
            t.column(fecha_vv)
        }
    }
    
    private func initializeAvanceObra() {
        let avanceObra = db["AvanceObra"]
        let cve_ent = Expression<Int>("cve_ent")
        let viv_proc_m50 = Expression<Int64>("viv_proc_m50")
        let viv_proc_50_99 = Expression<Int64>("viv_proc_50_99")
        let viv_term_rec = Expression<Int64>("viv_term_rec")
        let viv_term_ant = Expression<Int64>("viv_term_ant")
        let total = Expression<Int64>("total")
        
        db.create(table: avanceObra, ifNotExists: true) {
            t in
            t.column(cve_ent)
            t.column(viv_proc_m50)
            t.column(viv_proc_50_99)
            t.column(viv_term_rec)
            t.column(viv_term_ant)
            t.column(total)
        }
    }
    
    private func initializePCU() {
        let pcu = db["PCU"]
        let cve_ent = Expression<Int>("cve_ent")
        let u1 = Expression<Int64>("u1")
        let u2 = Expression<Int64>("u2")
        let u3 = Expression<Int64>("u3")
        let fc = Expression<Int64>("fc")
        let nd = Expression<Int64>("nd")
        let total = Expression<Int64>("total")
        
        db.create(table: pcu, ifNotExists: true) {
            t in
            t.column(cve_ent)
            t.column(u1)
            t.column(u2)
            t.column(u3)
            t.column(fc)
            t.column(nd)
            t.column(total)
        }
    }
    
    private func initializeTipoVivienda() {
        let table = db["TipoVivienda"]
        let cve_ent = Expression<Int>("cve_ent")
        let horizontal = Expression<Int64>("horizontal")
        let vertical = Expression<Int64>("vertical")
        let total = Expression<Int64>("total")
        
        db.create(table: table, ifNotExists: true) {
            t in
            t.column(cve_ent)
            t.column(horizontal)
            t.column(vertical)
            t.column(total)
        }
    }
    
    private func initializeValorVivienda() {
        let table = db["ValorVivienda"]
        let cve_ent = Expression<Int>("cve_ent")
        let economica = Expression<Int64>("economica")
        let popular = Expression<Int64>("popular")
        let tradicional = Expression<Int64>("tradicional")
        let media_residencial = Expression<Int64>("media_residencial")
        let total = Expression<Int64>("total")
        
        db.create(table: table, ifNotExists: true) {
            t in
            t.column(cve_ent)
            t.column(economica)
            t.column(popular)
            t.column(tradicional)
            t.column(media_residencial)
            t.column(total)
        }
    }
}