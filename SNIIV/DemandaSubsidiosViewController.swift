import UIKit
import Charts

class DemandaSubsidiosViewController: BaseUIViewController, UIPopoverPresentationControllerDelegate {


    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var pieChart: PieChartView!
    var entidad: ConsultaSubsidio?
    var datos: DatosSubsidios?
    var parties: [String]=[]
    var values: [Double]=[]
    var totalParties: [String]=[]
    var totalValues: [Int64]=[]
    
    var dValues: [Double]=[]
    var titulo: String? = "Subsidios"
    var estado: String? = ""
    var intEstado:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
        picker.userInteractionEnabled = false
        activarIndicador()
        pieChart.delegate=self
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {
            var parseSubsidios = ParseSubsidios<[Subsidio]>()
            parseSubsidios.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
        getData()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func showData(sender: AnyObject) {
        println("ShowData")
        performSegueWithIdentifier("datosModal", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "datosModal") {
            var svc = segue.destinationViewController as! DialogViewController
            svc.pStrings=parties
            //             svc.pValues=values
            svc.pTitle=titulo!+" ("+getFechaActualizacion()!+")"
            svc.pEstado=intEstado
        }
    }
    
    func initChart(){
        
        pieChart.rotationAngle=0.0
        pieChart.usePercentValuesEnabled=true
        pieChart.descriptionText=""
        pieChart.holeTransparent=true
        pieChart.transparentCircleRadiusPercent=0.50
        pieChart.holeRadiusPercent = 0.50
        pieChart.drawCenterTextEnabled = true
        pieChart.drawHoleEnabled=true
        pieChart.rotationAngle = 0.0
        pieChart.rotationEnabled = false
        pieChart.centerText=titulo!+"\n"+estado!
        pieChart.dragDecelerationEnabled=true
        
        var l: ChartLegend = pieChart.legend
        l.position=ChartLegend.ChartLegendPosition.BelowChartCenter
        l.xEntrySpace = 0.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
        
    }
    
    func setChart(dataPoints: [String], pValues: [Double]) {
        
        pieChart.animate(xAxisDuration: 1.5, easingOption: ChartEasingOption.EaseInOutQuad)
        pieChart.centerText=titulo!+"\n"+estado!
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: pValues[i], xIndex: i)
            dataEntries.append(dataEntry)
            
        }
        
        
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        pieChartDataSet.colors = ColorTemplate.CONAVI_COLORS()
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        pieChart.data = pieChartData
        
        
        
    }
    
    func getData(){
        println("getData")
        var totalValues:Double=0
        var dParcial:Double=0.0
        var dSumParcial:[Double]=[]
        var aux=0
        var tValues:[Double]=[]
        var tParties:[String]=[]
        parties = ["Nueva", "Mejoramiento", "Usada", "Autoproducción", "Lotes c/ Serv", "Otros"]
        values = [  entidad!.nueva.monto,
                    entidad!.mejoramiento.monto,
                    entidad!.usada.monto,
                    entidad!.autoproduccion.monto,
                    entidad!.lotes.monto,
                    entidad!.otros.monto]
        estado = Utils.entidades[intEstado]
        dValues=values.map{ r in Double(r) }
        
        for a in dValues{
            totalValues=totalValues+a
        }
        
        for a in dValues{
            dParcial=(a/totalValues)*100
            dSumParcial.append(dParcial)
        }
        
        
        
        for a in dSumParcial{
            if(a>1/2){
                
                tValues.append(dValues[aux])
                tParties.append(parties[aux])
                
            }
            aux++
        }
        
        dValues=tValues
        parties=tParties
        
        
        
        setChart(parties, pValues: dValues)
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
       

        println("\(entry.value) in \(parties[entry.xIndex])")
        pieChart.centerText = titulo! + "\n" + estado! + "\n\(Utils.toStringDivide(entry.value, divide: 1000000)) MDP"
        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase){
        pieChart.centerText = titulo! + "\n" + estado!
    }

    
    func handler (responseObject: [Subsidio], error: NSError?) -> Void {
        if error != nil {
            println("Subsidio error obteniendo datos")
            return
        }
        
        SubsidioRepository.deleteAll()
        SubsidioRepository.saveAll(responseObject)
        
        datos = DatosSubsidios()
        entidad = datos!.consultaNacional()
        
        if let ultimaFecha = getFechaActualizacion() {
            TimeLastUpdatedRepository.saveLastTimeUpdated(getKey(), fecha: ultimaFecha)
        }
        
        loadFechasStorage()
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
        getData()
    }
    
    override func loadFromStorage() {
        println("Subsidio loadFromStorage")
        let datosStorage = SubsidioRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosSubsidios()
            entidad = datos?.consultaNacional()
            
            picker.userInteractionEnabled = true
        } else {
            muestraMensajeError()
        }
        
        loadFechasStorage()
        
        habilitarPantalla()
    }
    
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
        if row == 0 {
            entidad = datos!.consultaNacional()
        } else {
            entidad = datos!.consultaEntidad(Entidad(rawValue: row)!)
        }
        
        intEstado=row
        getData()
    }
    
      override func getKey() -> String {
        return SubsidioRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_subs
    }
}
