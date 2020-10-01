//
//  testViewController.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/29.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class testViewController: UIViewController {
    
    var db: Firestore!
    var text: String?
    fileprivate var array = [[String]]()
    
    let cellIdentifier = "Cell"
    @IBOutlet weak var tableView: UITableView!
    var rowIndex: Int?
    
    //var array = AppDelegate().array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFirestore()
        
        tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        getDocuments()
        //tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pressButton(_ sender: Any) {
        getDocuments()
        tableView.reloadData()
//        db.collection("location").order(by: "time").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    let ary = [
//                        document.data()["latitude"] as! String,
//                        document.data()["longitude"] as! String,
//                        document.data()["time"] as! String
//                    ]
//                    self.array.append(ary)
//                }
//                print(self.array)
//            }
//        }
    }
    
    func setupFirestore() {
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        
        db = Firestore.firestore()
    }
    
    func getDocuments() {
        db.collection("location").order(by: "time").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.array.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let ary = [
                        document.data()["latitude"] as! String,
                        document.data()["longitude"] as! String,
                        document.data()["time"] as! String
                    ]
                    self.array.append(ary)
                }
                print(self.array)
            }
        }
        tableView.reloadData()
    }
    
}

extension testViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LocationCell
        
        cell.latitudeLabel.text = ("緯度：\(array[indexPath.row][0])")
        cell.longitudeLabel.text = ("経度：\(array[indexPath.row][1])")
        cell.timeLabel.text = ("\(array[indexPath.row][2])")
        
        return cell
    }
}

extension testViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(array[indexPath.row])
        rowIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            guard let destination = segue.destination as? MapViewController else {
                fatalError("Failed to prepare DetailViewController.")
            }
            
            destination.latitude = Double(array[rowIndex!][0])!
            destination.longitude = Double(array[rowIndex!][1])!
            destination.time = array[rowIndex!][2]
        }
    }
}

//curl --header "Authorization: key=AAAAn_W1s6o:APA91bEsBT93maB0O5oK9A-wTa_vwgGgx5StU4PIySjk6Hl2WLdde4Y6Tni2e5pwJDNS4J6ZRhN2lv_bzK5RrRSS-2EfMb1trr1fBYBhWdDop3WisKmMdbqcn8CVoT_j9BFS9A7tiveF" --header Content-Type:"application/json" https://fcm.googleapis.com/fcm/send -d "{\"to\": \"/topics/ios\",\"content_available\":true}"
