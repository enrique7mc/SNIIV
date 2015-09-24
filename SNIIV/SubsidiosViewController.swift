import UIKit

class SubsidiosViewController: UIViewController {
    
    @IBOutlet weak var nuevaAcc: UILabel!
    @IBOutlet weak var nuevaMto: UILabel!
    @IBOutlet weak var usadaAcc: UILabel!
    @IBOutlet weak var usadaMto: UILabel!
    @IBOutlet weak var autoAcc: UILabel!
    @IBOutlet weak var autoMto: UILabel!
    @IBOutlet weak var mejoAcc: UILabel!
    @IBOutlet weak var mejoMto: UILabel!
    @IBOutlet weak var loteAcc: UILabel!
    @IBOutlet weak var loteMto: UILabel!
    @IBOutlet weak var otrosAcc: UILabel!
    @IBOutlet weak var otrosMto: UILabel!
    @IBOutlet weak var totalAcc: UILabel!
    @IBOutlet weak var totalMto: UILabel!
    
    @IBOutlet weak var txtTitle: UILabel!
    
    var pValuesMto:[Double]=[]
    var pValuesAcc:[Int64]=[]
    var pTitle: String=""
    var pEstado: Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
        
    }
    
    func populateData(){
        
        txtTitle.text=pTitle
        var sumaAcc: Int64=0
        var sumaMto: Double=0

        nuevaAcc.text=Utils.toStringDivide(Double(pValuesAcc[0]), divide: 1000)
        usadaAcc.text=Utils.toStringDivide(Double(pValuesAcc[1]), divide: 1000)
        autoAcc.text=Utils.toStringDivide(Double(pValuesAcc[2]), divide: 1000)
        mejoAcc.text=Utils.toStringDivide(Double(pValuesAcc[3]), divide: 1000)
        loteAcc.text=Utils.toStringDivide(Double(pValuesAcc[4]), divide: 1000)
        otrosAcc.text=Utils.toStringDivide(Double(pValuesAcc[5]), divide: 1000)
        
        
        nuevaMto.text=Utils.toStringDivide(pValuesMto[0], divide: 1000000)
        usadaMto.text=Utils.toStringDivide(pValuesMto[1], divide: 1000000)
        autoMto.text=Utils.toStringDivide(pValuesMto[2], divide: 1000000)
        mejoMto.text=Utils.toStringDivide(pValuesMto[3], divide: 1000000)
        loteMto.text=Utils.toStringDivide(pValuesMto[4], divide: 1000000)
        otrosMto.text=Utils.toStringDivide(pValuesMto[5], divide: 1000000)
        
        for a in pValuesAcc{
            sumaAcc=sumaAcc+a
        }
        
        for a in pValuesMto{
            sumaMto=sumaMto+a
        }
        
        totalAcc.text=Utils.toStringDivide(Double(sumaAcc), divide: 1000)
        totalMto.text=Utils.toStringDivide(sumaMto, divide: 1000000)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pinching(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
       
    @IBAction func swiping(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
}
