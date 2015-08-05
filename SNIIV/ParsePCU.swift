//
//  ParsePCU.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParsePCU<T>: ParseBase<[PCU]> {
    init() {
        super.init(action: "\(Utils.WEB_SERVICE_URL)/WS_App_SNIIV/PCU_Vivienda_Vigente")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            println("ParsePCU status code: \(httpResponse.statusCode)")
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["PCU_Vivienda_VigenteResponse"]["PCU_Vivienda_VigenteResult"]["app_sniiv_vv_x_pcu"]
                var datos = sniiv.all.map{ elem in
                    PCU(cve_ent: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        u1: Utils.parseInt64(Utils.getText(elem["u1"])),
                        u2: Utils.parseInt64(Utils.getText(elem["u2"])),
                        u3: Utils.parseInt64(Utils.getText(elem["u3"])),
                        fc: Utils.parseInt64(Utils.getText(elem["fc"])),
                        nd: Utils.parseInt64(Utils.getText(elem["nd"])),
                        total: Utils.parseInt64(Utils.getText(elem["total"])))
                }
                
                self.serviceResponse!(datos as [PCU], nil)
            }
        }
    }
}

struct PCU {
    var cve_ent: Int = 0
    var u1: Int64 = 0
    var u2: Int64 = 0
    var u3: Int64 = 0
    var fc: Int64 = 0
    var nd: Int64 = 0
    var total: Int64 = 0
}
