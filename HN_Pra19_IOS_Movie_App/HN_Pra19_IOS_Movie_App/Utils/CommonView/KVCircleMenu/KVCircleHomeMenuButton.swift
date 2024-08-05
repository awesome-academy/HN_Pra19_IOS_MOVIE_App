//
//  KVCircleHomeMenuButton.swift
//  TUANNM_MOVIE_21
//
//  Created by Khánh Vũ on 2/6/24.
//

import Foundation
import UIKit

protocol CPMenuViewDelegate: NSObject {
    func menuView(_ menuView: KVMenuView, didSelectButtonAtIndex index: Int)
    func menuView(_ menuView: KVMenuView, didSelectHomeButtonState state: KVCircleMenuViewState)
}

protocol CPMenuViewDataSource: NSObject {
    func menuViewNumberOfItems() -> Int
    func menuView(_ : KVMenuView, buttonAtIndex index: Int) -> KVCircleSubMenuButton
}

public enum KVCircleMenuViewState {
    case none
    case expand
}

public enum KVCircleMenuType {
    case all
    case half
    case upperhalf
    case lowerhalf
    case quarter
}

public class KVHomeMenuButton: KVCircleMenuButton {
   var pressedImage: UIImage?
   var notPressedImage: UIImage?

   func markAsPressed(_ pressed: Bool) {
       notPressedImage = notPressedImage ?? image
       image = pressed ? pressedImage : notPressedImage
   }
}

public class KVMenuView: NSObject {

    fileprivate var parentView: UIView?
    fileprivate var homeButton: KVHomeMenuButton?
    fileprivate var animator: CPMenuAnimator?
    fileprivate var menuButtons:[KVCircleSubMenuButton] = []

    public var type: KVCircleMenuType = .all
    public var isClockWise = true // Default is clockwise
    public var radius: Double = 100 // Default radius

    var state: KVCircleMenuViewState = .none {
        didSet {
            state == .none
            ? animator?.animationHideSubMenuButton(subButtons: menuButtons, completion: nil)
            : animator?.animationShowSubMenuButton(subButtons: menuButtons, completion: nil)
            
            animator?.animationHomeButton(homeButton: homeButton!, state: state, completion: nil)
            setHomeButtonImage(pressed: state == .expand)
        }
    }

    weak var datasource: CPMenuViewDataSource?
    weak var delegate: CPMenuViewDelegate?

    init(parentView: UIView,
         homeButton: KVHomeMenuButton,
         animator: CPMenuAnimator,
         type: KVCircleMenuType,
         radius: Double = 100,
         isClockWise: Bool) {
        self.parentView = parentView
        self.homeButton = homeButton
        self.animator = animator
        self.type = type
        self.radius = radius
        self.isClockWise = isClockWise
        super.init()
        self.setup()
    }

    convenience public init(parentView: UIView,
                            homeButton: KVHomeMenuButton,
                            type: KVCircleMenuType = .all,
                            radius: Double = 100,
                            isClockWise: Bool = true) {
        self.init(parentView: parentView,
                  homeButton: homeButton,
                  animator: CPMenuAnimator(),
                  type: type,
                  radius: radius,
                  isClockWise: isClockWise)
    }

    private func setup() {
        setUpHomeButton()
    }

    fileprivate func setUpHomeButton() {
        guard let parentView = parentView else {
            return
        }
        setUpDefaultHomeButtonPosition()
        homeButton?.delegate = self
        parentView.addSubview(homeButton!)
        parentView.bringSubviewToFront(homeButton!)
    }

    fileprivate func setUpDefaultHomeButtonPosition() {
        guard let parentView = parentView else {
            return
        }
        homeButton?.center = parentView.center
    }

    public func reloadButton() {
        state = .none
        removeButton()
        addButton()
        layoutButton()
    }

    private func addButton() {
        guard let numberOfItem = datasource?.menuViewNumberOfItems() else { return }
        for i in 0..<numberOfItem {
            let button = datasource!.menuView(self, buttonAtIndex: i)
            button.delegate = self
            parentView?.addSubview(button)
            parentView?.bringSubviewToFront(button)
            menuButtons.append(button)
        }
    }

    private func removeButton() {
        let _ =  menuButtons.map { $0.removeFromSuperview() }
        menuButtons.removeAll()
    }

    private func layoutButton() {
        let theta = getTheta()
        let flip: Double = isClockWise ? 1 : -1
        var index = 0
        let center = CGPoint(x: homeButton!.frame.midX, y: homeButton!.frame.midY)
        menuButtons.forEach { (item) in
            var x = 0.0
            var y = 0.0
            if type == .upperhalf  {
                x = Double(center.x) - cos(Double(index) * theta) * radius * flip
                y = Double(center.y - 20) - sin(Double(index) * theta) * radius

            } else if type == .lowerhalf {
                x = Double(center.x) + cos(Double(index) * theta) * radius * flip
                y = Double(center.y - 20) + sin(Double(index) * theta) * radius

            } else {
                x = Double(center.x) + sin(Double(index) * theta) * radius * flip
                y = Double(center.y - 20) - cos(Double(index) * theta) * radius
            }

            item.center = center
            item.startPosition = center
            item.endPosition = CGPoint(x: x, y: y)
            item.index = index
            item.alpha = 0
            index += 1
        }
    }

    private func getTheta() -> Double {
        let numberItem: Double = Double(datasource!.menuViewNumberOfItems() == 0 
                                        ? 1
                                        : datasource!.menuViewNumberOfItems() - 1)
        switch type {
        case .all:
            return 2 * Double.pi / (numberItem + 1)
        case .half:
            return Double.pi / numberItem
        case .upperhalf:
            return (Double.pi) / (numberItem)
        case .lowerhalf:
            return Double.pi / numberItem
        case .quarter:
            return Double.pi / 2 / numberItem
        }
    }

    private func setHomeButtonImage(pressed: Bool) {
        homeButton?.markAsPressed(pressed)
    }

    public func setHomeButtonPosition(position: CGPoint) {
        homeButton?.center = position
        reloadButton()
    }

    public func setHidden(_ isHidden: Bool) {
        homeButton?.isHidden = isHidden
    }
}

extension KVMenuView: KVCircleMenuButtonDelegate {
    public func didSelectButton(sender: KVCircleMenuButton) {
        if let subMenuButton = sender as? KVCircleSubMenuButton,
           let indexOfItem = menuButtons.firstIndex(of: subMenuButton) {
            delegate?.menuView(self, didSelectButtonAtIndex: indexOfItem)
            state = .none
        } else {
            state = state == .none ? .expand : .none
            delegate?.menuView(self, didSelectHomeButtonState: state)
        }
    }
}
