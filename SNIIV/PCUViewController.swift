//
//  PCUViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class PCUViewController: BaseUIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtTitlePCU: UITextField!
    @IBOutlet weak var txtU1: UILabel!
    @IBOutlet weak var TXTu2: UILabel!
    @IBOutlet weak var txtU3: UILabel!
    @IBOutlet weak var txtFC: UILabel!
    @IBOutlet weak var txtND: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    
    var entidad: PCU?
    var datos: DatosPCU?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitlePCU.enabled=false
        picker.userInteractionEnabled = false
        
        activarIndicador()
        
        if (!TableViewController.isDateLoaded || !isDataLoaded()) && Reachability.isConnectedToNetwork() {
            var parsePCU = ParsePCU<[PCU]>()
            parsePCU.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [PCU], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        PCURepository.deleteAll()
        PCURepository.saveAll(responseObject)
        
        datos = DatosPCU(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        TimeLastUpdatedRepository.saveLastTimeUpdated(getKey())
        
        loadFechasStorage()
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
    }
    
    override func loadFromStorage() {
        println("PCU loadFromStorage")
        let datosStorage = PCURepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosPCU(datos: datosStorage)
            entidad = datos?.consultaNacional()
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
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
        
        mostrarDatos()
    }
    
    override func mostrarDatos() {
        if entidad != nil {
            txtU1.text = Utils.toString(entidad!.u1)
            TXTu2.text = Utils.toString(entidad!.u2)
            txtU3.text = Utils.toString(entidad!.u3)
            txtFC.text = Utils.toString(entidad!.fc)
            txtND.text = Utils.toString(entidad!.nd)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
        txtTitlePCU.text = "PCU \(fechas.fecha_vv)"
    }
    
    override func getKey() -> String {
        return PCURepository.TABLA
    }
}
