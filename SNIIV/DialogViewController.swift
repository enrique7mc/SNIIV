//
//  DialogViewController.swift
//  SNIIV
//
//  Created by SAP1 on 9/10/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    var pStrings:[String]=[]
    var pValues:[Int64]=[]
    var pTitle:String=""
    var pEstado:Int=0
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p5: UILabel!
    @IBOutlet weak var p6: UILabel!
    
    @IBOutlet weak var v1: UILabel!
    @IBOutlet weak var v2: UILabel!
    @IBOutlet weak var v3: UILabel!
    @IBOutlet weak var v4: UILabel!
    @IBOutlet weak var v5: UILabel!
    @IBOutlet weak var v6: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    
    @IBOutlet weak var imgEstado: UIImageView!
    var aux:Int=0;

    var arrayLabel:[UILabel]=[]
    var arrayValues:[UILabel]=[]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateArrays()
        populateLabels()
        populateImage()
        
        
        
    }

    @IBAction func pinching(sender: UIPinchGestureRecognizer) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
       
    @IBAction func swiping(sender: UIPanGestureRecognizer) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
    }
    @IBAction func backMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func populateImage(){
        println("estado \(pEstado)")
        switch pEstado {
            case 0:
                imgEstado.image=UIImage(named: "nacional")
            case 1:
                imgEstado.image=UIImage(named: "AGS")
            case 2:
                imgEstado.image=UIImage(named: "BCN")
            case 3:
                imgEstado.image=UIImage(named: "BCS")
            case 4:
                imgEstado.image=UIImage(named: "CAM")
            case 5:
                imgEstado.image=UIImage(named: "COA")
            case 6:
                imgEstado.image=UIImage(named: "COL")
            case 7:
                imgEstado.image=UIImage(named: "CHIS")
            case 8:
                imgEstado.image=UIImage(named: "CHI")
            case 9:
                imgEstado.image=UIImage(named: "DF")
            case 10:
                imgEstado.image=UIImage(named: "DUR")
            case 11:
                imgEstado.image=UIImage(named: "GUA")
            case 12:
                imgEstado.image=UIImage(named: "GUE")
            case 13:
                imgEstado.image=UIImage(named: "HID")
            case 14:
                imgEstado.image=UIImage(named: "JAL")
            case 15:
                imgEstado.image=UIImage(named: "MEX")
            case 16:
                imgEstado.image=UIImage(named: "MICH")
            case 17:
                imgEstado.image=UIImage(named: "MOR")
            case 18:
                imgEstado.image=UIImage(named: "NAY")
            case 19:
                imgEstado.image=UIImage(named: "NL")
            case 20:
                imgEstado.image=UIImage(named: "OAX")
            case 21:
                imgEstado.image=UIImage(named: "PUE")
            case 22:
                imgEstado.image=UIImage(named: "QUE")
            case 23:
                imgEstado.image=UIImage(named: "QROO")
            case 24:
                imgEstado.image=UIImage(named: "SLP")
            case 25:
                imgEstado.image=UIImage(named: "SIN")
            case 26:
                imgEstado.image=UIImage(named: "SON")
            case 27:
                imgEstado.image=UIImage(named: "TAB")
            case 28:
                imgEstado.image=UIImage(named: "TAM")
            case 29:
                imgEstado.image=UIImage(named: "TLAX")
            case 30:
                imgEstado.image=UIImage(named: "VER")
            case 31:
                imgEstado.image=UIImage(named: "YUC")
            case 32:
                imgEstado.image=UIImage(named: "ZAC")
            default:
                imgEstado.image=UIImage(named: "nacional")
           
        }
        
    }
   
    
    func populateArrays(){
        arrayLabel.append(p1)
        arrayLabel.append(p2)
        arrayLabel.append(p3)
        arrayLabel.append(p4)
        arrayLabel.append(p5)
        arrayLabel.append(p6)
        
        arrayValues.append(v1)
        arrayValues.append(v2)
        arrayValues.append(v3)
        arrayValues.append(v4)
        arrayValues.append(v5)
        arrayValues.append(v6)
        

    }
    
    func populateLabels(){
        txtTitle.text=pTitle
        var total:Int64=0
        pStrings.append("Total")
        
        for a in pValues{
            total+=(Int64(a.value))
        }
        
        pValues.append(total)
        
        for a in arrayLabel{
            
            println("aux\(aux)")
            if pStrings.count > aux{
                a.text=pStrings[aux]
                
            }
            else{
                a.text=""
            }
            
            aux+=1
            
            if  a.text == "Total"{
            
            a.textColor=UIColor(red: 0, green: 128/255, blue: 54/255, alpha: 1.0)
            
            }
        }
        aux=0
        
        for a in arrayValues{
            
            println("aux\(aux)")
            if pValues.count > aux{
                
                a.text="\(Utils.decimalFormat(Int(pValues[aux])))"
                
            }
            else{
                a.text=""
            }
            
            aux+=1
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
