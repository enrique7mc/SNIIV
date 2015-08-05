//
//  ParseReporteGeneral.swift
//  SNIIV
//
//  Created by admin on 16/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseReporteGeneral<T>: ParseBase<[ReporteGeneralPrueba]> {
    
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/Totales")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            println("ReporteGeneral status code: \(httpResponse.statusCode)")
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["TotalesResponse"]["TotalesResult"]["app_sniiv_tot"]
                var datos = sniiv.all.map{ elem in
                    ReporteGeneralPrueba(cveeNT: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        accFinan: Utils.parseInt64(Utils.getText(elem["acc_finan"])),
                        mtoFinan: Utils.parseInt64(Utils.getText(elem["mto_finan"])),
                        accSubs: Utils.parseInt64(Utils.getText(elem["acc_subs"])),
                        mtoSubs: Utils.parseInt64(Utils.getText(elem["mto_subs"])),
                        vv: Utils.parseInt64(Utils.getText(elem["vv"])),
                        vr: Utils.parseInt64(Utils.getText(elem["vr"])))
                }

                self.serviceResponse!(datos as [ReporteGeneralPrueba], nil)
            }
        }
    }
}

struct ReporteGeneralPrueba {
    var cveeNT: Int = 0
    var accFinan: Int64 = 0
    var mtoFinan: Int64 = 0
    var accSubs: Int64 = 0
    var mtoSubs: Int64 = 0
    var vv: Int64 = 0
    var vr: Int64 = 0
}