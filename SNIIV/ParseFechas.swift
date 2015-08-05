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
        super.init(action: "\(Utils.WEB_SERVICE_URL)/WS_App_SNIIV/Fechas")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            println("Fechas status code: \(httpResponse.statusCode)")
            self.serviceResponse!(Fechas(), NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var elemFechas = xml["soap:Envelope"]["soap:Body"]["FechasResponse"]["FechasResult"]["app_sniiv_tot_date"]
                
                var fechas = Fechas(fecha_finan: "(" + Utils.getText(elemFechas["fecha_finan"]) + ")",
                    fecha_subs: "(" + Utils.getText(elemFechas["fecha_subs"]) + ")",
                    fecha_vv: "(" + Utils.getText(elemFechas["fecha_vv"]) + ")")
                self.serviceResponse!(fechas, nil)
            }
        }
    }
}

class Fechas {
    var fecha_finan: String
    var fecha_subs: String
    var fecha_vv: String
    
    init() {
        fecha_finan = ""
        fecha_subs = ""
        fecha_vv = ""
    }
    
    init(fecha_finan: String, fecha_subs: String, fecha_vv: String) {
        self.fecha_finan = fecha_finan
        self.fecha_subs = fecha_subs
        self.fecha_vv = fecha_vv
    }
}