//
//  ValorViviendaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit
import Charts

class ValorViviendaViewController: BaseUIViewController, UIPopoverPresentationControllerDelegate{


    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var btnDatos: UIButton!
    var entidad: ValorVivienda?
    var datos: DatosValorVivienda?
    var parties:[String] = []
    var values:[Int64] = []
    var dValues:[Double]=[]
    var titulo:String? = "Valor Vivienda"
    var estado: String? = ""
    var intEstado:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
        picker.userInteractionEnabled = false

        activarIndicador()
        
        pieChart.delegate=self
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {            
            var parseValor = ParseValorVivienda<[ValorVivienda]>()
            parseValor.getDatos(handler)
            return
        }
        
        loadFromStorage()
        getData()
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func showData(sender: AnyObject) {
         performSegueWithIdentifier("datosModal", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "datosModal") {
            var svc = segue.destinationViewController as! DialogViewController
            svc.pStrings=parties
            svc.pValues=values
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
        var totalValues:Double=0
        var dParcial:Double=0.0
        var dSumParcial:[Double]=[]
        var aux=0
        var tValues:[Double]=[]
        var tParties:[String]=[]
        parties = ["Popular", "Tradicional","Media-Res."]
        values = [entidad!.popular,entidad!.tradicional, entidad!.media_residencial]
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
            if(a>1){
                
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
    
    func handler (responseObject: [ValorVivienda], error: NSError?) -> Void {
        if error != nil {
            println("ValorVivienda error obteniendo datos")
            return
        }
        
        ValorViviendaRepository.deleteAll()
        ValorViviendaRepository.saveAll(responseObject)
        
        datos = DatosValorVivienda(datos: responseObject)
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
        println("Valorivienda loadFromStorage")
        let datosStorage = ValorViviendaRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosValorVivienda(datos: datosStorage)
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
        return ValorViviendaRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_vv
    }
}
