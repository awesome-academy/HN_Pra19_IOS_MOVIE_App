//
//  UIView+Extension.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - Load
    class var nibNameClass: String { return String(describing: self.self) }
    
    class var nibClass: UINib? {
        if Bundle.main.path(forResource: nibNameClass, ofType: "nib") != nil {
            return UINib(nibName: nibNameClass, bundle: nil)
        } else {
            return nil
        }
    }
    
    class func loadFromNib(nibName: String? = nil) -> Self? {
        return loadFromNib(nibName: nibName, type: self)
    }
    
    class func loadFromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        guard let nibViews = Bundle.main.loadNibNamed(nibName ?? self.nibNameClass, owner: nil, options: nil)
        else { return nil }
        
        return nibViews.filter({ (nibItem) -> Bool in
            return (nibItem as? T) != nil
        }).first as? T
    }
    
    //MARK: - Subview
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func removeAllSubviews() {
        let allSubs = self.subviews
        for aSub in allSubs {
            aSub.removeFromSuperview()
        }
    }
    
    //MARK: - Set Layer
    func setCornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask? = nil) {
        layer.cornerRadius = radius
        if let corners = maskedCorners {
            layer.maskedCorners = corners
        }
        layer.masksToBounds = true
    }
    
    func applyRadiusMaskFor(size: CGSize, topLeft: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0, topRight: CGFloat = 0) {

        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width - topRight, y: 0))
        path.addLine(to: CGPoint(x: topLeft, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: topLeft), controlPoint: .zero)
        path.addLine(to: CGPoint(x: 0, y: size.height - bottomLeft))
        path.addQuadCurve(to: CGPoint(x: bottomLeft, y: size.height), controlPoint: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: size.width - bottomRight, y: size.height))
        path.addQuadCurve(to: CGPoint(x: size.width, y: size.height - bottomRight), controlPoint: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: size.width, y: topRight))
        path.addQuadCurve(to: CGPoint(x: size.width - topRight, y: 0), controlPoint: CGPoint(x: size.width, y: 0))

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    //MARK: - Set radius with border
    func setBorder(_ radius: CGFloat = 0, borderWidth: CGFloat, borderColor: UIColor?) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }
    
    //MARK: - Set Shadow
    func setShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    //MARK: - Set Gradient
    func setGradient(_ size: CGSize = .zero, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, location: [NSNumber] = [0.0, 1.0]) {
        if let layers = layer.sublayers {
            for sub in layers {
                if let gra = sub as? CAGradientLayer {
                    gra.removeFromSuperlayer()
                }
            }
        }
        
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = location
        gradient.frame = CGRect(origin: .zero, size: size)
        
        layer.insertSublayer(gradient, at: 0)
        
    }
    
    //MARK: - Snapshot
    func screenshot(_ rect: CGRect? = nil) -> UIImage? {
        
        let rect = rect ?? self.bounds
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: rect)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(rect.size)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            context.translateBy(x: rect.minX, y: rect.minY)
            self.layer.render(in:context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let cgImage = image?.cgImage else { return nil }
            return UIImage(cgImage: cgImage)
        }
    }
}

extension UIView {
    @IBInspectable
    var _cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var _borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var _borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var _lShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var _lShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var _lShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var _lShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func setPathBachground(color: UIColor, progress: CGFloat) {
        let frame = self.frame
        self.layer.frame = CGRect(x: frame.origin.x,
                                  y: frame.origin.y,
                                  width: frame.width * progress,
                                  height: frame.height)
        self.layer.backgroundColor = color.cgColor
    }
    
    enum GradientType {
        case leftToRight, topToBottom, aLittleTopToBottom
    }
}


