//
//  DemandaSubsidiosViewController.swift
//  SNIIV
//
//  Created by SAP1 on 27/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class DemandaSubsidiosViewController: BaseUIViewController {

    @IBOutlet weak var txtTitleSubsidios: UITextField!
    @IBOutlet weak var txtNuevaAcc: UILabel!
    @IBOutlet weak var txtNuevaMto: UILabel!
    @IBOutlet weak var txtUsadaAcc: UILabel!
    @IBOutlet weak var txtUsadaMto: UILabel!
    @IBOutlet weak var txtAutoproduccionMto: UILabel!
    @IBOutlet weak var txtAutoproduccionAcc: UILabel!
    @IBOutlet weak var txtMejoramientoAcc: UILabel!
    @IBOutlet weak var txtMejoramientoMto: UILabel!
    @IBOutlet weak var txtLoteAcc: UILabel!
    @IBOutlet weak var txtLoteMto: UILabel!
    @IBOutlet weak var txtOtroAcc: UILabel!
    @IBOutlet weak var txtOtroMto: UILabel!
    @IBOutlet weak var txtTotalAcc: UILabel!
    @IBOutlet weak var txtTotalMto: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleSubsidios.enabled=false
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
