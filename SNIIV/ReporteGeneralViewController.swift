

import UIKit

class ReporteGeneralViewController: BaseUIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtFinanMto: UILabel!
    @IBOutlet weak var txtFinanAcc: UILabel!
    @IBOutlet weak var txtSubAcc: UILabel!
    @IBOutlet weak var txtSubMto: UILabel!
    @IBOutlet weak var txtViviendasVigentes: UILabel!
    @IBOutlet weak var txtViviendasRegistradas: UILabel!
    @IBOutlet weak var labelFinanciamiento: UITextField!
    @IBOutlet weak var labelSubsidios: UITextField!
    @IBOutlet weak var labelVivienda: UITextField!
    
    @IBOutlet weak var txtTitleOferta: UITextField!
    @IBOutlet weak var txtTitleSub: UITextField!
    @IBOutlet weak var txtTitleFinan: UITextField!
    
    var rowSelected = 0
    var entidad: ReporteGeneralPrueba?
    var datos: DatosReporteGeneral?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleOferta.enabled = false
        txtTitleFinan.enabled = false
        txtTitleSub.enabled = false
        picker.userInteractionEnabled = false
        
        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechas<Fechas?>()
            parseFechas.getDatos(handlerFechas)
            var parseReporte = ParseReporteGeneral<[ReporteGeneralPrueba]>()
            parseReporte.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [ReporteGeneralPrueba], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        ReporteGeneralRepository.deleteAll()
        ReporteGeneralRepository.saveAll(responseObject)
        
        datos = DatosReporteGeneral(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        TimeLastUpdatedRepository.saveLastTimeUpdated(getKey())
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
    }
    
    func loadFromStorage() {
        let datosStorage = ReporteGeneralRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosReporteGeneral(datos: datosStorage)
            entidad = datos?.consultaNacional()
            picker.userInteractionEnabled = true
        } else {
            muestraMensajeError()
        }
        
        let fechasStorage = FechasRepository.selectFechas()
        if fechasStorage != nil {
            fechas = fechasStorage!
        } else {
            println("no hay fechas en local storage")
        }
        
        habilitarPantalla()
    }
    
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
    
        if row == 0 {
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
    
        mostrarDatos()
    }
    
    override func mostrarDatos() {
        if entidad != nil {
            txtFinanAcc.text = Utils.toStringDivide(entidad!.accFinan)
            txtFinanMto.text = Utils.toStringDivide(entidad!.mtoFinan, divide: 1000000)
            txtSubAcc.text = Utils.toStringDivide(entidad!.accSubs)
            txtSubMto.text = Utils.toStringDivide(entidad!.mtoSubs, divide: 1000000)
            txtViviendasVigentes.text = Utils.toStringDivide(entidad!.vv)
            txtViviendasRegistradas.text = Utils.toStringDivide(entidad!.vr)
        }
        
        labelFinanciamiento.text = "Financiamientos \(fechas.fecha_finan)"
        labelSubsidios.text = "Subsidios \(fechas.fecha_subs)"
        labelVivienda.text = "Oferta de Vivienda \(fechas.fecha_vv)"
    }
    
    override func getKey() -> String {
        return ReporteGeneralRepository.TABLA
    }
}
