//
//  ParseAvanceObra.swift
//  SNIIV
//
//  Created by admin on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseAvanceObra<T>: ParseBase<[AvanceObra]> {
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/viv_vig_x_avnc")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        if let err = error {
            println("async error: " + err.description)
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["viv_vig_x_avncResponse"]["viv_vig_x_avncResult"]["app_sniiv_vv_x_avanc"]
                var datos = sniiv.all.map{ elem in
                    AvanceObra(cve_ent: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        viv_proc_m50: Utils.parseInt64(Utils.getText(elem["viv_proc_m50"])),
                        viv_proc_50_99: Utils.parseInt64(Utils.getText(elem["viv_proc_50_99"])),
                        viv_term_rec: Utils.parseInt64(Utils.getText(elem["viv_term_rec"])),
                        viv_term_ant: Utils.parseInt64(Utils.getText(elem["viv_term_ant"])),
                        total: Utils.parseInt64(Utils.getText(elem["total"])))
                }
                
                self.serviceResponse!(datos as [AvanceObra], nil)
            }
        }
    }
}

struct AvanceObra {
    var cve_ent: Int = 0
    var viv_proc_m50: Int64 = 0
    var viv_proc_50_99: Int64 = 0
    var viv_term_rec: Int64 = 0
    var viv_term_ant: Int64 = 0
    var total: Int64 = 0
}