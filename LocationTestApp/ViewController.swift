//
//  ViewController.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/08/20.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var myLocationManager: CLLocationManager!
    
    var myTimer: Timer!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    var latitudeNow: String = ""
    var longitudeNow: String = ""
    
    
    @IBOutlet weak var timerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerCountLabel.text = "ok"
        
        // ロケーションマネージャーのセットアップ
        setupLocationManager()
        
        //　位置情報取得の設定
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.distanceFilter = 50

        // バックグラウンドでの位置情報更新を許可
        myLocationManager.allowsBackgroundLocationUpdates = true

        // 初回起動時(位置情報サービス利用許可が設定されていない時)、許可を求めるダイアログを表示
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }

        // 10秒ごとにlocationUpdate()を実行する
        myTimer = Timer.scheduledTimer(timeInterval: Double(5), target: self, selector: #selector(locationUpdate), userInfo: nil, repeats: true)
        myTimer.fire()

        
        
    }
    
    // Timerでループ実行する処理
    @objc func locationUpdate() {
        // 画面のループ処理回数の表示をカウントアップ
        var count: Int = Int(timerCountLabel.text!)!
        count += 1

        // stop -> start で位置情報更新させる
        myLocationManager.stopUpdatingLocation()
        myLocationManager.startUpdatingLocation()

        timerCountLabel.text = String(count)

        // コンソールでバックグラウンドでの処理実行が確認しやすいよう、現在時刻を出力
        let dt = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))

        print(dateFormatter.string(from: dt))
        print(count)
    }
    
    func setupLocationManager() {
        myLocationManager = CLLocationManager()
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
    
    // 位置情報が更新されるたびに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        latitudeNow = String(latitude!)
        longitudeNow = String(longitude!)
    }
    
    
    @IBAction func getLocationInfo(_ sender: Any) {
        
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
            print("alert")
        } else if status == .authorizedWhenInUse {
            latitudeLabel.text = latitudeNow
            print("緯度" + latitudeNow)
            longitudeLabel.text = longitudeNow
            print("経度" + longitudeNow)
        }
    }
    
    @IBAction func clearLabel(_ sender: Any) {
        latitudeLabel.text = "緯度"
        longitudeLabel.text = "経度"
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
    
}

