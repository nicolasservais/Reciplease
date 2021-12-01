//
//  AppDelegate.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var coreDataRecipeActivate: Bool = false
    var window: UIWindow?
    static var coreDataStack = CoreDataStack(modelName: "Reciplease")
    var tabView: TabViewController
    static var coredataRecipe: CoredataRecipe?
    override init() {
        tabView = TabViewController()
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window!.rootViewController = tabView
        window!.makeKeyAndVisible()
        return true
    }
}

