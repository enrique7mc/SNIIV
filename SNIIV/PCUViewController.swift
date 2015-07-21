//
//  PCUViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class PCUViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
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
