//
//  ParseSubsidios.swift
//  SNIIV
//
//  Created by admin on 22/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseSubsidios<T>: ParseBase<[Subsidio]> {
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/Subsidios")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            print("ParseSubsidios status code: \(httpResponse.statusCode)", terminator: "")
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["SubsidiosResponse"]["SubsidiosResult"]["app_sniiv_rep_subs"]
                var datos = sniiv.all.map{ elem in
                    Subsidio(cve_ent: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        tipo_ee: Utils.getText(elem["tipo_ee"]),
                        modalidad: Utils.getText(elem["modalidad"]),
                        acciones: Utils.parseInt64(Utils.getText(elem["acciones"])),
                        monto: Utils.parseDouble(Utils.getText(elem["monto"])))
                }
                
                self.serviceResponse!(datos as [Subsidio], nil)
            }
        }
    }
}

struct Subsidio {
    var cve_ent: Int = 0
    var tipo_ee: String = ""
    var modalidad: String = ""
    var acciones: Int64 = 0
    var monto: Double = 0
}