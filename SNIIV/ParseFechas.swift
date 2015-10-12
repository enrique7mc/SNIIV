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
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/Fechas")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            print("Fechas status code: \(httpResponse.statusCode)", terminator: "")
            self.serviceResponse!(Fechas(), NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var elemFechas = xml["soap:Envelope"]["soap:Body"]["FechasResponse"]["FechasResult"]["app_sniiv_tot_date"]
                
                var fechas = Fechas(fecha_finan: "(" + Utils.getText(elemFechas["fecha_finan"]).stringByReplacingOccurrencesOfString("Datos al ", withString: "") + ")",
                    fecha_subs: "(" + Utils.getText(elemFechas["fecha_subs"]) + ")",
                    fecha_vv: "(" + Utils.getText(elemFechas["fecha_vv"]) + ")")
                self.serviceResponse!(fechas, nil)
            }
        }
    }
}

// TODO revisar igualdad de fechas
struct Fechas {
    var fecha_finan: String
    var fecha_subs: String
    var fecha_vv: String
    
    init() {
        fecha_finan = ""
        fecha_subs = ""
        fecha_vv = ""
    }
    
    init(fechasDictionary: [String: AnyObject]) {
        self.fecha_finan = fechasDictionary["fecha_finan"] as! String
        self.fecha_subs = fechasDictionary["fecha_subs"] as! String
        self.fecha_vv = fechasDictionary["fecha_vv"] as! String
    }
    
    init(fecha_finan: String, fecha_subs: String, fecha_vv: String) {
        self.fecha_finan = fecha_finan
        self.fecha_subs = fecha_subs
        self.fecha_vv = fecha_vv
    }
}

extension Fechas: Equatable {}

func ==(lhs: Fechas, rhs: Fechas) -> Bool {
    return lhs.fecha_finan == rhs.fecha_finan && lhs.fecha_subs == rhs.fecha_subs && lhs.fecha_vv == rhs.fecha_vv
}