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
    
    var city: String!
    
    var sendNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let info = Info()
        
       // info.migration()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        map.delegate = self
        
        self.overrideUserInterfaceStyle = .dark
        
        locationManager.startUpdatingLocation()
        
        map.isZoomEnabled = true
        
        firstPin()
        
        //navigationの文字の色
    }
    
    override func viewWillAppear(_ animated: Bool) {
        map?.mapType = .standard
        //ピンを消すよ
        
        //使えてない。
        
        var savedInfo :[Info] = []
        for i in realm.objects(Info.self) {
            savedInfo.append(i)
        }
        
        
        
        
        //
        //        if map.annotations != nil {
        //            let annoView = MKAnnotationView()
        //            map.removeAnnotation(annoView.annotation!)
        //        }
        
    }
    
    func firstPin() {
        //  self.map?.removeAnnotation(test)
        var savedInfo :[Info] = []
        for i in realm.objects(Info.self) {
            savedInfo.append(i)
        }
        print("ピンを立てます", savedInfo)
        //ピンを立てるよ
        savedInfo.forEach { savedInfo in
            
            let test = ImageMKPointAnnotation()
            
            switch savedInfo.genre {
            case 0:
                test.pinImage = "pin_lunch"
            case 1:
                test.pinImage = "pin_dinner"
            case 2:
                test.pinImage = "pin_cafe"
            case 3:
                test.pinImage = "pin_other"
            default:
                test.pinImage = "pin_other"
                
            }
            test.coordinate = CLLocationCoordinate2DMake(savedInfo.latitude, savedInfo.longitude)
            
            self.map?.addAnnotation(test)
        }
    }
    
    //CLLocationの位置情報を取得するときの関数
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            CLGeocoder().reverseGeocodeLocation(locationManager.location!) { placemarks, error in
                guard
                    let placemark = placemarks?.first, error == nil,
                    let locality = placemark.locality
                else {
                    return
                }
                self.city = locality
            }
            
            my_latitude = locationManager.location?.coordinate.latitude
            my_longitude = locationManager.location?.coordinate.longitude
            
        }
    }
    @IBAction func now(_ sender: Any) {
        getNowLocation()
    }
    
    func getNowLocation() {
        let cr = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        map?.setRegion(cr, animated: true)
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
            manager.requestWhenInUseAuthorization()// 許可を求める
        case .restricted, .denied:// 拒否されてる場合
            break// 何もしない
            
        case .authorizedWhenInUse: // 許可されている場合
            manager.startUpdatingLocation()// 現在地の取得を開始
            getNowLocation()
            //市町村を取得
            CLGeocoder().reverseGeocodeLocation(locationManager.location!) { placemarks, error in
                guard
                    let placemark = placemarks?.first, error == nil,
                    let locality = placemark.locality
                else {
                    
                    return
                }
                self.city = locality
                
            }
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
    
    //ピンをタップ
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if annotation is MKUserLocation {
                
            } else {
                
                //まずは、同じstororyboard内であることをここで定義します
                let storyboard: UIStoryboard = self.storyboard!
                //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
                let detailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
                detailVC.recievedLatitude = annotation.coordinate.latitude
                
                detailVC.recievedLongitude = annotation.coordinate.longitude
                
                
                navigationController?.pushViewController(detailVC, animated: true)
            }
            
        }
    }
    //ピンを立てるメソッド
    //ボタンを押されたら呼ばれる
    func putpin() {
        pinImageSelect()
        /*
         locationManager.startUpdatingLocation()
         let cr = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
         map?.setRegion(cr, animated: true)
         */
        //市町村
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let locality = placemark.locality
            else {
                return
            }
            self.city = locality
        }
        
        //ピンを生成
        /*
         let annotation = MKPointAnnotation()
         annotation.coordinate = CLLocationCoordinate2DMake(my_latitude, my_longitude)
         //annotation.coordinate = CLLocationCoordinate2DMake(2345.222222, 8587463)
         self.map.addAnnotation(annotation)
         */
        //保存処理
        let info = Info()
        if let last = realm.objects(Info.self).sorted(byKeyPath: "id",ascending: true).last {
            info.id = last.id + 1
            try! realm.write {
                
                info.latitude = my_latitude
                info.longitude = my_longitude
                info.genre = recievedGenre
                info.city = city
                info.regDate = Date()
                 info.trial = "ho"
                realm.add(info)
                print(realm.objects(Info.self))
                
            }
        } else {
            info.id = 0
            info.latitude = my_latitude
            info.longitude = my_longitude
            info.genre = recievedGenre
            info.city = city
            info.regDate = Date()
            
            try! realm.write {
                realm.add(info)
            }
            print(realm.objects(Info.self))
        }
    }
    
    //ピンにセットする画像を決める
    func pinImageSelect() {
        if let recievedGenre = recievedGenre {
            let  test = ImageMKPointAnnotation()
            switch recievedGenre {
            case 0:
                test.pinImage = "pin_lunch"
            case 1:
                test.pinImage = "pin_dinner"
            case 2:
                test.pinImage = "pin_cafe"
            case 3:
                test.pinImage = "pin_other"
            default:
                pinImage = "pin_other"
            }
            test.coordinate = CLLocationCoordinate2DMake(my_latitude, my_longitude)
            //annotationだった
            self.map.addAnnotation(test)
        }
    }
    //mapのピンのデザイン
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else if let test = annotation as? ImageMKPointAnnotation {
            //pinImageSelect()
            
            let annoView = MKPinAnnotationView()
            
            //annoView.annotation = annotation
            annoView.image = UIImage(named: test.pinImage)
            
            return annoView
        } else {
            
            return nil
        }
    }
    
    @IBAction func goList(_ sender: Any) {
        var savedInfo :[Info] = []
        for i in realm.objects(Info.self) {
            savedInfo.append(i)
        }
        print("現在地",savedInfo)
        
        savedInfo.forEach { savedInfo in
            let test = ImageMKPointAnnotation()
            /*
             switch savedInfo.genre {
             case 0:
             test.pinImage = "pin_lunch"
             case 1:
             test.pinImage = "pin_dinner"
             case 2:
             test.pinImage = "pin_cafe"
             case 3:
             test.pinImage = "pin_other"
             default:
             test.pinImage = "pin_other"
             
             }
             */
            
            test.coordinate = CLLocationCoordinate2DMake(savedInfo.latitude, savedInfo.longitude)
            print(test.coordinate)
            self.map.removeAnnotation(test)
        }
        //画面遷移。
        //let storyboard: UIStoryboard = self.storyboard!
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListViewController
        // let nextView = storyboard.instantiateViewController(withIdentifier: "goList") as! DetailViewController
        self.navigationController?.pushViewController(nextView, animated: true)
        
        
    }
    
}

