//
//  ParseSoap.swift
//  SNIIV
//
//  Created by admin on 08/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

typealias ServiceResponse = ([ReporteGeneral]?, NSError?) -> Void

class ParseSoap : NSObject, NSURLConnectionDelegate {
    var xmlResponse: String?
    var serviceResponse: ServiceResponse?
    
    func getXml(){
        var soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <get_tot_ini xmlns='http://www.conavi.gob.mx:8080/WS_App_SNIIV' /></soap:Body></soap:Envelope>"
    
        var urlString = "http://192.168.10.166:8005/WS_App_SNIIV.asmx"
        var url = NSURL(string: urlString)
        var theRequest = NSMutableURLRequest(URL: url!)
        var msgLength = String(count(soapMessage))
    
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_tot_ini", forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(theRequest, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if let err = error {
                println("async error: " + err.description)
                self.serviceResponse!(nil, NSError())
            } else {
                if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                    self.xmlResponse = dataString as String
                    var xml = SWXMLHash.parse(self.xmlResponse!)
                    var sniiv = xml["soap:Envelope"]["soap:Body"]["get_tot_iniResponse"]["get_tot_iniResult"]["app_sniiv_tot"]
                    var datos = sniiv.all.map{ elem in
                        ReporteGeneral(cveeNT: self.getText(elem["cve_ent"]),
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
        })
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
