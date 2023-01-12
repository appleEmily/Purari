//
//  DetailViewController.swift
//  Purari
//
//  Created by Emily Nozaki on 2022/03/07.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    var recievedLatitude: Double = 0.0
    var recievedLongitude: Double = 0.0
    var recievedNumber: Int!
    
    let realm = try! Realm()
    
    var genre: Int!
    var imageName: String!
    
    var filter: Bool = false
    var filterGenre: Int!
    
    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var whoText: UITextField!
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //イド受け取る
        if filter == false {
            if let recievedNumber = recievedNumber {
                let data = realm.objects(Info.self)[recievedNumber]
                genre = data.genre
                setImage()
                cityLabel.text = data.city
                nameText.text = data.name
                whoText.text = data.who
                commentView.text = data.comment
                genreImage.image = UIImage(named: imageName)
            } else {
                let selected = realm.objects(Info.self).filter{$0.latitude == self.recievedLatitude && $0.longitude == self.recievedLongitude}.first
                
                genre = selected?.genre
                setImage()
                cityLabel.text = selected?.city
                nameText.text = selected?.name
                whoText.text = selected?.who
                commentView.text = selected?.comment
                genreImage.image = UIImage(named: imageName)
                
            }
        } else {
            
            let data = realm.objects(Info.self).filter("genre == %@", filterGenre!)[recievedNumber]
            
            genre = data.genre
            setImage()
            cityLabel.text = data.city
            nameText.text = data.name
            whoText.text = data.who
            commentView.text = data.comment
            genreImage.image = UIImage(named: imageName)
        }
        //UI設定
        card.layer.cornerRadius = 10.0
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 10.0
        card.layer.shadowColor = UIColor.black.cgColor
        //UIColor(red: 186, green: 186, blue: 186, alpha: 0.25).cgColor
        card.layer.shadowOpacity = 0.25
        
        goButton.layer.cornerRadius = 10.0
        goButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        goButton.layer.shadowRadius = 12.0
        goButton.layer.shadowColor = UIColor.black.cgColor
        goButton.layer.shadowOpacity = 0.25
        
        nameText.setUnderLine()
        whoText.setUnderLine()
        
        commentView.layer.cornerRadius = 10.0
        
        self.overrideUserInterfaceStyle = .light
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.clear
        
        //キーボード
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(sender:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(sender:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        
        if let selected = realm.objects(Info.self).filter{$0.latitude == self.recievedLatitude && $0.longitude == self.recievedLongitude}.first {
            
        } else if let recievedNumber = recievedNumber {
            
            
        } else {
            
            goButton.isHidden = true
            //削除されたアラート表示
            let alert = UIAlertController(title: "既に削除されたピンです", message: "ピンは、一度アプリを閉じると消えます", preferredStyle: .alert)
            //ここから追加
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            //ここまで追加
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if filter == false {
            if let recievedNumber = recievedNumber {
                let data = realm.objects(Info.self)[recievedNumber]
                try! realm.write {
                    data.setValue(nameText.text!, forKey: "name")
                    data.setValue(whoText.text!, forKey: "who")
                    data.setValue(commentView.text!, forKey: "comment")
                }
            } else {
                let selected = realm.objects(Info.self).filter{$0.latitude == self.recievedLatitude && $0.longitude == self.recievedLongitude}.first
                
                try! realm.write {
                    selected?.setValue(nameText.text!, forKey: "name")
                    selected?.setValue(whoText.text!, forKey: "who")
                    selected?.setValue(commentView.text!, forKey: "comment")
                    
                }
            }
        } else {
            let data = realm.objects(Info.self).filter("genre == %@", filterGenre!)[recievedNumber]
            try! realm.write {
                data.setValue(nameText.text!, forKey: "name")
                data.setValue(whoText.text!, forKey: "who")
                data.setValue(commentView.text!, forKey: "comment")
            }
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func goHere(_ sender: Any) {
        var goLatitude: Double = 0.0
        var golongitude: Double = 0.0
        //navigationの画面遷移を書く。どこにいくのか、の値が渡される
        if let recievedNumber = recievedNumber {
            let data = realm.objects(Info.self)[recievedNumber]
            
            goLatitude = data.latitude
            golongitude = data.longitude
            
        } else {
            if let selected = realm.objects(Info.self).filter{$0.latitude == self.recievedLatitude && $0.longitude == self.recievedLongitude}.first {
                print("selected", (selected.latitude))
                goLatitude = (selected.latitude)
                golongitude = (selected.longitude)
            } else {
                
            }
            
        }
        let urlString: String!
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            urlString = "comgooglemaps://?daddr=\(goLatitude),\(golongitude)&directionsmode=walking&zoom=14"
            
            
        }
        else {
            urlString = "http://maps.apple.com/?daddr=\(goLatitude),\(golongitude)&dirflg=w"
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    // キーボードが表示された時
    @objc private func keyboardWillShow(sender: NSNotification) {
        if commentView.isFirstResponder {
            guard let userInfo = sender.userInfo else { return }
            let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
            UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -100)
                self.view.transform = transform
            })
        }
    }

    // キーボードが閉じられた時
    @objc private func keyboardWillHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
        UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}
extension UITextField {
    func setUnderLine() {
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height / 1.4, width: frame.width, height: 0.3)
        // 枠線の色
        underline.backgroundColor = .gray
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
extension Notification {
    
    // キーボードの高さ
    var keyboardHeight: CGFloat? {
        return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
    }
    
    // キーボードのアニメーション時間
    var keybaordAnimationDuration: TimeInterval? {
        return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    }
    
    // キーボードのアニメーション曲線
    var keyboardAnimationCurve: UInt? {
        return self.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    }
}
