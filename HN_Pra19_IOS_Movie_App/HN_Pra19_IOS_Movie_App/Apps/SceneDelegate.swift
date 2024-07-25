//
//  SceneDelegate.swift
//  TUANNM_MOVIE_17
//
//  Created by Khánh Vũ on 11/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    class var shared: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate ?? SceneDelegate()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let rootNavigation = CustomNavigationViewController()
        self.window = UIWindow(frame: scene.coordinateSpace.bounds)
        self.window?.windowScene = scene
        window?.rootViewController = rootNavigation
        window?.makeKeyAndVisible()
    }
}

