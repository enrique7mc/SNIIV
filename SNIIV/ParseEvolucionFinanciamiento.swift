import Foundation
import SWXMLHash

class ParseEvolucionFinanciamiento<T>: ParseBase<Evolucion> {
    
    var aux: [String] = []
    
    init(){
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_finan_evol_acum")
    }
    
    func saveFile(datastring: NSString){
        
        let file = "jsonFinan.txt"
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            let text = datastring
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
           
            print("saved")
        }
        
    }
    
    

    

    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void{

       var estados = [String, EvolucionFinanciamiento]()
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200{
            print("ParseEvolucionFinanciamientos status code: \(httpResponse.statusCode)")
            self.serviceResponse!(Evolucion(), NSError())
        }
        else{
            if let dataString=NSString(data: data, encoding: NSUTF8StringEncoding){
                self.xmlResponse = dataString as String
                var xml=SWXMLHash.parse(self.xmlResponse)
                var evol = xml["soap:Envelope"]["soap:Body"]["get_finan_evol_acumResponse"]["get_finan_evol_acumResult"]
                let jsonString = Utils.getText(evol)
                
                let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
                
                var datastring = NSString(data: data, encoding: UInt())
                saveFile(datastring!)
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                if let item = jsonResult{
                    
                    let keys = (jsonResult!.allKeys as! [String]).sorted(<)
                    
                    for key in keys{
                       estados.append(key, EvolucionFinanciamiento(evolAnyObject: item[key]!))
                        
                    }
                    var evo =  Evolucion(test: estados)
                    self.serviceResponse!(evo, nil)
                   
                }
                
                
            }
            
           
        }
        
    }
    
}

struct Evolucion {
    var pEstados = [String, EvolucionFinanciamiento]()
    init(test: [(String, EvolucionFinanciamiento)]){
        pEstados = test
    }
    init(){
        pEstados = []
    }
}


struct EvolucionFinanciamiento {
    var periodos = [String, EvolucionFinanciamientoResultado]()
    
        init(evolAnyObject: AnyObject){
            let jsonArray: NSArray = (evolAnyObject as? NSArray)!
            for j in jsonArray{
                if let jsonResult = j as? NSDictionary {
                    let keys = (j.allKeys as! [String]).sorted(<)
                   
                    for key in keys{
                       
                      periodos.append(key, EvolucionFinanciamientoResultado(evolAnyObject: j[key]))
                    }
                }
            }
           
        }


}






struct EvolucionFinanciamientoResultado {
   
      var meses: [Consulta]=[]
    init(evolAnyObject: AnyObject?){
        meses = []
        let jsonArray: NSArray = (evolAnyObject as? NSArray)!
        for j in jsonArray{
            if let jsonResult = j as? NSDictionary {
                let keys = (j.allKeys as! [String]).sorted(<)
                
                for key in keys{
                    if key == "mes_int"{
                        var strAcc: String = (j["acciones"] as? String)!
                        let strMonto: String = (j["monto"] as? String)!
                        var intAcciones: Int64
                        var doubleMonto: Double
                        let nsStringMonto = NSString(string: strMonto)
                        strAcc = strAcc.stringByReplacingOccurrencesOfString("Optional(", withString: "")
                        strAcc = strAcc.stringByReplacingOccurrencesOfString(")", withString: "")
                        intAcciones = Int64(strAcc.toInt()!)
                        doubleMonto = Double(nsStringMonto.doubleValue)
                        var consultas: Consulta = Consulta()
                        consultas.acciones=intAcciones
                        consultas.monto=doubleMonto
                        meses.append(consultas)
                    }
                }
            }
        
        }
        
    }
}

