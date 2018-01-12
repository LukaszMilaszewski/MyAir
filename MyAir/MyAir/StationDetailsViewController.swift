import UIKit
import Charts
import Alamofire

class StationDetailsViewController: UIViewController {
  
  var station: Station?
  
  @IBOutlet weak var barChart: BarChartView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let station = station {
      title = station.name
      configureChartData()
      configureChartView()
    }
  }
  
  func getData() -> [ChartDataEntry] {
    var data = [ChartDataEntry]()
    
    data.append(BarChartDataEntry(x: 0, y: getMeasurement(quality: station?.condition!.so2)))
    data.append(BarChartDataEntry(x: 1, y: getMeasurement(quality: station?.condition!.no2)))
    data.append(BarChartDataEntry(x: 2, y: getMeasurement(quality: station?.condition!.co)))
    data.append(BarChartDataEntry(x: 3, y: getMeasurement(quality: station?.condition!.pm10)))
    data.append(BarChartDataEntry(x: 4, y: getMeasurement(quality: station?.condition!.pm25)))
    data.append(BarChartDataEntry(x: 5, y: getMeasurement(quality: station?.condition!.o3)))
    data.append(BarChartDataEntry(x: 6, y: getMeasurement(quality: station?.condition!.c6h6)))
    
    return data
  }
  
  func configureChartData() {
    
    let data = getData()
    let chartDataSet = BarChartDataSet(values: data, label: "Quality")
    
    chartDataSet.colors = [data[0].getColor(), data[1].getColor(), data[2].getColor(), data[3].getColor(),
                           data[4].getColor(), data[5].getColor(), data[6].getColor()]
    let chartData = BarChartData(dataSet: chartDataSet)
    barChart.data = chartData
  }
  
  func configureChartView() {
    barChart.leftAxis.axisMinimum = 0
    barChart.leftAxis.axisMaximum = 6
    
    let measurementNames = ["so2", "no2", "co", "pm10", "pm25", "o3", "c6h6"]
    barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: measurementNames)
    
    barChart.chartDescription?.text = ""
    barChart.borderLineWidth = 2
    barChart.xAxis.granularity = 1
    barChart.highlighter = nil
    barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
    barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
    
    barChart.drawValueAboveBarEnabled = false
    barChart.scaleYEnabled = false
    barChart.scaleXEnabled = false
    barChart.pinchZoomEnabled = false
    barChart.doubleTapToZoomEnabled = false
    barChart.legend.enabled = false
    barChart.data?.setDrawValues(false)
    barChart.rightAxis.enabled = false
    barChart.xAxis.drawGridLinesEnabled = false
  }
  
  func getMeasurement(quality: String?) -> Double {
    if let quality = quality {
      switch quality {
      case "Bardzo dobry":
        return 6
      case "Dobry":
        return 5
      case "Umiarkowany":
        return 4
      case "Dostateczny":
        return 3
      case "Zły":
        return 2
      case "Bardzo zły":
        return 1
      default:
        return 0
      }
    }
    return 0
  }
}
