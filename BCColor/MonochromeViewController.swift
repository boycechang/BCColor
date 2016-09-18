//
//  MonochromeViewController.swift
//  BCColorDemo
//
//  Created by Boyce on 4/13/16.
//  Copyright © 2016 Boyce. All rights reserved.
//

import UIKit

class MonochromeViewController: UIViewController {

    @IBOutlet fileprivate weak var originImageView: UIImageView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let monochromeImage = originImageView.image?.monochrome()
        imageView.image = monochromeImage
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
