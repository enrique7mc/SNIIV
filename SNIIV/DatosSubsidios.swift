//
//  DatosSubsidios.swift
//  SNIIV
//
//  Created by admin on 22/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosSubsidios {
    private var nacional: ConsultaSubsidio?
    
    func consultaNacional() -> ConsultaSubsidio {
        if nacional == nil {
            nacional = SubsidioRepository.consultaNacional()
        }
        
        return nacional!
    }
    
    func consultaEntidad(entidad: Entidad) -> ConsultaSubsidio {
        return SubsidioRepository.consultaEntidad(entidad)
    }
}

struct Consulta {
    var acciones: Int64 = 0
    var monto: Double = 0
}

struct ConsultaSubsidio {
    var nueva: Consulta = Consulta()
    var usada: Consulta = Consulta()
    var autoproduccion: Consulta = Consulta()
    var mejoramiento: Consulta = Consulta()
    var lotes: Consulta = Consulta()
    var otros: Consulta = Consulta()
    var total: Consulta = Consulta()
}