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
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var my_latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var my_longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        my_latitude = locationManager.location?.coordinate.latitude
        my_longitude = locationManager.location?.coordinate.longitude
        print("現在地緯度経度")
//        print(my_latitude!,my_longitude!)
        
        //mapの表示する範囲
        let cr = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(cr, animated: true)
        
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
        NSLog("Error")
    }
    
    
    
}

