import Foundation
import SWXMLHash

class ParseEvolucionRegistroVivienda<T>: ParseBase<Evolucion2> {
    
    var aux: [String] = []
    
    init(){
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_regviv_evol_acum")
    }
    
    func saveFile(datastring: NSString){
        print("SAVED init ")

        let file = "jsonReg.txt"

        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            let text = datastring
            
            
            do {
                try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch _ {
            };
           
        }
        
        print("SAVED final ")
        
    }
    
    
    
    
    
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void{
        
        var estados = [String, EvolucionFinanciamiento2]()
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200{
            print("ParseEvolucionRegistroVivienda status code: \(httpResponse.statusCode)")
            self.serviceResponse!(Evolucion2(), NSError())
        }
        else{
            if let dataString=NSString(data: data, encoding: NSUTF8StringEncoding){
                self.xmlResponse = dataString as String
                var xml=SWXMLHash.parse(self.xmlResponse)
                var evol = xml["soap:Envelope"]["soap:Body"]["get_regviv_evol_acumResponse"]["get_regviv_evol_acumResult"]
                let jsonString = Utils.getText(evol)
                
                let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
                
                var datastring = NSString(data: data, encoding: UInt())
                saveFile(datastring!)
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                if let item = jsonResult{
                    print("jsonresult")
                    let keys = (jsonResult!.allKeys as! [String]).sorted(<)
                    
                    for key in keys{
                        estados.append(key, EvolucionFinanciamiento2(evolAnyObject: item[key]!))
                        
                    }
                    var evo =  Evolucion2(test: estados)
                    self.serviceResponse!(evo, nil)
                    
                }
                
                
            }
            
            
        }
        
    }
    
}




struct Evolucion2 {
    var pEstados = [String, EvolucionFinanciamiento2]()
    init(test: [(String, EvolucionFinanciamiento2)]){
        pEstados = test
    }
    init(){
        pEstados = []
    }
}


struct EvolucionFinanciamiento2 {
    var periodos = [String, EvolucionFinanciamientoResultado2]()
    
    init(evolAnyObject: AnyObject){
        let jsonArray: NSArray = (evolAnyObject as? NSArray)!
        for j in jsonArray{
            if let jsonResult = j as? NSDictionary {
                let keys = (j.allKeys as! [String]).sort(<)
                
                for key in keys{
                    
                    periodos.append(key, EvolucionFinanciamientoResultado2(evolAnyObject: j[key]))
                }
            }
        }
        
    }
    
    init(){
        
    }
    
}






struct EvolucionFinanciamientoResultado2 {
    
    var meses: [Consulta]=[]
    init(evolAnyObject: AnyObject?){
        meses = []
        let jsonArray: NSArray = (evolAnyObject as? NSArray)!
        for j in jsonArray{
            if let jsonResult = j as? NSDictionary {
                let keys = (j.allKeys as! [String]).sort(<)
                
                for key in keys{
                    if key == "mes_int"{
                        var strReg: String = (j["num_viv_reg"] as? String)!
                        var intReg: Int64 = 0
                        strReg = strReg.stringByReplacingOccurrencesOfString("Optional(", withString: "", options: [], range: nil)
                        strReg = strReg.stringByReplacingOccurrencesOfString(")", withString: "", options: [], range: nil)
                        intReg = Int64(Int(strReg)!)
                        var consultas: Consulta = Consulta()
                        consultas.acciones=intReg
                        meses.append(consultas)
                    }
                }
            }
            
        }
        
    }
}
