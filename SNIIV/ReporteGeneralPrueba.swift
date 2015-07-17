//
//  ReporteGeneral.swift
//  SNIIV
//
//  Created by admin on 09/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

struct DatoEntidad {
    var cveeNT: Int = 0
    var accFinan: Int64 = 0
    var mtoFinan: Int64 = 0
    var accSubs: Int64 = 0
    var mtoSubs: Int64 = 0
    var vv: Int64 = 0
    var vr: Int64 = 0
}

class DatosReporteGeneral {
    var datos: [ReporteGeneralPrueba]
    
    init (datos: [ReporteGeneralPrueba]) {
        self.datos = datos
    }
    
    func consultaNacional() -> DatoEntidad {
        var datoEntidad = DatoEntidad()
        
        var accFinanTotal: Int64 = datos.map{return Utils.parseInt64($0.accFinan)}.reduce(0) {$0 + $1}
        datoEntidad.accFinan = accFinanTotal
        
        var mtoFinanTotal: Int64 = datos.map{return Utils.parseInt64($0.mtoFinan)}.reduce(0) {$0 + $1}
        datoEntidad.mtoFinan = mtoFinanTotal
        
        var accSubsTotal: Int64 = datos.map{return Utils.parseInt64($0.accSubs)}.reduce(0) {$0 + $1}
        datoEntidad.accSubs = accSubsTotal
        
        var mtoSubsTotal: Int64 = datos.map{return Utils.parseInt64($0.mtoSubs)}.reduce(0) {$0 + $1}
        datoEntidad.mtoSubs = mtoSubsTotal
        
        var vvTotal: Int64 = datos.map{return Utils.parseInt64($0.vv)}.reduce(0) {$0 + $1}
        datoEntidad.vv = vvTotal
        
        var vrTotal: Int64 = datos.map{return Utils.parseInt64($0.vr)}.reduce(0) {$0 + $1}
        datoEntidad.vr = vrTotal
        
        return datoEntidad
    }
    
    func consultaEntidad(entidad: Entidad) -> DatoEntidad {
        var datoEntidad = datos.filter() {
            return $0.cveeNT.toInt()! == entidad.rawValue
        }
        
        var dato = datoEntidad.map { DatoEntidad(cveeNT: Utils.parseInt($0.cveeNT),
                accFinan: Utils.parseInt64($0.accFinan),
                mtoFinan: Utils.parseInt64($0.mtoFinan),
                accSubs: Utils.parseInt64($0.accSubs),
                mtoSubs: Utils.parseInt64($0.mtoSubs),
                vv: Utils.parseInt64($0.vv),
                vr: Utils.parseInt64($0.vr))}
        
        return dato.first!
    }
}
