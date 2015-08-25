//
//  TipoViviendaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class TipoViviendaViewController: BaseUIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtTitleTipoVivienda: UITextField!
    @IBOutlet weak var txtHorizontal: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var txtVetical: UILabel!
    
    var entidad: TipoVivienda?
    var datos: DatosTipoVivienda?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleTipoVivienda.enabled=false
        picker.userInteractionEnabled = false

        activarIndicador()
        
        if (!TableViewController.isDateLoaded || !isDataLoaded()) && Reachability.isConnectedToNetwork() {            
            var parseTipo = ParseTipoVivienda<[TipoVivienda]>()
            parseTipo.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [TipoVivienda], error: NSError?) -> Void {
        if error != nil {
            println("TipoVivienda error obteniendo datos")
            return
        }
        
        TipoViviendaRepository.deleteAll()
        TipoViviendaRepository.saveAll(responseObject)
        
        datos = DatosTipoVivienda(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        TimeLastUpdatedRepository.saveLastTimeUpdated(getKey())
        
        loadFechasStorage()
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
    }
    
    override func loadFromStorage() {
        println("TipoVivienda loadFromStorage")
        let datosStorage = TipoViviendaRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosTipoVivienda(datos: datosStorage)
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
            txtHorizontal.text = Utils.toString(entidad!.horizontal)
            txtVetical.text = Utils.toString(entidad!.vertical)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
        txtTitleTipoVivienda.text = "Tipo de la Vivienda \(Utils.formatoMes(fechas.fecha_vv))"
    }
    
    override func getKey() -> String {
        return TipoViviendaRepository.TABLA
    }
}
