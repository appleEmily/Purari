//
//  ListTableViewCell.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/06.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
