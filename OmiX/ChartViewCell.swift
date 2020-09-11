//
//  ChartViewCell.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 7/17/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartViewCell: UICollectionViewCell {

    @IBOutlet weak var chartView: LineChartView!
    
    func setData(dataPoints: [Double], values: [Double]) {
        var entries: [ChartDataEntry] = []
        //var dataLabels: [String] = []
        
        let count = dataPoints.count
        for entry in 0..<count {
            entries.append(ChartDataEntry(x:dataPoints[entry], y:values[entry]))
        }
        
        let set = LineChartDataSet(entries: entries, label: "DataSet 1")
        set.drawIconsEnabled = false
        
        set.lineDashLengths = [5, 2.5]
        set.highlightLineDashLengths = [5, 2.5]
        set.setColor(.black)
        set.setCircleColor(.black)
        set.lineWidth = 1
        set.circleRadius = 3
        set.drawCircleHoleEnabled = false
        set.valueFont = .systemFont(ofSize: 9)
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 1
        set.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set.fillAlpha = 1
        set.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        set.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set)
        
        chartView.data = data
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
}
