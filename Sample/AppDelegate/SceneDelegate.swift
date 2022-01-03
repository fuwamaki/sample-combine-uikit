//
//  SceneDelegate.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let monitor = NWPathMonitor()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        monitor.pathUpdateHandler = { path in
            APIClient.networkStatus = path.status
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
