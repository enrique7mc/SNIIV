

import UIKit

class ReporteGeneralViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var opt=["Nacional","Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Coahuila", "Colima", "Chiapas" , "Chihuahua", "Distrito Federal", "Durango", "Guanajuato", "Guerrero","Hidalgo", "Jalisco",
        "México", "Michoacán", "Morelos", "Nayarit", "Nuevo León" , "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas"]
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtFinanMto: UILabel!
    @IBOutlet weak var txtFinanAcc: UILabel!
    @IBOutlet weak var txtSubAcc: UILabel!
    @IBOutlet weak var txtSubMto: UILabel!
    @IBOutlet weak var txtViviendasVigentes: UILabel!
    @IBOutlet weak var txtViviendasRegistradas: UILabel!
    var rowSelected = 0;
    var entidad: DatoEntidad?
    var datos: DatosReporteGeneral?
  
  

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
             
        if Reachability.isConnectedToNetwork() {
            var parseSoap = ParseSoap()
            parseSoap.getDatosReporte(handler)
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [ReporteGeneralPrueba]?, error: NSError?) {
        if (error) != nil {
            println("Error obteniendo datos")
            return
        }
        
        datos = DatosReporteGeneral(datos: responseObject!)
        entidad = datos!.consultaNacional()
        
        CRUDReporteGeneral.deleteReporteGeneral()
        for d in datos!.datos {
            CRUDReporteGeneral.saveReporteGeneral(d)
        }
    }
    
    func loadFromStorage() {
        let datosStorage = CRUDReporteGeneral.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosReporteGeneral(datos: datosStorage)
            entidad = datos!.consultaNacional()
        } else {
            println("no hay datos en local storage")
            picker.userInteractionEnabled = false
        }
    }

    override func viewDidAppear(animated: Bool) {
        showData()
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
    
        if row == 0 {
            entidad = datos!.consultaNacional()
        } else {
            entidad = datos!.consultaEntidad(Entidad(rawValue: row)!)
        }
    
        showData()
    }
    
    func showData() {
        txtFinanAcc.text = toString(entidad?.accFinan)
        txtFinanMto.text = toString(entidad?.mtoFinan)
        txtSubAcc.text = toString(entidad?.accSubs)
        txtSubMto.text = toString(entidad?.mtoSubs)
        txtViviendasVigentes.text = toString(entidad?.vv)
        txtViviendasRegistradas.text = toString(entidad?.vr)
    }
    
    func toString(numero: Int64?) -> String {
        if let num = numero {
            return Utils().decimalFormat(num)
        }
        
        return "-"
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 12) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        pickerLabel.text=opt[row]
        return pickerLabel
    }
    
}
