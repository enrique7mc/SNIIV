import Foundation
import Charts

class DatosEvolucionFinanciamientos {
   
    func readFile() -> String{
        var text2=""
        let file = "jsonFinan.txt"
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0] //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            text2 = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            
        }
        return text2
        
    }
    
    func readJSON() -> Evolucion{
        print("readJSON")
        var estados = [String, EvolucionFinanciamiento]()
        var evo = Evolucion()
        let data = readFile().dataUsingEncoding(NSUTF8StringEncoding)!
        let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
        if let item = jsonResult{
            
            let keys = (jsonResult!.allKeys as! [String]).sort(<)
            
            for key in keys{
                estados.append(key, EvolucionFinanciamiento(evolAnyObject: item[key]!))
                
            }
            
            evo =  Evolucion(test: estados)
        }
        return evo
    }
    
    func readEvoObject(numEstado: Int, option: Int) -> [[ChartDataEntry]]{
        if option == 0{
            return returnAcciones(numEstado)
        }
        else if option == 1{
            return returnMontos(numEstado)
        }
        
        else {
            return[[]]
        }
        
        
    }
    
    
    func returnAcciones(numEstado: Int) -> [[ChartDataEntry]]{
        var dataEntriesAnios: [[ChartDataEntry]] = []
        let elemento: Evolucion = readJSON()
        
        for var i2 = 0; i2 < elemento.pEstados[numEstado].1.periodos.count; ++i2 {
            var dataEntries: [ChartDataEntry] = []
            for var i3 = 0; i3 < elemento.pEstados[numEstado].1.periodos[i2].1.meses.count; ++i3 {
                var p_acciones = elemento.pEstados[numEstado].1.periodos[i2].1.meses[i3].acciones
                var acciones = Double(p_acciones) / Utils.THOUSAND
                let dataEntry = ChartDataEntry(value:  acciones, xIndex: i3)
                dataEntries.append(dataEntry)
            }
            dataEntriesAnios.append(dataEntries)
        }
        
        return dataEntriesAnios

    }
    
    func returnMontos(numEstado: Int) -> [[ChartDataEntry]]{
        
        var dataEntriesAnios: [[ChartDataEntry]] = []
        let elemento: Evolucion = readJSON()
        
        for var i2 = 0; i2 < elemento.pEstados[numEstado].1.periodos.count; ++i2 {
            var dataEntries: [ChartDataEntry] = []
            for var i3 = 0; i3 < elemento.pEstados[numEstado].1.periodos[i2].1.meses.count; ++i3 {
                var p_montos = elemento.pEstados[numEstado].1.periodos[i2].1.meses[i3].monto
                var montos = Double(p_montos) / Utils.MILLION
                let dataEntry = ChartDataEntry(value:  montos, xIndex: i3)
                dataEntries.append(dataEntry)
            }
            dataEntriesAnios.append(dataEntries)
        }
        
        return dataEntriesAnios
        
    }
    
    
    func getAnios() -> [String]{

        let elemento: Evolucion = readJSON()
        var anios: [String] = []
        for var i2 = 0; i2 < elemento.pEstados[0].1.periodos.count; ++i2 {
           anios.append(elemento.pEstados[0].1.periodos[i2].0)
        }
        
        return anios
    }

  
}

struct ConsultaEvolucionFinanciamiento{
    
           var consulta: Evolucion = Evolucion()
   
}
