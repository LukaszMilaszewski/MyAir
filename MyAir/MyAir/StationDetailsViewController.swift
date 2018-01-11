import UIKit
import Charts
import Alamofire

class StationDetailsViewController: UIViewController {
  
  var station: Station?
  var measurementNames = ["so2", "no2", "co", "pm10", "pm25", "o3", "c6h6"]
  var data = [ChartDataEntry]()
  
  @IBOutlet weak var barChart: BarChartView!
  
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
  
  func setColor(value: Double) -> UIColor{
    switch value {
    case 1:
      return UIColor.green
    case 2:
      return UIColor.red
    case 3:
      return UIColor.brown
    case 4:
      return UIColor.blue
    case 5:
      return UIColor.yellow
    case 6:
      return UIColor.purple
    default:
      return UIColor.clear
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let station = station {
      title = station.name
      data.append(BarChartDataEntry(x: 0, y: getMeasurement(quality: station.condition!.so2)))
      data.append(BarChartDataEntry(x: 1, y: getMeasurement(quality: station.condition!.no2)))
      data.append(BarChartDataEntry(x: 2, y: getMeasurement(quality: station.condition!.co)))
      data.append(BarChartDataEntry(x: 3, y: getMeasurement(quality: station.condition!.pm10)))
      data.append(BarChartDataEntry(x: 4, y: getMeasurement(quality: station.condition!.pm25)))
      data.append(BarChartDataEntry(x: 5, y: getMeasurement(quality: station.condition!.o3)))
      data.append(BarChartDataEntry(x: 6, y: getMeasurement(quality: station.condition!.c6h6)))

      let chartDataSet = BarChartDataSet(values: data, label: "Quality")
      chartDataSet.colors = [setColor(value: data[0].y),setColor(value: data[1].y),setColor(value: data[2].y),setColor(value: data[3].y),setColor(value: data[4].y), setColor(value: data[5].y), setColor(value: data[6].y)]
      let chartData = BarChartData(dataSet: chartDataSet)
      barChart.data = chartData
      
      barChart.leftAxis.axisMinimum = 0
      barChart.leftAxis.axisMaximum = 6
      barChart.scaleYEnabled = false
      barChart.scaleXEnabled = false
      barChart.pinchZoomEnabled = false
      barChart.doubleTapToZoomEnabled = false
//      barChart.animate(yAxisDuration: 1.5, easingOption: easeInOutQuartEaseInOutQuart)
      barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: measurementNames)
      barChart.data?.setDrawValues(false)
      //Also, you probably want to add:
      barChart.rightAxis.enabled = false
      barChart.chartDescription?.text = ""
      
      barChart.borderLineWidth = 2
      barChart.xAxis.drawGridLinesEnabled = false
      barChart.xAxis.granularity = 1
      barChart.highlighter = nil
      barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
      barChart.legend.enabled = false
      barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
      barChart.drawValueAboveBarEnabled = false
      
    }
  }
}

