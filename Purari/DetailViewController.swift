//
//  DetailViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/07.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    var recievedNumber: Int = 0
    
    let realm = try! Realm()
    
    var genre: Int!
    var imageName: String!
    
    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var whoText: UITextField!
    @IBOutlet weak var commentView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = realm.objects(Info.self)[recievedNumber]
        print(data)
        genre = data.genre
        setImage()
        print(imageName)
        cityLabel.text = data.city
        nameText.text = data.name
        whoText.text = data.who
        commentView.text = data.comment
        genreImage.image = UIImage(named: imageName)
        
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
    
}
