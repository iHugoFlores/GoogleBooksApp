//
//  AppDelegate.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Core Data Boilerplate Code
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "GoogleBooks")
      container.loadPersistentStores(completionHandler: { storeDescription, error in
          //print(storeDescription)
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
    }()

    func saveContext() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let error = error as NSError
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
