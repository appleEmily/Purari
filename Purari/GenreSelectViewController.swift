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
    var number: Int = 0
    
    //realm
    let realm = try! Realm()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        
        let info: Info? = read()
        let playList: PlaceList? = readList()
        //めも：ジャンルがnilなことは基本的にないけど、それ以外の値に関しては、ジャンルと座標だけ登録されているケースがある。→いやない。基本的に空欄で保存する。のでこれでok
        if let playList = playList {
            //[genre].genre
            print(playList.list[number])
            
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
        number += 1
        genre = 0
        print("tapped")
//        saveGenre()
        backMapVC()
    }
    
    @IBAction func DinnerButtonTapped(_ sender: Any) {
        number += 1
        genre = 1
       // saveGenre()
        backMapVC()
    }
    
    @IBAction func cafeButtonTapped(_ sender: Any) {
        number += 1
        genre = 2
       // saveGenre()
        backMapVC()
    }
    
    @IBAction func OtherButtonTapped(_ sender: Any) {
        number += 1
        genre = 3
       // saveGenre()
        backMapVC()
    }
    
    //このメソッドおかしい。
    //多分
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
            print(placeList.list[number])
        }
    }
    
    func backMapVC() {
        //ボタンが押されたことをMapVCに伝えて、画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let mapVC = ViewController()
        mapVC.viewWillAppear(true)
        mapVC.myPlace()
        mapVC.putpin()
        dismiss(animated: true, completion: nil)
    }
    
}
