//
//  DemandaSubsidiosViewController.swift
//  SNIIV
//
//  Created by SAP1 on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class DemandaSubsidiosViewController: BaseUIViewController {

    @IBOutlet weak var txtTitleSubsidios: UITextField!
    @IBOutlet weak var txtNuevaAcc: UILabel!
    @IBOutlet weak var txtNuevaMto: UILabel!
    @IBOutlet weak var txtUsadaAcc: UILabel!
    @IBOutlet weak var txtUsadaMto: UILabel!
    @IBOutlet weak var txtAutoproduccionMto: UILabel!
    @IBOutlet weak var txtAutoproduccionAcc: UILabel!
    @IBOutlet weak var txtMejoramientoAcc: UILabel!
    @IBOutlet weak var txtMejoramientoMto: UILabel!
    @IBOutlet weak var txtLoteAcc: UILabel!
    @IBOutlet weak var txtLoteMto: UILabel!
    @IBOutlet weak var txtOtroAcc: UILabel!
    @IBOutlet weak var txtOtroMto: UILabel!
    @IBOutlet weak var txtTotalAcc: UILabel!
    @IBOutlet weak var txtTotalMto: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var consulta: ConsultaSubsidio?
    var datos: DatosSubsidios?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleSubsidios.enabled=false;
        picker.userInteractionEnabled = false
        
        activarIndicador()
        
        if (!TableViewController.isDateLoaded || !isDataLoaded()) && Reachability.isConnectedToNetwork() {            
            var parseSubsidios = ParseSubsidios<[Subsidio]>()
            parseSubsidios.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [Subsidio], error: NSError?) -> Void {
        if error != nil {
            println("Subsidio error obteniendo datos")
            return
        }
        
        SubsidioRepository.deleteAll()
        SubsidioRepository.saveAll(responseObject)
        
        datos = DatosSubsidios()
        consulta = datos!.consultaNacional()
        
        TimeLastUpdatedRepository.saveLastTimeUpdated(getKey())
        
        loadFechasStorage()
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
    }
    
    override func loadFromStorage() {
        println("Subsidio loadFromStorage")
        let datosStorage = SubsidioRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosSubsidios()
            consulta = datos?.consultaNacional()
            
            picker.userInteractionEnabled = true
        } else {
            muestraMensajeError()
        }
        
        loadFechasStorage()
        
        habilitarPantalla()
    }
    
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
        if row == 0 {
            consulta = datos!.consultaNacional()
        } else {
            consulta = datos!.consultaEntidad(Entidad(rawValue: row)!)
        }
        
        mostrarDatos()
    }
    
    override func mostrarDatos() {
        if consulta != nil {
            txtNuevaMto.text = Utils.toStringDivide(consulta!.nueva.monto, divide: 1000000)
            txtNuevaAcc.text = Utils.toString(consulta!.nueva.acciones)
            
            txtUsadaMto.text = Utils.toStringDivide(consulta!.usada.monto, divide: 1000000)
            txtUsadaAcc.text = Utils.toString(consulta!.usada.acciones)
            
            txtAutoproduccionMto.text = Utils.toStringDivide(consulta!.autoproduccion.monto, divide: 1000000)
            txtAutoproduccionAcc.text = Utils.toString(consulta!.autoproduccion.acciones)
            
            txtMejoramientoMto.text = Utils.toStringDivide(consulta!.mejoramiento.monto, divide: 1000000)
            txtMejoramientoAcc.text = Utils.toString(consulta!.mejoramiento.acciones)
            
            txtLoteMto.text = Utils.toStringDivide(consulta!.lotes.monto, divide: 1000000)
            txtLoteAcc.text = Utils.toString(consulta!.lotes.acciones)
            
            txtOtroMto.text = Utils.toStringDivide(consulta!.otros.monto, divide: 1000000)
            txtOtroAcc.text = Utils.toString(consulta!.otros.acciones)
            
            
            txtTotalMto.text = Utils.toStringDivide(consulta!.total.monto, divide: 1000000)
            txtTotalAcc.text = Utils.toString(consulta!.total.acciones)
        }
        
        txtTitleSubsidios.text = "Subsidios \(fechas.fecha_subs)"
    }
    
    override func getKey() -> String {
        return SubsidioRepository.TABLA
    }
}
