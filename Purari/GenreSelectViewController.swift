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
    
    //realm
    let realm = try! Realm()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        
        let info: Info? = read()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
    }
    
    func read() -> Info? {
        return realm.objects(Info.self).first
    }
    
    @IBAction func lunchButtonTapped(_ sender: Any) {
        genre = 0
        print("tapped")
        //        saveGenre()
        backMapVC()
    }
    
    @IBAction func DinnerButtonTapped(_ sender: Any) {
        genre = 1
        // saveGenre()
        backMapVC()
    }
    
    @IBAction func cafeButtonTapped(_ sender: Any) {
        genre = 2
        // saveGenre()
        backMapVC()
    }
    
    @IBAction func OtherButtonTapped(_ sender: Any) {
        genre = 3
        // saveGenre()
        backMapVC()
    }
    
    //このメソッドおかしい。
    //多分
    func saveGenre() {
        
     
    }
    
    
    func backMapVC() {
        let preNC = self.presentingViewController as! UINavigationController
        // let preNC = self.navigationController as! UINavigationController でも可能かと思います
        let mapVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! ViewController
        mapVC.recievedGenre = genre
        mapVC.putpin()
        //ここでジャンルの番号を渡す。
        
        dismiss(animated: true, completion: nil)
    }
    
}
