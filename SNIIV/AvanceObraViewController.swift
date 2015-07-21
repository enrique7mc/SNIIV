//
//  AvanceObraViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class AvanceObraViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtTitleObra: UITextField!
    @IBOutlet weak var txtCincuentaPorciento: UILabel!
    @IBOutlet weak var txtNoventaPorciento: UILabel!
    @IBOutlet weak var txtRecientes: UILabel!
    @IBOutlet weak var txtAntiguas: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    
    var entidad: AvanceObra?
    var datos: DatosAvanceObra?
    var fechas: Fechas = Fechas()
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleObra.enabled=false
        indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        picker.userInteractionEnabled = false
        indicator.startAnimating()
        
        if Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechas<Fechas>()
            parseFechas.getDatos(handlerFechas)
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
        
        datos = DatosAvanceObra(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        CRUDAvanceObra.delete()
        for d in datos!.datos {
            CRUDAvanceObra.save(d)
        }
        
        picker.userInteractionEnabled = true
    }
    
    func handlerFechas (responseObject: Fechas, error: NSError?) {
        if error != nil {
            println("Error obteniendo fechas")
            return
        }
        
        CRUDFechas.deleteFechas()
        
        fechas = responseObject
        CRUDFechas.saveFechas(fechas)
    }
    
    func loadFromStorage() {
        println("AvanceObra loadFromStorage")
        let datosStorage = CRUDAvanceObra.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosAvanceObra(datos: datosStorage)
            entidad = datos?.consultaNacional()
            picker.userInteractionEnabled = true
        } else {
            println("no hay datos en local storage")
        }
        
        let fechasStorage = CRUDFechas.selectFechas()
        if fechasStorage != nil {
            fechas = fechasStorage!
        } else {
            println("no hay fechas en local storage")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mostrarDatos()
        indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Utils.entidades.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Utils.entidades[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
        
        if row == 0 {
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
        
        mostrarDatos()
    }
    
    func mostrarDatos() {
        if entidad != nil {
            txtCincuentaPorciento.text = Utils.toString(entidad!.viv_proc_m50)
            txtNoventaPorciento.text = Utils.toString(entidad!.viv_proc_50_99)
            txtRecientes.text = Utils.toString(entidad!.viv_term_rec)
            txtAntiguas.text = Utils.toString(entidad!.viv_term_ant)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
        txtTitleObra.text = "Avance Obra \(fechas.fecha_finan)"
        
    }

}
