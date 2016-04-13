//
//  PickColorsFromImageViewController.swift
//  BCColorDemo
//
//  Created by Boyce on 3/24/16.
//  Copyright © 2016 Boyce. All rights reserved.
//

import UIKit

class PickColorsFromImageViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colors = imageView.image?.bc_getColors()
        view.backgroundColor = colors?.backgroundColor
        titleLabel.textColor = colors?.primaryColor
        subtitleLabel.textColor = colors?.secondaryColor
        detailLabel.textColor = colors?.minorColor
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
