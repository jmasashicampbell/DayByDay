//
//  SceneDelegate.swift
//  DayByDay
//
//  Created by Jerome Campbell on 4/30/20.
//  Copyright © 2020 Jerome Campbell. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var settings = Settings()
    var generatedScriptures = GeneratedScriptures()
    var viewRouter = ViewRouter()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        var selectionCoordinator: SelectionCoordinator?
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            selectionCoordinator = appDelegate.selectionCoordinator
        }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = BaseView()
                          .environmentObject(settings)
                          .environmentObject(generatedScriptures)
                          .environmentObject(viewRouter)
                          .environmentObject(selectionCoordinator ?? SelectionCoordinator())

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Reset badge number
        UIApplication.shared.applicationIconBadgeNumber = 0
        generatedScriptures.generate(force: true)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

