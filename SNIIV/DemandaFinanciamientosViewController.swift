//
//  DemandaFinanciamientosViewController.swift
//  SNIIV
//
//  Created by SAP1 on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class DemandaFinanciamientosViewController: BaseUIViewController {
    @IBOutlet weak var picker: UIPickerView!
    

    @IBOutlet weak var txtNuevasSubsidiosMto: UILabel!
    @IBOutlet weak var txtNuevasSubsidiosAcc: UILabel!
    @IBOutlet weak var txtNuevasCreditoAcc: UILabel!
    @IBOutlet weak var txtNuevasCreditoMto: UILabel!
    
    @IBOutlet weak var txtTitleFinanciamientos: UINavigationItem!
    @IBOutlet weak var txtUsadasSubsidiosAcc: UILabel!
    @IBOutlet weak var txtUsadasSubsidiosMto: UILabel!
    @IBOutlet weak var txtUsadasCreditoMto: UILabel!
    @IBOutlet weak var txtUsadasCreditoAcc: UILabel!
    
    @IBOutlet weak var txtMejoramientoSubsidiosMto: UILabel!
    @IBOutlet weak var txtMejoramientoCreditoAcc: UILabel!
    @IBOutlet weak var txtMejoramientoCreditoMto: UILabel!
    @IBOutlet weak var txtMejoramientoSubsidiosAcc: UILabel!
    
    @IBOutlet weak var txtTitle: UINavigationItem!
    @IBOutlet weak var txtOtrosCreditoAcc: UILabel!
    @IBOutlet weak var txtOtrosCreditoMto: UILabel!
    
    @IBOutlet weak var txtTotalAcc: UILabel!
    @IBOutlet weak var txtTotalMto: UILabel!
    
    var consulta: ConsultaFinanciamiento?
    var datos: DatosFinanciamiento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        picker.userInteractionEnabled = false
        self.tabBarController?.navigationItem.title="Financiamientos"
        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {            
            var parseFinanciamientos = ParseFinanciamientos<[Financiamiento]>()
            parseFinanciamientos.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [Financiamiento], error: NSError?) -> Void {
        if error != nil {
            println("Financiamiento error obteniendo datos")
            return
        }
        
        FinanciamientoRepository.deleteAll()
        FinanciamientoRepository.saveAll(responseObject)
        
        datos = DatosFinanciamiento()
        consulta = datos!.consultaNacional()
        
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
        println("Financiamiento loadFromStorage")
        let datosStorage = FinanciamientoRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosFinanciamiento()
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
            txtNuevasSubsidiosMto.text = Utils.toStringDivide(consulta!.viviendasNuevas.cofinanciamiento.monto, divide: 1000000)
            txtNuevasSubsidiosAcc.text = Utils.toString(consulta!.viviendasNuevas.cofinanciamiento.acciones)
            txtNuevasCreditoMto.text = Utils.toStringDivide(consulta!.viviendasNuevas.creditoIndividual.monto, divide: 1000000)
            txtNuevasCreditoAcc.text = Utils.toString(consulta!.viviendasNuevas.creditoIndividual.acciones)
            
            txtUsadasSubsidiosMto.text = Utils.toStringDivide(consulta!.viviendasUsadas.cofinanciamiento.monto, divide: 1000000)
            txtUsadasSubsidiosAcc.text = Utils.toString(consulta!.viviendasUsadas.cofinanciamiento.acciones)
            txtUsadasCreditoMto.text = Utils.toStringDivide(consulta!.viviendasUsadas.creditoIndividual.monto, divide: 1000000)
            txtUsadasCreditoAcc.text = Utils.toString(consulta!.viviendasUsadas.creditoIndividual.acciones)
            
            txtMejoramientoSubsidiosMto.text = Utils.toStringDivide(consulta!.mejoramientos.cofinanciamiento.monto, divide: 1000000)
            txtMejoramientoSubsidiosAcc.text = Utils.toString(consulta!.mejoramientos.cofinanciamiento.acciones)
            txtMejoramientoCreditoMto.text = Utils.toStringDivide(consulta!.mejoramientos.creditoIndividual.monto, divide: 1000000)
            txtMejoramientoCreditoAcc.text = Utils.toString(consulta!.mejoramientos.creditoIndividual.acciones)
            
            txtOtrosCreditoMto.text = Utils.toStringDivide(consulta!.otrosProgramas.creditoIndividual.monto, divide: 1000000)
            txtOtrosCreditoAcc.text = Utils.toString(consulta!.otrosProgramas.creditoIndividual.acciones)
            
            txtTotalMto.text = Utils.toStringDivide(consulta!.total.monto, divide: 1000000)
            txtTotalAcc.text = Utils.toString(consulta!.total.acciones)
        }
        
       /* txtTitleFinanciamientos.title = "Financiamientos \(Utils.formatoDiaMes(fechas.fecha_finan))"*/
        
        self.tabBarController?.navigationItem.title="Financiamientos \(Utils.formatoDiaMes(fechas.fecha_finan))"
    }
    
    override func getKey() -> String {
        return FinanciamientoRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_finan
    }
}
