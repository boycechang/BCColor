//
//  GradientViewController.swift
//  BCColorDemo
//
//  Created by Boyce on 4/13/16.
//  Copyright © 2016 Boyce. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {

    @IBOutlet fileprivate weak var label_0: UILabel!
    @IBOutlet fileprivate weak var label_1: UILabel!
    
    @IBOutlet fileprivate weak var view_0: UIView!
    @IBOutlet fileprivate weak var view_1: UIView!
    @IBOutlet fileprivate weak var view_2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        label_0.textColor = UIColor.gradientColor(CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0), frame: label_0.frame, colors: [UIColor.red, UIColor.blue])
        label_1.backgroundColor = UIColor.gradientColor(CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5), frame: label_1.frame, colors: [UIColor.blue, UIColor.yellow])
        view_0.backgroundColor = UIColor.gradientColor(CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0), frame: view_0.frame, colors: [UIColor.red, UIColor.blue])
        view_1.backgroundColor = UIColor.gradientColor(CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5), frame: view_1.frame, colors: [UIColor.blue, UIColor.yellow, UIColor.red,UIColor.green])
        view_2.backgroundColor = UIColor.radialGradientColor(view_2.frame, colors: [UIColor.blue, UIColor.yellow, UIColor.red,UIColor.green])
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
