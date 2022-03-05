//
//  GenreSelectViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/04.
//

import UIKit

class GenreSelectViewController: UIViewController {
    
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    var genre: Int!
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func lunchButtonTapped(_ sender: Any) {
        genre = 0
        
    }
    
    @IBAction func DinnerButtonTapped(_ sender: Any) {
        genre = 1
        
    }
    
    @IBAction func cafeButtonTapped(_ sender: Any) {
        genre = 2
        
    }
    
    @IBAction func OtherButtonTapped(_ sender: Any) {
        genre = 3
        
    }
    
}
