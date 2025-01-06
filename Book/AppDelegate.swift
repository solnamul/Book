//
//  AppDelegate.swift
//  Book
//
//  Created by t2023-m105 on 1/2/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        Thread.sleep(forTimeInterval: 2.0)
        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    // MARK: - Core Data stack
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Book") // .xcdatamodeld 파일 이름과 동일 필수!
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

        // MARK: - Core Data Saving support
        func saveContext() {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }


