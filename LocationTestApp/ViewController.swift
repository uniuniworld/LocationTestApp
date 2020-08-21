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
    
    var latitudeNow: String = ""
    var longitudeNow: String = ""
    
    @IBOutlet weak var timerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocationManager = CLLocationManager()
        
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


}

