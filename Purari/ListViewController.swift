//
//  ListViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/06.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    let realm = try! Realm()
    
    var genre: Int!
    var imageName: String!
    
    //let info = Info()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = realm.objects(Info.self)
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        let data = realm.objects(Info.self)
        setImage()
        print(data)
        cell.cityLabel.text = String(data[indexPath.row].genre)
        
        genre = data[indexPath.row].genre
        setImage()
        cell.imageView?.image = UIImage(named: imageName)
        return cell
    }
    
    func setImage() {
        if genre == 0 {
            imageName = "lunch"
        } else if genre == 1 {
            imageName = "dinner"
        } else if genre == 2 {
            imageName = "cafe"
        } else {
            imageName = "other"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移。
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            self.navigationController?.pushViewController(nextView, animated: true)
        nextView.recievedNumber = indexPath.row
        
        table.deselectRow(at: indexPath, animated: true)
    }
    
    
}
