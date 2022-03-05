//
//  place.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/05.
//

import Foundation
import RealmSwift

class Info: Object {
    @objc dynamic var genre: Int = 0
    
}

class PlaceList: Object {
    let list = List<Info>()
}
