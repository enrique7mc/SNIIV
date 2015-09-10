//
//  PCUViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit
import Charts

class PCUViewController: BaseUIViewController {

    @IBOutlet weak var picker: UIPickerView!

    @IBOutlet weak var pieChart: PieChartView!
    
    var entidad: PCU?
    var datos: DatosPCU?
    var parties: [String] = []
    var values: [Int64] = []
    var dValues:[Double]=[]
    var titulo: String? = "PCU"
    var estado:String? = ""
    var intEstado: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
        picker.userInteractionEnabled = false
        activarIndicador()
        
        pieChart.delegate=self
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {
            var parsePCU = ParsePCU<[PCU]>()
            parsePCU.getDatos(handler)
            return
        }
        
        loadFromStorage()
        getData()
    }
    
    func initChart(){
        
        pieChart.rotationAngle=0.0
        pieChart.animate(xAxisDuration: 1.5, easingOption: ChartEasingOption.EaseInOutQuad)
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
        var totalValues:Double=0
        var dParcial:Double=0.0
        var dSumParcial:[Double]=[]
        var aux=0
        var tValues:[Double]=[]
        var tParties:[String]=[]
        parties = ["U1   "," U2   ","U3   ","FC","N/D"]
        values = [entidad!.u1, entidad!.u2, entidad!.u3, entidad!.fc, entidad!.nd]
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
            if(a>2){
                
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
        var aux: Int=0
        aux = Int(entry.value)
        pieChart.centerText = titulo! + "\n" + estado! + "\n\(Utils.decimalFormat(aux)) \(parties[entry.xIndex])"
        
        
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase){
        pieChart.centerText = titulo! + "\n" + estado!
    }
    
    func handler (responseObject: [PCU], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        PCURepository.deleteAll()
        PCURepository.saveAll(responseObject)
        
        datos = DatosPCU(datos: responseObject)
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
        println("PCU loadFromStorage")
        let datosStorage = PCURepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosPCU(datos: datosStorage)
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
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
        intEstado=row
        getData()
        
    }
    
    
    
    override func getKey() -> String {
        return PCURepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_vv
    }
}
