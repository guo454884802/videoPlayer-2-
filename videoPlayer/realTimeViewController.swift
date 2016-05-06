//
//  realTimeViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/12/25.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import SafariServices

class realTimeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageBackground: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.borderColor = UIColor.redColor().CGColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButton(sender: UIButton) {
        
        
        let url = NSURL(string: "http://mudu.tv/?a=index&c=show&id=3351&type=mobile")
        let safariController = SFSafariViewController(URL: url!, entersReaderIfAvailable: true)
        presentViewController(safariController, animated: true, completion: nil)
        
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
        safariController.view.transform = transform
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
