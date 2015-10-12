import UIKit
import Charts

class EvolucionRegistroViviendaViewController: BaseUIViewController, UIPopoverPresentationControllerDelegate  {
    
    
    
    var datos: DatosEvolucionRegistroVivienda?
    var intEstado:Int = 0
    var entries: [[ChartDataEntry]]=[]
    var anios: [String] = []
    let ACCIONES = 0
    var opt: Int = 0
    

    
    @IBOutlet weak var mChart: LineChartView!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
        picker.userInteractionEnabled = false
        picker.delegate=self
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork(){
            let parseEvolucionRegistroVivienda = ParseEvolucionRegistroVivienda<Evolucion2>()
            parseEvolucionRegistroVivienda.getDatos(handler)
            return
        }
        else{
            loadFromStorage(0, option:ACCIONES)
        }
        setChart()
    }
    
    
    
    func initChart(){
        print("initChart", terminator: "")
        mChart.delegate = self
        mChart.descriptionText = ""
        mChart.noDataText = "No hay datos disponibles"
        mChart.highlightEnabled = true
        mChart.dragEnabled = true
        mChart.scaleXEnabled = true
        mChart.scaleYEnabled = true
        mChart.pinchZoomEnabled = true
        mChart.backgroundColor = UIColor.whiteColor()
        mChart.gridBackgroundColor = UIColor.whiteColor()
        
        var llXAxis: ChartLimitLine = ChartLimitLine()
        llXAxis.lineWidth = 4.0
        llXAxis.lineDashLengths = [0.0,0.5,0.0]
        llXAxis.valueFont = UIFont.systemFontOfSize(13.0)
        
        var xAxis: ChartXAxis = mChart.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.labelFont = UIFont.systemFontOfSize(9.0)
        
        
        var ll1: ChartLimitLine = ChartLimitLine()
        ll1.lineWidth = 4.0
        ll1.lineDashLengths = [0.0,0.5,0.0]
        ll1.valueFont = UIFont.systemFontOfSize(13.0)
        
        var ll2: ChartLimitLine = ChartLimitLine()
        ll2.lineWidth = 4.0
        ll2.lineDashLengths = [0.0,0.5,0.0]
        ll2.valueFont = UIFont.systemFontOfSize(13.0)
        
        var leftAxis: ChartYAxis = mChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 220.0
        leftAxis.axisMinimum = 0.0
        leftAxis.startAtZeroEnabled = true
        leftAxis.gridLineDashLengths = [0.0, 0.5, 0.0]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.axisMinimum = 0.0
        
        
        mChart.rightAxis.enabled = false
        
        
        
    }
    
    
    
    func setChart(){
        var dataSets: [LineChartDataSet] = []
        var set1: LineChartDataSet = LineChartDataSet()
        var pValues: [Double]=[10.0,20.0,30.0,20.0,45.0]
        var pDataPoints: [String] = Utils.meses
        mChart.animate(xAxisDuration: 2.5, easingOption: ChartEasingOption.EaseInOutQuart)
        var dataEntries: [ChartDataEntry] = []
        
        
        
        
        for var aux = 0; aux<entries.count;++aux{
        set1 = LineChartDataSet(yVals: entries[aux], label: anios[aux])
        
        set1.lineDashLengths = [0.1, 0.1, 0.1]
        set1.lineDashPhase = 1.0
        set1.lineWidth = 1.0
        set1.circleRadius = 3.0
        set1.drawCircleHoleEnabled = true
        set1.valueFont = UIFont.systemFontOfSize(0.0)
        set1.circleColors = [ColorTemplate.EVOLUCION_COLORS()[aux]]
        set1.colors = [ColorTemplate.EVOLUCION_COLORS()[aux]]
        dataSets.append(set1)
        
        }
        
        var data: LineChartData = LineChartData(xVals: pDataPoints, dataSets: dataSets)
        
        mChart.data = data
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    func handler (responseObject: Evolucion2, error: NSError?) -> Void {
        
        print("Handleer", terminator: "")
        if error != nil {
            print("EVOLUCION RegistroVivienda error obteniendo datos", terminator: "")
            return
        }
        
        
        
        
        if let ultimaFecha = getFechaActualizacion(){
            TimeLastUpdatedRepository.saveLastTimeUpdated(getKey(), fecha: ultimaFecha)
        }
        
        loadFromStorage(0, option: ACCIONES)
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
        setChart()
        
    }
    
    func loadFromStorage(estado: Int, option: Int) {
        print("Evolución RegistroVivienda loadFromStorage", terminator: "")
        datos = DatosEvolucionRegistroVivienda()
        entries = datos!.readEvoObject(estado, option: option)
        anios = datos!.getAnios()
        
        
        loadFechasStorage()
        habilitarPantalla()
        
        
        if let ultimaFecha = getFechaActualizacion(){
            TimeLastUpdatedRepository.saveLastTimeUpdated(getKey(), fecha: ultimaFecha)
        }
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
        setChart()
    }
    
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        intEstado=row
        loadFromStorage(intEstado, option: opt)
        
    }
    override func getKey() -> String {
        return EvolucionRegistroViviendaRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return Utils.formatoDiaMes(FechasRepository.selectFechas()!.fecha_finan)
    }
    
    
    
    
}
