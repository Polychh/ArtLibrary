//
//  SceneDelegate.swift
//  ArtLibrary
//
//  Created by Polina on 12.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController()
        let mainVC = MainViewController(viewModel: MainViewModel(network: NetworkService()))
        nav.viewControllers = [mainVC]
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}

