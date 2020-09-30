//
//  LocationService.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/29.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

//import Foundation
import UIKit
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = LocationService()
    var locationManager: CLLocationManager!
    var locationDataArray: [CLLocation]
    var useFilter: Bool
    
    var latitude = "hennenenene"
    var longitude: String?
    var time: String?
    
    
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        //locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = false
        locationDataArray = [CLLocation]()
        
        useFilter = true
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func getLocation() {
        
        // 位置情報更新　ストップしてスタート
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 緯度経度
        let location = locations.first
        let latestLatitude = location?.coordinate.latitude
        let latestLongitude = location?.coordinate.longitude
        latitude = String(latestLatitude!)
        longitude = String(latestLongitude!)
        
        // 時間
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd 'at' HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        time = dateFormatter.string(from: date)
        
    }
    
    
    
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    
//    //MARK: CLLocationManagerDelegate protocol methods
//    public func locationManager(_ manager: CLLocationManager,
//                                didUpdateLocations locations: [CLLocation]){
//
//        if let newLocation = locations.last{
//            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
//
//            var locationAdded: Bool
//            if useFilter{
//                locationAdded = filterAndAddLocation(newLocation)
//            }else{
//                locationDataArray.append(newLocation)
//                locationAdded = true
//            }
//
//
//            if locationAdded{
//                notifiyDidUpdateLocation(newLocation: newLocation)
//            }
//
//        }
//    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool{
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10{
            print("Locaiton is old.")
            return false
        }
        
        if location.horizontalAccuracy < 0{
            print("Latitidue and longitude values are invalid.")
            return false
        }
        
        if location.horizontalAccuracy > 100{
            print("Accuracy is too low.")
            return false
        }
        
        print("Location quality is good enough.")
        locationDataArray.append(location)
        
        return true
        
    }
    
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error){
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
            //User denied your app access to location information.
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            //You can resume logging by calling startUpdatingLocation here
            startUpdatingLocation()
        }
    }
    
    func showTurnOnLocationServiceAlert(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
    
    func notifiyDidUpdateLocation(newLocation:CLLocation){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
    }
}
