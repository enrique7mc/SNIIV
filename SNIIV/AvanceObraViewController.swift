//
//  AvanceObraViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class AvanceObraViewController: BaseUIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtCincuentaPorciento: UILabel!
    @IBOutlet weak var txtNoventaPorciento: UILabel!
    @IBOutlet weak var txtRecientes: UILabel!
    @IBOutlet weak var txtAntiguas: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    
    var entidad: AvanceObra?
    var datos: DatosAvanceObra?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.userInteractionEnabled = false
        self.tabBarController?.navigationItem.title="Avance de Obra"
        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {
            var parseAvance = ParseAvanceObra<[AvanceObra]>()
            parseAvance.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [AvanceObra], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        AvanceObraRepository.deleteAll()
        AvanceObraRepository.saveAll(responseObject)
        
        datos = DatosAvanceObra(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        if let ultimaFecha = getFechaActualizacion() {
            TimeLastUpdatedRepository.saveLastTimeUpdated(getKey(), fecha: ultimaFecha)
        }
        
        loadFechasStorage()
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
    }
    
    override func loadFromStorage() {
        println("AvanceObra loadFromStorage")
        let datosStorage = AvanceObraRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosAvanceObra(datos: datosStorage)
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
            txtCincuentaPorciento.text = Utils.toString(entidad!.viv_proc_m50)
            txtNoventaPorciento.text = Utils.toString(entidad!.viv_proc_50_99)
            txtRecientes.text = Utils.toString(entidad!.viv_term_rec)
            txtAntiguas.text = Utils.toString(entidad!.viv_term_ant)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
         self.tabBarController?.navigationItem.title="Avance de Obra \(Utils.formatoMes(fechas.fecha_vv))"
        
    }
    
    override func getKey() -> String {
        return AvanceObraRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_vv
    }
}
