//
//  PickColorsFromImageViewController.swift
//  BCColorDemo
//
//  Created by Boyce on 3/24/16.
//  Copyright © 2016 Boyce. All rights reserved.
//

import UIKit

class PickColorsFromImageViewController: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    @IBOutlet fileprivate weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let colors = imageView.image?.getColors() {
            self.view.backgroundColor = colors.backgroundColor
            titleLabel.textColor = colors.primaryColor
            subtitleLabel.textColor = colors.secondaryColor
            detailLabel.textColor = colors.minorColor
        }
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
