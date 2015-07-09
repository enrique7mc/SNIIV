//
//  DataProvider.swift
//  SNIIV
//
//  Created by admin on 09/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation


typealias ServiceResponse = (NSDictionary?, NSError?) -> Void

class DataProvider {
    
    class var sharedInstance: DataProvider {
        struct Singleton {
            static let instance = DataProvider()
        }
        return Singleton.instance
    }
    
    func getDatos(onCompletion: ServiceResponse) -> [ReporteGeneral] {
        var parseSoap = ParseSoap()
        parseSoap.getDatosReporte()
    }

    
}
