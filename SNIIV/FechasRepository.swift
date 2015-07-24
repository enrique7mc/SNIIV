//
//  FechasRepository.swift
//  SNIIV
//
//  Created by admin on 23/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class FechasRepository {
    static let db: Database = DBConfig.getInstance().db
    static let fecha_finan = Expression<String>("fecha_finan")
    static let fecha_subs = Expression<String>("fecha_subs")
    static let fecha_vv = Expression<String>("fecha_vv")
    
    static func save(fecha: Fechas) {
        let fechas = db["Fechas"]
        fechas.insert(or: .Replace,
            fecha_finan <- fecha.fecha_finan,
            fecha_subs <- fecha.fecha_subs,
            fecha_vv <- fecha.fecha_vv)
    }
    
    static func deleteAll() {
        let reporte = db["Fechas"]
        reporte.delete()
    }
    
    static func selectFechas() -> Fechas? {
        let reporte = db["Fechas"]
        
        if let fechas = reporte.first {
            return Fechas(fecha_finan: fechas[fecha_finan], fecha_subs: fechas[fecha_subs], fecha_vv: fechas[fecha_vv])
        }
        
        return nil
    }
}