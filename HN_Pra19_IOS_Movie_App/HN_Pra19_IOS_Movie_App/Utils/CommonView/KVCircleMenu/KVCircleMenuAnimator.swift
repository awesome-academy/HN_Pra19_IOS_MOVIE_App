//
//  KVCircleMenuAnimator.swift
//  TUANNM_MOVIE_21
//
//  Created by Khánh Vũ on 2/6/24.
//

import Foundation
import UIKit

public protocol CPMenuAnimationProtocol {
    func animationHomeButton(homeButton: KVHomeMenuButton, state: KVCircleMenuViewState, completion: (() -> Void)?)
    func animationShowSubMenuButton(subButtons: [KVCircleSubMenuButton], completion: (() -> Void)?)
    func animationHideSubMenuButton(subButtons: [KVCircleSubMenuButton], completion: (() -> Void)?)
}

struct CPMenuAnimator {
    var commonDuration: TimeInterval = 0.3
    var commonSpringWithDamping: CGFloat = 0.5
    var commonSpringVelocity:CGFloat = 0
    
    func animation(delay: TimeInterval,
                   animation: @escaping () -> Void,
                   completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: commonDuration,
                       delay: delay,
                       usingSpringWithDamping: commonSpringWithDamping,
                       initialSpringVelocity: commonSpringVelocity,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: animation,
                       completion: completion)
    }
}

extension CPMenuAnimator: CPMenuAnimationProtocol {
  public func animationShowSubMenuButton(subButtons: [KVCircleSubMenuButton],
                                         completion: (() -> Void)?) {
       var delay: TimeInterval = 0
       for button in subButtons {
           let completionBlock = button.isEqual(subButtons.last) ? completion : nil
           animation(delay:delay, animation: {
               button.center = button.endPosition!
               button.alpha = 1
           }, completion: { (finish) in
               completionBlock?()
           })
           delay += 0.15
       }
   }

  public func animationHideSubMenuButton(subButtons: [KVCircleSubMenuButton],
                                         completion: (() -> Void)?) {
       var delay: TimeInterval = 0
       for button in subButtons.reversed() {
           let completionBlock = button.isEqual(subButtons.last) ? completion : nil
           animation(delay:delay,
                     animation: {
               button.center = button.startPosition!
               button.alpha = 0
           }, completion: { (finish) in
               completionBlock?()
           })
           delay += 0.1
       }
   }

  public func animationHomeButton(homeButton: KVHomeMenuButton,
                                  state: KVCircleMenuViewState,
                                  completion: (() -> Void)?) {
      let scale: CGFloat = state == .expand ? 1.0 : 1.0
       let transform = CGAffineTransform(scaleX: scale, y: scale)
       animation(delay: 0, animation: {
           homeButton.transform = transform
       }, completion: { finish in
           completion?()
       })
   }
}

