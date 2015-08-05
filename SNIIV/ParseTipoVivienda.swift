//
//  ParseTipoVivienda.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseTipoVivienda<T>: ParseBase<[TipoVivienda]> {
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/Tipo_Vivienda_Vigente")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            println("ParseTipoVivienda status code: \(httpResponse.statusCode)")
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["Tipo_Vivienda_VigenteResponse"]["Tipo_Vivienda_VigenteResult"]["app_sniiv_vv_x_tipo"]
                var datos = sniiv.all.map{ elem in
                    TipoVivienda(cve_ent: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        horizontal: Utils.parseInt64(Utils.getText(elem["horizontal"])),
                        vertical: Utils.parseInt64(Utils.getText(elem["vertical"])),
                        total: Utils.parseInt64(Utils.getText(elem["total"])))
                }
                
                self.serviceResponse!(datos as [TipoVivienda], nil)
            }
        }
    }
}

struct TipoVivienda {
    var cve_ent: Int = 0
    var horizontal: Int64 = 0
    var vertical: Int64 = 0
    var total: Int64 = 0
}