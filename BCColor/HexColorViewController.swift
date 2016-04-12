//
//  HexColorViewController.swift
//  BCColorDemo
//
//  Created by Boyce on 4/12/16.
//  Copyright © 2016 Boyce. All rights reserved.
//

import UIKit

class HexColorViewController: UIViewController {

    @IBOutlet private weak var label_1: UILabel!
    @IBOutlet private weak var view_1: UIView!
    
    @IBOutlet private weak var label_2: UILabel!
    @IBOutlet private weak var view_2: UIView!
    
    @IBOutlet private weak var label_3: UILabel!
    @IBOutlet private weak var view_3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label_1.text = "123456"
        view_1.backgroundColor = UIColor.colorWithHex("123456")
        
        label_2.text = "#5d13e2"
        view_2.backgroundColor = UIColor.colorWithHex("#5d13e2", alpha: 1)
        
        label_3.text = "#931"
        view_3.backgroundColor = UIColor.colorWithHex("#931", alpha: 1)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
