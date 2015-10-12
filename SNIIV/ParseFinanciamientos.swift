import Foundation
import SWXMLHash

class ParseFinanciamientos<T>: ParseBase<[Financiamiento]> {
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/Financiamientos")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            print("ParseFinanciamientos status code: \(httpResponse.statusCode)", terminator: "")
            self.serviceResponse!([], NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var sniiv = xml["soap:Envelope"]["soap:Body"]["FinanciamientosResponse"]["FinanciamientosResult"]["app_sniiv_rep_finan"]
                var datos = sniiv.all.map{ elem in
                    Financiamiento(cve_ent: Utils.parseInt(Utils.getText(elem["cve_ent"])),
                        organismo: Utils.getText(elem["organismo"]),
                        destino: Utils.getText(elem["destino"]),
                        agrupacion: Utils.getText(elem["agrupacion"]),
                        acciones: Utils.parseInt64(Utils.getText(elem["acciones"])),
                        monto: Utils.parseDouble(Utils.getText(elem["monto"])))
                }
                
                self.serviceResponse!(datos as [Financiamiento], nil)
            }
        }
    }
}

struct Financiamiento {
    var cve_ent: Int = 0
    var organismo: String = ""
    var destino: String = ""
    var agrupacion: String = ""
    var acciones: Int64 = 0
    var monto: Double = 0
}
