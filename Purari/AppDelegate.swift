//
//  AppDelegate.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/03.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(2)
        
        let config = RealmSwift.Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // `regDate`プロパティの追加
                    migration.enumerateObjects(ofType: Info.className()) { oldObject, newObject in
                        let date = Date()
                        newObject?["regDate"] = date
                    }
                    
                    // `trial`プロパティの追加
                    migration.enumerateObjects(ofType: Info.className()) { oldObject, newObject in
                        newObject?["trial"] = ""
                    }
                } else if oldSchemaVersion < 2 {
                    // `likeBool`プロパティの追加
                    migration.enumerateObjects(ofType: Info.className()) { oldObject, newObject in
                        newObject?["likeBool"] = false
                    }
                }
            })
        
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        
        //naviのbackボタン
        let image = UIImage(named: "yajirushi")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        
        
        
        return true
    }
    
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
}

