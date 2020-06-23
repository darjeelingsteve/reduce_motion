//
//  SceneDelegate.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 20/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
    }
}

