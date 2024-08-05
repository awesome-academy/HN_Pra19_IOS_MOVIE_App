import Foundation
import UIKit

final class ToastView {
    
    static func showToast(message : String,
                          type: ToastEnum,
                          font: UIFont = .myMediumSystemFont(ofSize: 16)) {
        mainAsync {
            guard let window = getWindow() else {
                return
            }
            
            dismissToast()
            let width: CGFloat = getWindowSize().width
            let padding: CGFloat = 0
            let top: CGFloat = 60
            
            let bgrView = UIView()
            bgrView.translatesAutoresizingMaskIntoConstraints = false
            bgrView.frame = .init(x: 0, y: 0, width: width - 2 * padding, height: 40)
            bgrView.backgroundColor = type.color?.withAlphaComponent(0.15)
            
            let toastView = UIView()
            toastView.frame = .init(x: width, y: top, width: width - 2 * padding, height: 40)
            toastView.tag = 1001
            toastView.translatesAutoresizingMaskIntoConstraints = false
            toastView.backgroundColor = UIColor(hex: "#0C0B10")
            toastView._cornerRadius = 0
            
            let toastLabel = UILabel()
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastLabel.backgroundColor = .clear
            toastLabel.numberOfLines = 0
            toastLabel.textColor = type.color
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            
            let cancelButton = UIButton()
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.isUserInteractionEnabled = true
            cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            cancelButton.tintColor = type.color
            cancelButton.addTapGestureRecognizer { _ in
                dismissToast()
            }
            let stv = UIStackView()
            stv.translatesAutoresizingMaskIntoConstraints = false
            stv.addArrangedSubview(toastLabel)
            stv.addArrangedSubview(cancelButton)
            stv.axis = .horizontal
            stv.alignment = .fill
            stv.spacing = 4
            stv.distribution = .fill
            
            toastView.addSubview(bgrView)
            toastView.addSubview(stv)
            window.addSubview(toastView)
            
            
            NSLayoutConstraint.activate([
                bgrView.topAnchor.constraint(equalTo: toastView.topAnchor),
                bgrView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor),
                bgrView.trailingAnchor.constraint(equalTo: toastView.trailingAnchor),
                bgrView.bottomAnchor.constraint(equalTo: toastView.bottomAnchor),
                
                stv.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 4),
                stv.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant:24),
                stv.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -10),
                stv.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -4),
                
                cancelButton.widthAnchor.constraint(equalToConstant: 40),
                toastView.topAnchor.constraint(equalTo: window.topAnchor, constant: top),
                toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: padding),
                toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -padding),
                toastView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                
            ])
            
            UIView.animate(withDuration: 0.6,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut,
                           animations: {
                
                toastView.center = CGPoint(x: getWindowSize().width / 2,
                                           y: top + toastView.frame.height / 2)
            }, completion: { _ in
                mainAsynAfter(2.5) {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: .curveEaseInOut,
                                   animations: {
                        
                        toastView.alpha = 0
                    }, completion: { _ in
                        toastView.removeFromSuperview()
                    })
                }
            })
        }
    }
    
    @objc static func dismissToast() {
        guard let window = getWindow() else {
            return
        }
        
        window.subviews.forEach { sub in
            if sub.tag == 1001 {
                sub.removeFromSuperview()
            }
        }
    }
}
