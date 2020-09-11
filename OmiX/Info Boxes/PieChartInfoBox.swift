//
//  PieChartInfoBox.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 6/25/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import Foundation
import Charts

class PieChartInfoBox: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    
    var dataEntry = PieChartDataEntry(value: 0)
    
    static func fromNib() -> UIView {
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! UIView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        backgroundColor = UIColor.white.withAlphaComponent(1)
    }
    
    func setData(_ name: String, subtype: String, labels: [String], values: [Double]) {
        nameLabel.text = name
        
        var entries = [PieChartDataEntry]()
        
        let count = labels.count
        for entry in 0..<count {
            entries.append(PieChartDataEntry(value: values[entry], label: labels[entry]))
        }
    
        let set = PieChartDataSet(entries: entries, label: nil)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = ChartColorTemplates.joyful()
        set.xValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
        
        //formatting the values
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 14, weight: .light))
        data.setValueTextColor(.black)
        
        //formatting text in the center (description of pie chart)
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText = NSMutableAttributedString(string: subtype)
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 14)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.drawCenterTextEnabled = true
        chartView.centerAttributedText = centerText
        
        chartView.legend.enabled = false
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    func setData(_ name: String, subtype: String, labels: [String], values: [Double], colorsArray: [UIColor]) {
        nameLabel.text = name
        
        var entries = [PieChartDataEntry]()
        
        let count = labels.count
        for entry in 0..<count {
            entries.append(PieChartDataEntry(value: values[entry], label: labels[entry]))
        }
        
        let set = PieChartDataSet(entries: entries, label: nil)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = colorsArray            //only difference
        set.xValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
        
        //formatting the values
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 14, weight: .light))
        data.setValueTextColor(.black)
        
        //formatting text in the center (description of pie chart)
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText = NSMutableAttributedString(string: subtype)
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 14)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.drawCenterTextEnabled = true
        chartView.centerAttributedText = centerText
        
        chartView.legend.enabled = false
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
}
