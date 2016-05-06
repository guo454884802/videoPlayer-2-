//
//  webViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/12/24.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    
    @IBOutlet var webView:UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: "http://mudu.tv/?a=index&c=show&id=3351&type=mobile"){
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }

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
