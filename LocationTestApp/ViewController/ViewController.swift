//
//  ViewController.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/08/20.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {

    var myLocationManager: CLLocationManager!
    
    var db: Firestore!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    var latitude: String = ""
    var longitude: String = ""
    var time: String = ""
    
    
    @IBOutlet weak var timerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerCountLabel.text = "ok"
        
        // ロケーションマネージャーのセットアップ
        setupLocationManager()
        
        setupFirestore()
        
    }
    
    func setupLocationManager() {
        myLocationManager = CLLocationManager()
        //　位置情報取得の設定
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.distanceFilter = 10

        // バックグラウンドでの位置情報更新を許可
        myLocationManager.allowsBackgroundLocationUpdates = true

        // 初回起動時(位置情報サービス利用許可が設定されていない時)、許可を求めるダイアログを表示
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }
        // 位置情報取得許可ダイアログ表示
        guard let myLocationManager = myLocationManager else { return }
        myLocationManager.requestWhenInUseAuthorization()
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            myLocationManager.delegate = self
            myLocationManager.startUpdatingLocation()
        }
    }
    
    func setupFirestore() {
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        
        db = Firestore.firestore()
    }
    
    // 位置情報が更新されるたびに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latestLatitude = location?.coordinate.latitude
        let latestLongitude = location?.coordinate.longitude
        // 位置情報を格納する
        latitude = String(latestLatitude!)
        longitude = String(latestLongitude!)
        // 時間
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd 'at' HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        time = dateFormatter.string(from: date)
        
    }
    
    
    @IBAction func getLocationInfo(_ sender: Any) {
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
            print("alert")
        } else if status == .authorizedWhenInUse {
            latitudeLabel.text = "緯度：\(latitude)"
            longitudeLabel.text = "経度：\(longitude)"
            print("緯度" + latitude)
            print("経度" + longitude)
        }
    }
    
    @IBAction func clearLabel(_ sender: Any) {
        latitudeLabel.text = "緯度"
        longitudeLabel.text = "経度"
        
        latitude = ""
        longitude = ""
        
        print("clear")
    }
    
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle:  UIAlertController.Style.alert
        )
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        // UIAlertController に Action を追加
        alert.addAction(defaultAction)
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pressButton(_ sender: Any) {
        
        // stop -> start で位置情報更新させる
        myLocationManager.stopUpdatingLocation()
        myLocationManager.startUpdatingLocation()
        
        print(latitude)
        
        // Add a new document
        var ref: DocumentReference? = nil
        
        ref = db.collection("location").addDocument(data: [
            "latitude": latitude,
            "longitude": longitude,
            "time": time
        ]) { error in
            if let error = error {
                print("error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }
}

