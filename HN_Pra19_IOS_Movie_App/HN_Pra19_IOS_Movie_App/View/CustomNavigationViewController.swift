//
//  CustomNavigationViewController.swift
//  TUANNM_MOVIE_21
//
//  Created by Khánh Vũ on 5/6/24.
//

import UIKit

class CustomNavigationViewController: UINavigationController {
    var menuView: KVMenuView!
    var isShow = false
    let menuButton = KVHomeMenuButton(image: UIImage(named: "icn_home"),
                                      size: CGSize(width: 187, height: 74))

    var tabsIcon: [UIImage?] = [UIImage(named: "icn_home_circle"),
                                UIImage(named: "icn_actor_circle"),
                                UIImage(named: "icn_statics_circle")]
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        menuButton.pressedImage = UIImage(named: "icn_tab_gray")
        let animator = CPMenuAnimator(commonDuration: 0.5,
                                      commonSpringWithDamping: 0.5,
                                      commonSpringVelocity: 10)
        menuView = KVMenuView(parentView: self.view,
                              homeButton: menuButton,
                              animator: animator,
                              type: .upperhalf,
                              radius: 70,
                              isClockWise: true)
        menuView.delegate = self
        menuView.datasource = self
        menuView.setHomeButtonPosition(position: CGPoint(x: view.center.x,
                                                         y: view.bounds.height - 74 / 2))
        setIndexSelected(index: 0)
    }
        
    func setIndexSelected(index: Int) {
        switch index {
        case 0:
            setViewControllers([HomeViewController()], animated: false)
            menuButton.notPressedImage = UIImage(named: "icn_home")
        case 1:
            setViewControllers([ActorViewController()], animated: false)
            menuButton.notPressedImage = UIImage(named: "icn_actor")
        default:
            setViewControllers([StaticsViewController()], animated: false)
            menuButton.notPressedImage = UIImage(named: "icn_statics")
        }
    }
    
    func setHomeIcon(index: Int) {
        switch index {
        case 0:
            menuButton.notPressedImage = UIImage(named: "icn_home")
        case 1:
            menuButton.notPressedImage = UIImage(named: "icn_actor")
        default:
            menuButton.notPressedImage = UIImage(named: "icn_statics")
        }
    }
    
    func hideMenu() {
        menuView.state = .none
        menuView.setHidden(true)
    }
    
    func showMenu() {
        menuView.setHidden(false)
    }
}

extension CustomNavigationViewController: CPMenuViewDataSource {
    func menuViewNumberOfItems() -> Int {
        return tabsIcon.count
    }
    
    func menuView(_: KVMenuView, buttonAtIndex index: Int) -> KVCircleSubMenuButton {
        let subMenuButton = KVCircleSubMenuButton(image: tabsIcon[index]!, size: CGSize(width: 45, height: 45))
        subMenuButton.offset = 0
        subMenuButton.backgroundColor = UIColor.init(red: 243/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1)
        subMenuButton.layer.cornerRadius = subMenuButton.frame.height / 2
        subMenuButton.layer.masksToBounds = true
        return subMenuButton
    }
}

extension CustomNavigationViewController: CPMenuViewDelegate {
    func menuView(_ menuView: KVMenuView, didSelectButtonAtIndex index: Int) {
        setIndexSelected(index: index)
    }
    
    func menuView(_ menuView: KVMenuView, didSelectHomeButtonState state: KVCircleMenuViewState) {
    }
}
