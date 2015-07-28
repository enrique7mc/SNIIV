//
//  DatosFinanciamiento.swift
//  SNIIV
//
//  Created by admin on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class DatosFinanciamiento {
    
    private var nacional: ConsultaFinanciamiento?
    
    func consultaNacional() -> ConsultaFinanciamiento {
        if nacional == nil {
            nacional = FinanciamientoRepository.consultaNacional()
        }
        
        return nacional!
    }
    
    func consultaEntidad(entidad: Entidad) -> ConsultaFinanciamiento {
        return FinanciamientoRepository.consultaEntidad(entidad)
    }
}

struct ConsultaFinanciamiento {
    var viviendasNuevas: FinanciamientoResultado = FinanciamientoResultado()
    var viviendasUsadas: FinanciamientoResultado = FinanciamientoResultado()
    var mejoramientos: FinanciamientoResultado = FinanciamientoResultado()
    var otrosProgramas: FinanciamientoResultado = FinanciamientoResultado()
    var total: Consulta = Consulta()
    
    struct FinanciamientoResultado {
        var cofinanciamiento: Consulta = Consulta()
        var creditoIndividual: Consulta = Consulta()
    }
}