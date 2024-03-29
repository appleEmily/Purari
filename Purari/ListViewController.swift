//
//  ListViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/06.
//

import UIKit
import RealmSwift
import Foundation
import CoreLocation

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
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
    
    var genreFilter: Int!
    
    var lunchBool: Bool = false
    var dinnerBool:Bool = false
    var cafeBool: Bool = false
    var otherBool: Bool = false
    var filterMode: Bool = false
    
    //お気に入りボタンのためのbool値
    var likeBool: Bool = false
    
    //UINavigationBarに設置するボタン
    var backButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        data = realm.objects(Info.self).sorted(byKeyPath: "id")
        
        table.reloadData()
        
        //多分ここ要らない
        
        var savedInfo :[Info] = []
        for i in realm.objects(Info.self) {
            savedInfo.append(i)
        }
        savedInfo.forEach { savedInfo in
            print(savedInfo, "最新のinfo")
            
            let test = ImageMKPointAnnotation()
            
            test.coordinate = CLLocationCoordinate2DMake(savedInfo.latitude, savedInfo.longitude)
            
            //ここで、ひとまず全部のピンを消してあげられたらいい。
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let mapVC = storyboard.instantiateViewController(withIdentifier: "MapVC") as! ViewController
            
            mapVC.map?.removeAnnotation(test)
            
        }
        
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
    //こいつじゃだめ。
    /*
     override func viewWillDisappear(_ animated: Bool) {
     //ここで、ひとまず全部のピンを消してあげられたらいい。
     let storyboard: UIStoryboard = self.storyboard!
     //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
     let mapVC = storyboard.instantiateViewController(withIdentifier: "MapVC")
     
     let test = ImageMKPointAnnotation()
     mapVC.map.removeAnnotation(test)
     ViewController().firstPin()
     }
     */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        
        //お気に入りボタンをクリック
        cell.likeButton.addTarget(self, action: #selector(likeTouped(_:)), for: .touchUpInside)
        cell.likeButton.tag = indexPath.row
        
        //print(data)
        //ここで分岐が必要！filterModeを使う。
        if filterMode == false {
            cell.nameLabel.text = String(data[indexPath.row].name)
            cell.cityLabel.text = data[indexPath.row].city
            genre = data[indexPath.row].genre
            if data[indexPath.row].likeBool == true {
                cell.likeButton.setImage(UIImage(named: "heart_true"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "heart_false"), for: .normal)
            }
        } else {
            
            cell.nameLabel.text = String(filterArray[indexPath.row].name)
            cell.cityLabel.text = filterArray[indexPath.row].city
            genre = filterArray[indexPath.row].genre
            
            if filterArray[indexPath.row].likeBool == true {
                cell.likeButton.setImage(UIImage(named: "heart_true"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(named: "heart_false"), for: .normal)
            }
            
        }
        setImage()
        cell.genreImage.image = UIImage(named: imageName)
        
        //UI
        cell.mainBackground.layer.cornerRadius = 10.0
        cell.mainBackground.layer.masksToBounds = true
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        // cell.backgroundColor = .white
        cell.backgroundColor = UIColor.clear
        
        
        return cell
    }
    
    //likeボタンを押された時の処理。
    @objc func likeTouped(_ sender: UIButton) {
        
        //likeButton.setImage(UIImage(named: "heart_true"), for: .normal)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(indexPath.row)
        let data = realm.objects(Info.self)[indexPath.row]
        
        if let cell = table.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ListTableViewCell {
            if likeBool == false {
                likeBool = true
                cell.likeButton.setImage(UIImage(named: "heart_true"), for: .normal)
            } else {
                likeBool = false
                cell.likeButton.setImage(UIImage(named: "heart_false"), for: .normal)
            }
        }
        
        
        try! realm.write {
            data.setValue(likeBool, forKey: "likeBool")
        }
        print(data)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移。
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        nextView.filter = filterMode
        nextView.recievedNumber = indexPath.row
        nextView.filterGenre = genreFilter
        self.navigationController?.pushViewController(nextView, animated: true)
        
        table.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if filterMode == false {
                try! realm.write{
                    realm.delete(data[indexPath.row])
                }
            } else {
                try! realm.write{
                    realm.delete(filterArray[indexPath.row])
                }
                
            }
            table.reloadData()
            print("最新のInfo", realm.objects(Info.self))
            //            let view = ViewController.self as! ViewController
        } else {
            
        }
        
    }
    
    @IBAction func lunch(_ sender: Any) {
        
        if lunchBool == false {
            genreFilter = 0
            //filterおん。lunchのみ表示される
            lunchBool = true
            dinnerBool = false
            cafeBool = false
            otherBool = false
            filterMode = true
            filterArray = realm.objects(Info.self).filter("genre == 0")
            lunchButton.setBackgroundImage(UIImage(named: "lunch_pink"), for: .normal)
            dinnerButton.setBackgroundImage(UIImage(named: "dinner"), for: .normal)
            cafeButton.setBackgroundImage(UIImage(named: "cafe"), for: .normal)
            otherButton.setBackgroundImage(UIImage(named: "other"), for: .normal)
            table.reloadData()
        } else {
            resetFilterImage()
            lunchBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    @IBAction func dinner(_ sender: Any) {
        
        if dinnerBool == false {
            genreFilter = 1
            //filterおん。lunchのみ表示される
            dinnerBool = true
            filterMode = true
            lunchBool = false
            cafeBool = false
            otherBool = false
            filterArray = realm.objects(Info.self).filter("genre == 1")
            dinnerButton.setBackgroundImage(UIImage(named: "dinner_pink"), for: .normal)
            lunchButton.setBackgroundImage(UIImage(named: "lunch"), for: .normal)
            cafeButton.setBackgroundImage(UIImage(named: "cafe"), for: .normal)
            otherButton.setBackgroundImage(UIImage(named: "other"), for: .normal)
            table.reloadData()
        } else {
            resetFilterImage()
            dinnerBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    @IBAction func cafe(_ sender: Any) {
        if cafeBool == false {
            genreFilter = 2
            //filterおん。lunchのみ表示される
            cafeBool = true
            filterMode = true
            lunchBool = false
            dinnerBool = false
            otherBool = false
            filterArray = realm.objects(Info.self).filter("genre == 2")
            cafeButton.setBackgroundImage(UIImage(named: "cafe_pink"), for: .normal)
            lunchButton.setBackgroundImage(UIImage(named: "lunch"), for: .normal)
            dinnerButton.setBackgroundImage(UIImage(named: "dinner"), for: .normal)
            otherButton.setBackgroundImage(UIImage(named: "other"), for: .normal)
            table.reloadData()
        } else {
            resetFilterImage()
            cafeBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    @IBAction func other(_ sender: Any) {
        
        if otherBool == false {
            genreFilter = 3
            //filterおん。lunchのみ表示される
            otherBool = true
            filterMode = true
            lunchBool = false
            dinnerBool = false
            cafeBool = false
            filterArray = realm.objects(Info.self).filter("genre == 3")
            otherButton.setBackgroundImage(UIImage(named: "other_pink"), for: .normal)
            lunchButton.setBackgroundImage(UIImage(named: "lunch"), for: .normal)
            dinnerButton.setBackgroundImage(UIImage(named: "dinner"), for: .normal)
            cafeButton.setBackgroundImage(UIImage(named: "cafe"), for: .normal)
            table.reloadData()
        } else {
            resetFilterImage()
            otherBool = false
            filterMode = false
            table.reloadData()
        }
    }
    
    func resetFilterImage() {
        lunchButton.setBackgroundImage(UIImage(named: "lunch"), for: .normal)
        dinnerButton.setBackgroundImage(UIImage(named: "dinner"), for: .normal)
        cafeButton.setBackgroundImage(UIImage(named: "cafe"), for: .normal)
        otherButton.setBackgroundImage(UIImage(named: "other"), for: .normal)
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
