//
//  ViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/03.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    // 取得した緯度を保持するインスタンス
    var my_latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var my_longitude: CLLocationDegrees!
    
    //realm
    let realm = try! Realm()
    
    var recievedGenre: Int!
    
    var pinImage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        map.delegate = self
        
        self.overrideUserInterfaceStyle = .dark
        
        //navigationの文字の色
    }
    
    override func viewWillAppear(_ animated: Bool) {
        map?.mapType = .standard
        
        //ピン立てるよ
        var savedInfo :[Info] = []
        for i in realm.objects(Info.self) {
            savedInfo.append(i)
        }
        print(savedInfo)
        //ピンを立てるよ
        savedInfo.forEach { savedInfo in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(savedInfo.latitude, savedInfo.longitude)
            
            self.map.addAnnotation(annotation)
            
        }
        
    }
    
    //CLLocationの位置情報を取得するときの関数
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let cr = MKCoordinateRegion(center: location.coordinate, latitudinalMeters:  400, longitudinalMeters: 400)
            map?.setRegion(cr, animated: true)
            
            my_latitude = locationManager.location?.coordinate.latitude
            my_longitude = locationManager.location?.coordinate.longitude
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(my_latitude, my_longitude)
            map.addAnnotation(pin)
            print("現在地緯度経度")
            print(my_latitude!,my_longitude!)
        }
    }
    
    @IBAction func genreOpen(_ sender: Any) {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = self.storyboard!
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let genreSelect = storyboard.instantiateViewController(withIdentifier: "Genre")
        genreSelect.sheetPresentationController?.detents = [.medium()]
        genreSelect.sheetPresentationController?.preferredCornerRadius = 28
        //ここが実際に移動するコードとなります
        self.present(genreSelect, animated: true, completion: nil)
    }
    
    //map許可
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {// 許可を求めるためのdelegateメソッド
        switch status {
        case .notDetermined:// 許可されてない場合
            manager.requestAlwaysAuthorization()// 許可を求める
        case .restricted, .denied:// 拒否されてる場合
            break// 何もしない
        case .authorizedAlways, .authorizedWhenInUse: // 許可されている場合
            manager.startUpdatingLocation()// 現在地の取得を開始
            break
        default:
            break
        }
    }
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // この例ではLogにErrorと表示するだけ．
        //アラート　位置情報をオンにしてください。って出す
        NSLog("Error")
    }
    
    func myPlace() {
        //現在地
        locationManager.startUpdatingLocation()
        //let cr = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        //map?.setRegion(cr, animated: true)
        
        my_latitude = locationManager.location?.coordinate.latitude
        my_longitude = locationManager.location?.coordinate.longitude
        print("現在地緯度経度")
        print(my_latitude!,my_longitude!)
        
    }
    //mapをタップ
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation{
            print("ピンをタップ！")
            //まずは、同じstororyboard内であることをここで定義します
            let storyboard: UIStoryboard = self.storyboard!
            //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "Detail")
            
            navigationController?.pushViewController(detailVC, animated: true)
            
        }
    }
    //ピンを立てるメソッド
    //ボタンを押されたら呼ばれる
    func putpin() {
        myPlace()
        //ピンを生成
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(my_latitude, my_longitude)
        self.map.addAnnotation(annotation)
        //保存処理
        let info = Info()
        if let last = realm.objects(Info.self).sorted(byKeyPath: "id",ascending: true).last {
            info.id = last.id + 1
            try! realm.write {
                
                info.latitude = my_latitude
                info.longitude = my_longitude
                info.genre = recievedGenre
                realm.add(info)
                print(realm.objects(Info.self))
                
            }
        } else {
            info.id = 0
            info.latitude = my_latitude
            info.longitude = my_longitude
            info.genre = recievedGenre
            try! realm.write {
                realm.add(info)
            }
            print(realm.objects(Info.self))
        }
    }
    
    //ピンにセットする画像を決める
    func pinImageSelect() {
        switch recievedGenre {
        case 0:
            pinImage = "pin_lunch"
        case 1:
            pinImage = "pin_dinner"
        case 2:
            pinImage = "pin_cafe"
        case 3:
            pinImage = "pin_other"
        default:
            pinImage = "pin_other"
        }
    }
    
    //mapのピンのデザイン
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        pinImageSelect()
        let annoView = MKPinAnnotationView()
        annoView.annotation = annotation
        annoView.image = UIImage(named: pinImage)
        
        return annoView
    }
    
    @IBAction func goList(_ sender: Any) {
        //画面遷移。
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "goList") as! DetailViewController
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}

