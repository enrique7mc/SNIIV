//
//  ValorViviendaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class ValorViviendaViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{
 
    
    @IBOutlet weak var txtTitleValorVivienda: UITextField!
    @IBOutlet weak var txtEconomica: UILabel!
    @IBOutlet weak var txtPopular: UILabel!
    @IBOutlet weak var txtTradicional: UILabel!
    @IBOutlet weak var txtMediaResidencial: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleValorVivienda.enabled=false
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
        return Utils.entidades.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Utils.entidades[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
        println(itemSelected)
        
    }

}
