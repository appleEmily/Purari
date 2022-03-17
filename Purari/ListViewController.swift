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
    var data: Results<Info>!
    // var filterArray: Array<Info>!
    
    var genre: Int!
    var imageName: String!
    var dataArray: Array<Any>!
    
    var lunchBool: Bool = true
    var dinnerBool:Bool = true
    var cafeBool: Bool = true
    var otherBool: Bool = true
    
    //配列の足し算にすれば良い？
    //そうするとジャンルごとに並んじゃうなぁ
    
    //UINavigationBarに設置するボタン
    var backButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(Info.self)
        
        table.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        //table.separatorColor = .black
        table.backgroundView = nil
        
        //ダークモード回避
        self.overrideUserInterfaceStyle = .light
        //UI
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.clear
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        setImage()
        print(data)
        cell.nameLabel.text = String(data[indexPath.row].name)
        
        genre = data[indexPath.row].genre
        setImage()
        cell.genreImage.image = UIImage(named: imageName)
        
        //UI
        cell.mainBackground.layer.cornerRadius = 10.0
        cell.mainBackground.layer.masksToBounds = true
        // cell.backgroundColor = .white
        cell.backgroundColor = UIColor.clear
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write{
                realm.delete(data[indexPath.row])
            }
            table.reloadData()
            
        }
        
    }
    
    @IBAction func lunch(_ sender: Any) {
        if lunchBool == true {
            lunchBool = false
        } else {
            lunchBool = true
        }
        
    }
    
    @IBAction func dinner(_ sender: Any) {
        if dinnerBool == true {
            dinnerBool = false
        } else {
            dinnerBool = true
        }
    }
    
    @IBAction func cafe(_ sender: Any) {
        if cafeBool == true {
            cafeBool = false
        } else {
            cafeBool = true
        }
    }
    
    @IBAction func other(_ sender: Any) {
        if otherBool == true {
            otherBool = false
        } else {
            otherBool = true
        }
    }
    
    func filter() {
        
    }
}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 12.0
        self.layer.shadowOpacity = 0.25
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
