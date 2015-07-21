//
//  PCUViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class PCUViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var opt = ["Nacional","Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Coahuila", "Colima", "Chiapas" , "Chihuahua", "Distrito Federal", "Durango", "Guanajuato", "Guerrero","Hidalgo", "Jalisco",
        "México", "Michoacán", "Morelos", "Nayarit", "Nuevo León" , "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas"]
    
    @IBOutlet weak var txtTitlePCU: UITextField!
    @IBOutlet weak var txtU1: UILabel!
    @IBOutlet weak var TXTu2: UILabel!
    @IBOutlet weak var txtU3: UILabel!
    @IBOutlet weak var txtFC: UILabel!
    @IBOutlet weak var txtND: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitlePCU.enabled=false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        println(itemSelected)
        
    }

}
