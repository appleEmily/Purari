//
//  GenreSelectViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/04.
//

import UIKit
import RealmSwift

class GenreSelectViewController: UIViewController {
    
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    var genre: Int!
    var genreArray: Array<Int> = []
    
    //realm
    let realm = try! Realm()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        
        let info: Info? = read()
        let playList: PlaceList? = readList()
        //めも：ジャンルがnilなことは基本的にないけど、それ以外の値に関しては、ジャンルと座標だけ登録されているケースがある。→いやない。基本的に空欄で保存する。のでこれでok
        if let playList = playList {
            print(playList.list[genre].genre)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func read() -> Info? {
        return realm.objects(Info.self).first
    }
    func readList() -> PlaceList? {
        return realm.objects(PlaceList.self).first
    }
    
    @IBAction func lunchButtonTapped(_ sender: Any) {
        genre = 0
        print("tapped")
        saveGenre()
    }
    
    @IBAction func DinnerButtonTapped(_ sender: Any) {
        genre = 1
        saveGenre()
    }
    
    @IBAction func cafeButtonTapped(_ sender: Any) {
        genre = 2
        saveGenre()
    }
    
    @IBAction func OtherButtonTapped(_ sender: Any) {
        genre = 3
        saveGenre()
    }
    
    func saveGenre() {
        genreArray.append(genre)
        let info: Info? = read()
        
        if let info = info {
            try! realm.write {
                info.genre = genre
                let placeList = PlaceList()
                //listに突っ込む
                placeList.list.append(info)
                try! realm.write {
                    realm.add(placeList)
                }
            }
        } else {
            let info = Info()
            info.genre = genre
            let placeList = PlaceList()
            //listに突っ込む
            placeList.list.append(info)
            try! realm.write {
                realm.add(placeList)
            }
        }
    }
    
}
