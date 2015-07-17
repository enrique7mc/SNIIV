//
//  ParseFechas.swift
//  SNIIV
//
//  Created by admin on 17/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseFechas<T>: ParseBase<Fechas> {
    
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_tot_fech")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        if let err = error {
            println("async error: " + err.description)
            self.serviceResponse!(Fechas(), NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var elemFechas = xml["soap:Envelope"]["soap:Body"]["get_tot_fechResponse"]["get_tot_fechResult"]["app_sniiv_tot_date"]
                
                var fechas = Fechas(fecha_finan: "(" + Utils.getText(elemFechas["fecha_finan"]) + ")",
                    fecha_subs: "(" + Utils.getText(elemFechas["fecha_subs"]) + ")",
                    fecha_vv: "(" + Utils.getText(elemFechas["fecha_vv"]) + ")")
                self.serviceResponse!(fechas, nil)
            }
        }
    }
}