//
//  ParseValorVivienda.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseValorVivienda<T>: ParseBase<[ValorVivienda]> {
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/Valor_Vivienda_Vigente")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            print("ParseValorVivienda status code: \(httpResponse.statusCode)", terminator: "")
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["Valor_Vivienda_VigenteResponse"]["Valor_Vivienda_VigenteResult"]["app_sniiv_vv_x_val"]
                var datos = sniiv.all.map{ elem in
                    ValorVivienda(cve_ent: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        economica: Utils.parseInt64(Utils.getText(elem["economica"])),
                        popular: Utils.parseInt64(Utils.getText(elem["popular"])),
                        tradicional: Utils.parseInt64(Utils.getText(elem["tradicional"])),
                        media_residencial: Utils.parseInt64(Utils.getText(elem["media_residencial"])),
                        total: Utils.parseInt64(Utils.getText(elem["total"])))
                }
                
                self.serviceResponse!(datos as [ValorVivienda], nil)
            }
        }
    }
}

struct ValorVivienda {
    var cve_ent: Int = 0
    var economica: Int64 = 0
    var popular: Int64 = 0
    var tradicional: Int64 = 0
    var media_residencial: Int64 = 0
    var total: Int64 = 0
}