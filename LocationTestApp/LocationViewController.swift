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
    
    let cellIdentifier = "Cell"
    
    var userDefaults = UserDefaults.standard
    var locations = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //位置情報取得の設定
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        myLocationManager.distanceFilter = 10
        
        // バックグラウンドでの位置情報更新を許可
        myLocationManager.allowsBackgroundLocationUpdates = true

        // 初回起動時(位置情報サービス利用許可が設定されていない時)、許可を求めるダイアログを表示
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }

        // ５秒ごとにlocationUpdate()を実行する
        myTimer = Timer.scheduledTimer(timeInterval: Double(5), target: self, selector: #selector(locationUpdate), userInfo: nil, repeats: true)
        myTimer.fire()
        
        
        locations = userDefaults.array(forKey: "位置情報") as? [String] ?? []
        //locations.append("")
        userDefaults.set(locations, forKey: "位置情報")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LocationCell
        
        cell.latitudeLabel.text = locations[indexPath.row]
        cell.longitudeLabel.text = locations[indexPath.row]
        
        return cell
        
    }
    
    @objc func locationUpdate() {
        
        // 位置情報更新　ストップしてスタート
        myLocationManager.stopUpdatingLocation()
        myLocationManager.startUpdatingLocation()
        
        locations.append("s")
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
