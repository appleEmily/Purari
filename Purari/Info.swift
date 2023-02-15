//
//  place.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/05.
//

import Foundation
import RealmSwift

class Info: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var genre: Int = 0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var city: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var who: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var regDate: Date = Date()
    @objc dynamic var trial: String = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    //マイグレーション
    func migration() {
        let migSchemaVersion: UInt64 = 2
        
        let config = Realm.Configuration(
            schemaVersion: migSchemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < migSchemaVersion) {
                /*    migration.enumerateObjects(ofType: Info.className()){ _, _ in
                        
                    }
                    */
                  //  Realm.Configuration.init(deleteRealmIfMigrationNeeded: false)
                }})
        Realm.Configuration.defaultConfiguration = config
    }
    
}
