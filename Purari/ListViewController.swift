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
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    let realm = try! Realm()
    var data: Results<Info>!
    var filterArray: Results<Info>!
    
    var genre: Int!
    var imageName: String!
    var dataArray: Array<Any>!
    
    var genreFilter: Int!
    
    var lunchBool: Bool = false
    var dinnerBool:Bool = false
    var cafeBool: Bool = false
    var otherBool: Bool = false
    var filterMode: Bool = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
                presentingViewController?.endAppearanceTransition()
        table.reloadData()
        lunchBool = false
        dinnerBool = false
        cafeBool = false
        otherBool = false
        filterMode = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //ここを、dataにするときと、filterArrayにする時があるってことだ
        var numberOfCell: Int = 0
        if filterMode == false {
            numberOfCell = data.count
        } else {
            numberOfCell = filterArray.count
        }
        return numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        //print(data)
        //ここで分岐が必要！filterModeを使う。
        if filterMode == false {
            cell.nameLabel.text = String(data[indexPath.row].name)
            cell.cityLabel.text = data[indexPath.row].city
            genre = data[indexPath.row].genre
        } else {
            cell.nameLabel.text = String(filterArray[indexPath.row].name)
            cell.cityLabel.text = filterArray[indexPath.row].city
            genre = filterArray[indexPath.row].genre
            
        }
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
            if lunchBool == false {
                imageName = "lunch"
            } else {
                imageName = "lunch_pink"
            }
        } else if genre == 1 {
            if dinnerBool == false {
                imageName = "dinner"
            } else {
                imageName = "dinner_pink"
            }
        } else if genre == 2 {
            if cafeBool == false {
                imageName = "cafe"
            } else {
                imageName = "cafe_pink"
            }
        } else {
            if otherBool == false {
                imageName = "other"
            } else {
                imageName = "other_pink"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移。
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        self.navigationController?.pushViewController(nextView, animated: true)
        //ここで変えないと行けなさそう
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
        if lunchBool == false {
            //filterおん。lunchのみ表示される
            lunchBool = true
            dinnerBool = false
            cafeBool = false
            otherBool = false
            filterMode = true
            filterArray = realm.objects(Info.self).filter("genre == 0")
            table.reloadData()
            let image = UIImage(named: "lunch_pink")
            lunchButton.setBackgroundImage(image, for: .normal)
            print(filterArray!)
        } else {
            lunchBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    @IBAction func dinner(_ sender: Any) {
        if dinnerBool == false {
            //filterおん。lunchのみ表示される
            dinnerBool = true
            filterMode = true
            lunchBool = false
            cafeBool = false
            otherBool = false
            filterArray = realm.objects(Info.self).filter("genre == 1")
            let image = UIImage(named: "dinner_pink")
            dinnerButton.setBackgroundImage(image, for: .normal)
            table.reloadData()
        } else {
            dinnerBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    @IBAction func cafe(_ sender: Any) {
        if cafeBool == false {
            //filterおん。lunchのみ表示される
            cafeBool = true
            filterMode = true
            lunchBool = false
            dinnerBool = false
            otherBool = false
            filterArray = realm.objects(Info.self).filter("genre == 2")
            table.reloadData()
        } else {
            cafeBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    @IBAction func other(_ sender: Any) {
        if otherBool == false {
            //filterおん。lunchのみ表示される
            otherBool = true
            filterMode = true
            lunchBool = false
            dinnerBool = false
            cafeBool = false
            filterArray = realm.objects(Info.self).filter("genre == 3")
            table.reloadData()
        } else {
            otherBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    func filterOn() {
        //cellの数を指定する
        
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
