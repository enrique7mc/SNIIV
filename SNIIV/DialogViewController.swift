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

    var aux:Int=0;

    var arrayLabel:[UILabel]=[]
    var arrayValues:[UILabel]=[]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateArrays()
        populateLabels()
        
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
