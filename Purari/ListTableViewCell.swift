//
//  ListTableViewCell.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/06.
//

import UIKit
import RealmSwift

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainBackground: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    //Realmを使えるようにする。お気に入り登録のため。
    let realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
