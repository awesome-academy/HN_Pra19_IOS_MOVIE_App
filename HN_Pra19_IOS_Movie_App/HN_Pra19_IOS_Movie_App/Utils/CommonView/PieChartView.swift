//
//  Pie.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 8/6/24.
//

import Foundation
import UIKit

class PieChartView: UIView {
    // Values for the pie chart
    var values: [CGFloat] = [60, 40] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Colors for the slices
    var colors: [UIColor] = [UIColor.systemPink, UIColor.systemBlue] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        // Get the current context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Calculate the total value
        let total = values.reduce(0, +)
        
        // Start angle for the first segment
        var startAngle: CGFloat = -.pi / 2
        
        // Center of the view
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Radius of the pie chart
        let radius = min(rect.width, rect.height) / 2
        
        // Loop through the values and draw each segment
        for (index, value) in values.enumerated() {
            // Calculate the end angle for the segment
            let endAngle = startAngle + (2 * .pi * (value / total))
            
            // Set the fill color
            context.setFillColor(colors[index].cgColor)
            
            // Move to the center
            context.move(to: center)
            
            // Add the arc
            context.addArc(center: center,
                           radius: radius,
                           startAngle: startAngle,
                           endAngle: endAngle,
                           clockwise: false)
            
            // Close the path and fill the segment
            context.closePath()
            context.fillPath()
            
            // Update the start angle for the next segment
            startAngle = endAngle
        }
    }
}
