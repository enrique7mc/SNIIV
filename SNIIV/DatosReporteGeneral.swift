//
//  ReporteGeneral.swift
//  SNIIV
//
//  Created by admin on 09/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation


class DatosReporteGeneral {
    var datos: [ReporteGeneralPrueba]
    
    init (datos: [ReporteGeneralPrueba]) {
        self.datos = datos
    }
    
    func consultaNacional() -> ReporteGeneralPrueba {
        var datoEntidad = ReporteGeneralPrueba()
        
        var accFinanTotal: Int64 = datos.map{return Utils.parseInt64($0.accFinan)}.reduce(0, combine: Utils.Sumar)
        datoEntidad.accFinan = Utils.toStringDivide(accFinanTotal)
        
        var mtoFinanTotal: Int64 = datos.map{return Utils.parseInt64($0.mtoFinan)}.reduce(0, combine: Utils.Sumar)
        datoEntidad.mtoFinan = Utils.toStringDivide(mtoFinanTotal, divide: 1000000)
        
        var accSubsTotal: Int64 = datos.map{return Utils.parseInt64($0.accSubs)}.reduce(0, combine: Utils.Sumar)
        datoEntidad.accSubs = Utils.toStringDivide(accSubsTotal)
        
        var mtoSubsTotal: Int64 = datos.map{return Utils.parseInt64($0.mtoSubs)}.reduce(0, combine: Utils.Sumar)
        datoEntidad.mtoSubs = Utils.toStringDivide(mtoSubsTotal, divide: 1000000)
        
        var vvTotal: Int64 = datos.map{return Utils.parseInt64($0.vv)}.reduce(0, combine: Utils.Sumar)
        datoEntidad.vv = Utils.toStringDivide(vvTotal)
        
        var vrTotal: Int64 = datos.map{return Utils.parseInt64($0.vr)}.reduce(0, combine: Utils.Sumar)
        datoEntidad.vr = Utils.toStringDivide(vrTotal)
        
        return datoEntidad
    }
    
    func consultaEntidad(entidad: Entidad) -> ReporteGeneralPrueba {
        var datoEntidad = datos.filter() {
            return $0.cveeNT.toInt()! == entidad.rawValue
        }
        
        return formatoReporte(datoEntidad.first!)
    }
    
    func formatoReporte(reporte: ReporteGeneralPrueba) -> ReporteGeneralPrueba{
        var datoEntidad = ReporteGeneralPrueba()
        
        datoEntidad.accFinan = Utils.toStringDivide(Utils.parseInt64(reporte.accFinan))
        datoEntidad.mtoFinan = Utils.toStringDivide(Utils.parseInt64(reporte.mtoFinan), divide: 1000000)
        datoEntidad.accSubs = Utils.toStringDivide(Utils.parseInt64(reporte.accSubs))
        datoEntidad.mtoSubs = Utils.toStringDivide(Utils.parseInt64(reporte.mtoSubs), divide: 1000000)
        datoEntidad.vv = Utils.toStringDivide(Utils.parseInt64(reporte.vv))
        datoEntidad.vr = Utils.toStringDivide(Utils.parseInt64(reporte.vr))
        
        return datoEntidad
    }
}
