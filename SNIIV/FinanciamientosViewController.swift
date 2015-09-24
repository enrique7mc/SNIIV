import UIKit

class FinanciamientosViewController: UIViewController {
    
    @IBOutlet weak var csVNAcc: UILabel!
    @IBOutlet weak var csVNMto: UILabel!
    @IBOutlet weak var ciVNAcc: UILabel!
    @IBOutlet weak var ciVNMto: UILabel!
    @IBOutlet weak var csVUAcc: UILabel!
    @IBOutlet weak var csVUMto: UILabel!
    @IBOutlet weak var ciVUAcc: UILabel!
    @IBOutlet weak var ciVUMto: UILabel!
    @IBOutlet weak var csMEJAcc: UILabel!
    @IBOutlet weak var csMEJMto: UILabel!
    @IBOutlet weak var ciMEJAcc: UILabel!
    @IBOutlet weak var ciMEJMto: UILabel!
    @IBOutlet weak var ciOTROSAcc: UILabel!
    @IBOutlet weak var ciOTROSMto: UILabel!
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
        
        csVNAcc.text=Utils.toStringDivide(Double(pValuesAcc[0]), divide: 1000)
        ciVNAcc.text=Utils.toStringDivide(Double(pValuesAcc[1]), divide: 1000)
        csVUAcc.text=Utils.toStringDivide(Double(pValuesAcc[2]), divide: 1000)
        ciVUAcc.text=Utils.toStringDivide(Double(pValuesAcc[3]), divide: 1000)
        csMEJAcc.text=Utils.toStringDivide(Double(pValuesAcc[4]), divide: 1000)
        ciMEJAcc.text=Utils.toStringDivide(Double(pValuesAcc[5]), divide: 1000)
        ciOTROSAcc.text=Utils.toStringDivide(Double(pValuesAcc[6]), divide: 1000)
        
        
        csVNMto.text=Utils.toStringDivide(pValuesMto[0], divide: 1000000)
        ciVNMto.text=Utils.toStringDivide(pValuesMto[1], divide: 1000000)
        csVUMto.text=Utils.toStringDivide(pValuesMto[2], divide: 1000000)
        ciVUMto.text=Utils.toStringDivide(pValuesMto[3], divide: 1000000)
        csMEJMto.text=Utils.toStringDivide(pValuesMto[4], divide: 1000000)
        ciMEJMto.text=Utils.toStringDivide(pValuesMto[5], divide: 1000000)
        ciOTROSMto.text=Utils.toStringDivide(pValuesMto[6], divide: 1000000)
        
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
       
    }
    
    @IBAction func pinching(sender: UIPinchGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func swiping(sender: UIPanGestureRecognizer) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }

}
