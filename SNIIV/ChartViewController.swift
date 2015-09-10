import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {

    var parties: [String] = []
    var values: [Int64] = []
    var dValues:[Double] = []
    var titulo:String? = ""
    var estado:String? = ""
    @IBOutlet weak var pieBarChart: PieChartView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadChart()
        
        dValues=values.map{ r in Double(r) }
        
        pieBarChart.delegate = self
        setChart(parties, pValues: dValues)
    }
    
    func loadChart(){
        pieBarChart.rotationAngle=0.0
        pieBarChart.animate(xAxisDuration: 1.5, easingOption: ChartEasingOption.EaseInOutQuad)
        pieBarChart.usePercentValuesEnabled=true
        pieBarChart.descriptionText="Comisión Nacional De Vivienda"
        pieBarChart.holeTransparent=true
        pieBarChart.transparentCircleRadiusPercent=0.61
        pieBarChart.holeRadiusPercent = 0.58
        pieBarChart.drawCenterTextEnabled = true
        pieBarChart.drawHoleEnabled=true
        pieBarChart.rotationAngle = 0.0
        pieBarChart.rotationEnabled = false
        pieBarChart.centerText=titulo!+"\n"+estado!
        pieBarChart.dragDecelerationEnabled=true
    
        var l: ChartLegend = pieBarChart.legend
        l.position=ChartLegend.ChartLegendPosition.RightOfChart
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
    
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        println("\(entry.value) in \(parties[entry.xIndex])")
        var aux: Int=0
        aux = Int(entry.value)
        pieBarChart.centerText = titulo! + "\n" + estado! + "\n\(aux) \(parties[entry.xIndex])"

        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase){
        pieBarChart.centerText = titulo! + "\n" + estado!
    }
    
    func setChart(dataPoints: [String], pValues: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: pValues[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Porcentaje")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieBarChart.data = pieChartData
        
        
        pieChartDataSet.colors = ColorTemplate.CONAVI_COLORS()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
  }
