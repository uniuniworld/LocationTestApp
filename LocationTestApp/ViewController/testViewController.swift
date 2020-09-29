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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = text

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
