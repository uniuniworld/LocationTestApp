//
//  MapViewController.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/10/01.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // 経度 緯度
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var time: String = ""
    
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let administrativeArea = placemark.administrativeArea, // 都道府県
                let locality = placemark.locality, // 市区町村
                let thoroughfare = placemark.thoroughfare, // 地名(丁目)
                let subThoroughfare = placemark.subThoroughfare, // 番地
                let postalCode = placemark.postalCode, // 郵便番号
                let location = placemark.location // 緯度経度情報

                else {
                    self.locationLabel.text = ""
                    return
            }
            self.address = "〒\(postalCode) \(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
            self.locationLabel.text = self.address
            
        }
        
        latitudeLabel.text = "緯度：\(String(latitude))"
        longitudeLabel.text = "経度：\(String(longitude))"
        timeLabel.text = "日時：\(time)"
        
        
        
        // 中心地
        var center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        // MapViewに中心点を設定.
        mapView.setCenter(center, animated: true)
        
        // 縮尺 表示領域
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let myRegion: MKCoordinateRegion = MKCoordinateRegion.init(center: center, span: mySpan)
        // MapViewにregionを追加
        mapView.region = myRegion
        
        // ピンを生成
        var myPin: MKPointAnnotation = MKPointAnnotation()
        // 座標を設定
        myPin.coordinate = center
        // タイトルを設定
        myPin.title = address
        // サブタイトルを設定
        myPin.subtitle = "緯度：\(latitude) 経度 \(longitude)"
        // MapViewにピンを追加.
        mapView.addAnnotation(myPin)
        
        
        
        // Do any additional setup after loading the view.
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
