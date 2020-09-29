//
//  LocationViewController.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/23.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var myLocationManager: CLLocationManager!
    var myTimer: Timer!
    
    var latitudeNow: String!
    var longitudeNow: String!
    var timeNow: String!
    
    let cellIdentifier = "Cell"
    
    var userDefaults = UserDefaults.standard
    var locations = [[String]]()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        //locationUpdate()
        
        //位置情報取得の設定
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.distanceFilter = 10
        
        // バックグラウンドでの位置情報更新を許可
        myLocationManager.allowsBackgroundLocationUpdates = true
        
        // 初回起動時(位置情報サービス利用許可が設定されていない時)、許可を求めるダイアログを表示
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }
        
        
        //
        locations = userDefaults.array(forKey: "位置情報") as? [[String]] ?? [[String]]()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        startButton.isEnabled = true
        stopButton.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LocationCell
        
        cell.timeLabel.text = locations[indexPath.row][0] ?? "nil"
        cell.latitudeLabel.text = locations[indexPath.row][1] ?? "nil"
        cell.longitudeLabel.text = locations[indexPath.row][2] ?? "nil"
        
        return cell
        
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
    
    @objc func locationUpdate() {
        
        // 位置情報更新　ストップしてスタート
        myLocationManager.stopUpdatingLocation()
        myLocationManager.startUpdatingLocation()
        
        locations.append([timeNow ?? "", latitudeNow ?? "", longitudeNow ?? ""])
        userDefaults.set(locations, forKey: "位置情報")
        
        self.timeLabel.text = timeNow ?? ""
        latitudeLabel.text = latitudeNow ?? ""
        longitudeLabel.text = longitudeNow ?? ""
        
        self.tableView.reloadData()
        
        //locations.append(latitudeNow!)
        //locations.append(longitudeNow)
        
    }
    // 位置情報が更新されるたびに呼び出されるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        latitudeNow = String(latitude!)
        longitudeNow = String(longitude!)
        // 今の時間
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmmss", options: 0, locale: Locale(identifier: "ja_JP"))
        timeNow = dateFormatter.string(from: date)
        
    }
    
    @IBAction func pressClearButton(_ sender: Any) {
        userDefaults.removeObject(forKey: "位置情報")
        locations.removeAll()
        tableView.reloadData()
        
    }
    
    @IBAction func pressReloadButton(_ sender: Any) {
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func pressStartButton(_ sender: Any) {
        
        // ５秒ごとにlocationUpdate()を実行する
        myTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(locationUpdate), userInfo: nil, repeats: true)
        myTimer.fire()
        
        startButton.isEnabled = false
        stopButton.isEnabled = true
        
    }
    
    @IBAction func pressStopButton(_ sender: Any) {
        //myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(locationUpdate), userInfo: nil, repeats: true)
        myTimer.invalidate()
        
        startButton.isEnabled = true
        stopButton.isEnabled = false
        
    }
}
