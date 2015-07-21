//
//  TipoViviendaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class TipoViviendaViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate {


    
    @IBOutlet weak var txtTitleTipoVivienda: UITextField!
    @IBOutlet weak var txtHorizontal: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var txtVetical: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleTipoVivienda.enabled=false
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
