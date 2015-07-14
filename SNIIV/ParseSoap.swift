//
//  ParseSoap.swift
//  SNIIV
//
//  Created by admin on 08/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

typealias ServiceResponse = ([ReporteGeneralPrueba]?, NSError?) -> Void

class ParseSoap {
    var xmlResponse: String?
    var serviceResponse: ServiceResponse?
    
    func getXml() {
        var soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <get_tot_ini xmlns='http://www.conavi.gob.mx:8080/WS_App_SNIIV' /></soap:Body></soap:Envelope>"
    
        var urlString = "http://www.conavi.gob.mx:8080/WS_App_SNIIV.asmx"
        var soapAction = "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_tot_ini"
        
        var soapToXml = SoapToXml(message: soapMessage, url: urlString, soapAction: soapAction, method: "POST", completionHandler: handler)
        
        soapToXml.responseXlm()
    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        if let err = error {
            println("async error: " + err.description)
            self.serviceResponse!(nil, NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse!)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["get_tot_iniResponse"]["get_tot_iniResult"]["app_sniiv_tot"]
                var datos = sniiv.all.map{ elem in
                    ReporteGeneralPrueba(cveeNT: self.getText(elem["cve_ent"]),
                        accFinan: self.getText(elem["acc_finan"]),
                        mtoFinan: self.getText(elem["mto_finan"]),
                        accSubs: self.getText(elem["acc_subs"]),
                        mtoSubs: self.getText(elem["mto_subs"]),
                        vv: self.getText(elem["vv"]),
                        vr: self.getText(elem["vr"]))
                }
                println(datos.count)
                self.serviceResponse!(datos, nil)
            }
        }
    }
    
    func getText(indexer: XMLIndexer) -> String {
        if let element = indexer.element, text = element.text {
            return text;
        } else {
            return "";
        }
    }
    
    func getDatosReporte(onCompletion: ServiceResponse) {
        getXml()
        serviceResponse = onCompletion
    }
}
