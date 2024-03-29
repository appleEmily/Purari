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
    @objc dynamic var likeBool: Bool = false
    
    
    
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    //マイグレーション


    
}
