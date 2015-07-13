

import UIKit

class ReporteGeneralViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    
    var opt=["Nacional","Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Coahuila", "Colima", "Chiapas" , "Chihuahua", "Distrito Federal", "Durango", "Guanajuato", "Guerrero","Hidalgo", "Jalisco",
        "México", "Michoacán", "Morelos", "Nayarit", "Nuevo León" , "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas"]
    
    @IBOutlet weak var txtIndicador: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtFinanMto: UILabel!
    @IBOutlet weak var txtFinanAcc: UILabel!
    @IBOutlet weak var txtSubAcc: UILabel!
    @IBOutlet weak var txtSubMto: UILabel!
    @IBOutlet weak var txtInvMto: UILabel!
    @IBOutlet weak var txtInvAcc: UILabel!
    var rowSelected=0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtIndicador.text=opt[rowSelected]
        txtIndicador.enabled=false
        var parseSoap = ParseSoap()
        parseSoap.getDatosReporte() { (responseObject:[ReporteGeneralPrueba]?, error:NSError?) in
            if (error) != nil {
                println("Error obteniendo datos")
                return
            }
            
            println(responseObject!.count)
            var datos = DatosReporteGeneral(datos: responseObject!)
            var result = datos.consultaNacional()
            println(result.accFinan)
            println(result.mtoFinan)
            println(result.accSubs)
            println(result.mtoSubs)
            println(result.vv)
            println(result.vr)
            
            var entidad = datos.consultaEntidad(.DF)
            println("\n\(entidad.accFinan)")
            println(entidad.mtoFinan)
            println(entidad.accSubs)
            println(entidad.mtoSubs)
            println(entidad.vv)
            println(entidad.vr)
            
        }
        
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return opt.count
 
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
       
        return opt[row]
        
    }
    
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = opt[row]
        txtIndicador.text = itemSelected
    
    //Insertar Funcion
    
   
    
    }
    
}
