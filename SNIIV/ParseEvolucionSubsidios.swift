import Foundation
import SWXMLHash

class ParseEvolucionSubsidios<T>: ParseBase<Evolucion> {
    
    var aux: [String] = []
    
    init(){
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_subs_evol_acum")
    }
    
    func saveFile(datastring: NSString){
         print("SAVED init ")
        let file = "jsonSubsi.txt"
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            let text = datastring
            text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)

             print("SAVED File")
        }
        
         print("SAVED final ")
        
    }
    
    
    
    
    
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void{
        
        var estados = [String, EvolucionFinanciamiento]()
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200{
            print("ParseEvolucionSubsidios status code: \(httpResponse.statusCode)")
            self.serviceResponse!(Evolucion(), NSError())
        }
        else{
            if let dataString=NSString(data: data, encoding: NSUTF8StringEncoding){
                self.xmlResponse = dataString as String
                var xml=SWXMLHash.parse(self.xmlResponse)
                var evol = xml["soap:Envelope"]["soap:Body"]["get_subs_evol_acumResponse"]["get_subs_evol_acumResult"]
                let jsonString = Utils.getText(evol)
                
                let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
                
                var datastring = NSString(data: data, encoding: UInt())
                saveFile(datastring!)
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                if let item = jsonResult{
                     print("jsonresult")
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