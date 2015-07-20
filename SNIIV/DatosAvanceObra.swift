//
//  DatosAvanceObra.swift
//  SNIIV
//
//  Created by admin on 20/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosAvanceObra {
    var datos: [AvanceObra]
    
    init (datos: [AvanceObra]) {
        self.datos = datos
    }
    
    func consultaNacional() -> AvanceObra {
        var datoEntidad = AvanceObra()
        
        var viv_proc_m50: Int64 = datos.map{ return $0.viv_proc_m50 }.reduce(0) {$0 + $1}
        datoEntidad.viv_proc_m50 = viv_proc_m50
        
        var viv_proc_50_99: Int64 = datos.map{ return $0.viv_proc_50_99 }.reduce(0) {$0 + $1}
        datoEntidad.viv_proc_50_99 = viv_proc_50_99
        
        var viv_term_rec: Int64 = datos.map{ return $0.viv_term_rec }.reduce(0) {$0 + $1}
        datoEntidad.viv_term_rec = viv_term_rec
        
        var viv_term_ant: Int64 = datos.map{ return $0.viv_term_ant }.reduce(0) {$0 + $1}
        datoEntidad.viv_term_ant = viv_term_ant
        
        var total: Int64 = datos.map{ return $0.total }.reduce(0) {$0 + $1}
        datoEntidad.viv_term_ant = total
        
        
        return datoEntidad
    }
    
    func consultaEntidad(entidad: Entidad) -> AvanceObra {
        var datoEntidad = datos.filter() {
            return $0.cve_ent == entidad.rawValue
        }
        
        return datoEntidad.first!
    }
}