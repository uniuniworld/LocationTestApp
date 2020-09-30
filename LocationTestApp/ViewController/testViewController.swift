//
//  testViewController.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/29.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    var text: String?
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = text
        //testLabel.backgroundColor = .brown
        testLabel.layer.cornerCurve = .continuous
        
        //sendButton.backgroundColor = .blue
        sendButton.layer.cornerCurve = .continuous

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressButton(_ sender: Any) {
        
        let location = LocationService()
        location.getLocation()
        print("緯度：\(location.latitude ?? "")")
        print("経度：\(String(describing: location.longitude))")
        print("時間：\(location.time)")
        
        
        
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