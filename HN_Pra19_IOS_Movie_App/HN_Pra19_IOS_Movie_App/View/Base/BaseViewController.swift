//
//  BaseViewController.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 1/6/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    let colums: CGFloat = isIphone() ? 3 : 5
    let spacing: CGFloat = isIphone() ? 12 : 25
    let padding: CGFloat = isIphone() ? 17 : 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.clearCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Utils.clearCache()
    }
    
    func hideMenu() {
        guard let nav = navigationController as? CustomNavigationViewController else {
            return
        }
        nav.hideMenu()
    }
    
    func showMenu() {
        guard let nav = navigationController as? CustomNavigationViewController else {
            return
        }
        nav.showMenu()
    }
}

extension BaseViewController {
    func push(_ vc: UIViewController, animation: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animation)
        
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func setRoot(_ vc: UIViewController) {
        self.navigationController?.viewControllers  = [vc]
    }
}
