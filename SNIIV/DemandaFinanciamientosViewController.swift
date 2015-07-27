//
//  DemandaFinanciamientosViewController.swift
//  SNIIV
//
//  Created by SAP1 on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class DemandaFinanciamientosViewController: BaseUIViewController {

    @IBOutlet weak var txtTitleFinanciamientos: UITextField!

    @IBOutlet weak var txtNuevasSubsidiosMto: UILabel!
    @IBOutlet weak var txtNuevasSubsidiosAcc: UILabel!
    @IBOutlet weak var txtNuevasCreditoAcc: UILabel!
    @IBOutlet weak var txtNuevasCreditoMto: UILabel!
    
    
    @IBOutlet weak var txtUsadasSubsidiosAcc: UILabel!
    @IBOutlet weak var txtUsadasSubsidiosMto: UILabel!
    @IBOutlet weak var txtUsadasCreditoMto: UILabel!
    @IBOutlet weak var txtUsadasCreditoAcc: UILabel!
    
    
    @IBOutlet weak var txtMejoramientoSubsidiosMto: UILabel!
    @IBOutlet weak var txtMejoramientoCreditoAcc: UILabel!
    @IBOutlet weak var txtMejoramientoCreditoMto: UILabel!
    @IBOutlet weak var txtMejoramientoSubsidiosAcc: UILabel!
    
    
    @IBOutlet weak var txtOtrosCreditoAcc: UILabel!
    @IBOutlet weak var txtOtrosCreditoMto: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleFinanciamientos.enabled=false;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
