//
//  ViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/03.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView? = MKMapView()
    
    var locationManager = CLLocationManager()
    // 取得した緯度を保持するインスタンス
    var my_latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var my_longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
//        map?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //前の画面から戻ってきたことを検知
//        presentingViewController?.beginAppearanceTransition(true, animated: animated)
//        presentingViewController?.endAppearanceTransition()
        
        locationManager.startUpdatingLocation()
        let cr = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        map?.setRegion(cr, animated: true)
        
        my_latitude = locationManager.location?.coordinate.latitude
        my_longitude = locationManager.location?.coordinate.longitude
        print("現在地緯度経度")
        print(my_latitude!,my_longitude!)
        
        //myPlace()
        map?.mapType = .standard
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
    //ピンを立てるメソッド
    //ボタンを押されたら呼ばれる
    func putpin() {
        myPlace()
        //ピンを生成
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(my_latitude, my_longitude)
        annotation.title = "タイトル"
        annotation.subtitle = "サブタイトル"
        self.map?.addAnnotation(annotation)
        print("呼ばれた")
    }
    
    func myPlace() {
        //現在地
        locationManager.startUpdatingLocation()
        let cr = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        map?.setRegion(cr, animated: true)
        
        my_latitude = locationManager.location?.coordinate.latitude
        my_longitude = locationManager.location?.coordinate.longitude
        print("現在地緯度経度")
        print(my_latitude!,my_longitude!)
        
    }
    
}

