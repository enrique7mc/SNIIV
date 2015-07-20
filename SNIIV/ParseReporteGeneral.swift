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
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_tot_ini")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        if let err = error {
            println("async error: " + err.description)
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["get_tot_iniResponse"]["get_tot_iniResult"]["app_sniiv_tot"]
                var datos = sniiv.all.map{ elem in
                    ReporteGeneralPrueba(cveeNT: Utils.getText(elem["cve_ent"]),
                        accFinan: Utils.getText(elem["acc_finan"]),
                        mtoFinan: Utils.getText(elem["mto_finan"]),
                        accSubs: Utils.getText(elem["acc_subs"]),
                        mtoSubs: Utils.getText(elem["mto_subs"]),
                        vv: Utils.getText(elem["vv"]),
                        vr: Utils.getText(elem["vr"]))
                }

                self.serviceResponse!(datos as [ReporteGeneralPrueba], nil)
            }
        }
    }
}

struct ReporteGeneralPrueba {
    var cveeNT: String = ""
    var accFinan: String = ""
    var mtoFinan: String = ""
    var accSubs: String = ""
    var mtoSubs: String = ""
    var vv: String = ""
    var vr: String = ""
}