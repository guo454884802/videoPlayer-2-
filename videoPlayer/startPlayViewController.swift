//
//  startPlayViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/11/21.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData

class startPlayViewController: UIViewController {
    
    var video:Video!
    var paths:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let urlStr = NSBundle.mainBundle().pathForResource("11", ofType: "mp4")
        let documentsDirectory = paths as NSString
        let url = NSURL.fileURLWithPath(documentsDirectory.stringByAppendingPathComponent(video.videoPath))
        let play1 = MPMoviePlayerViewController(contentURL: url)
        play1.moviePlayer.prepareToPlay()
        play1.view.frame = self.view.bounds
        play1.view.backgroundColor = UIColor.orangeColor()
        //设置横屏
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
        play1.view.transform = transform
        self.presentMoviePlayerViewControllerAnimated(play1)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieFinishedCallback:", name: MPMoviePlayerPlaybackDidFinishNotification, object: play1.moviePlayer)
        
        self.view.addSubview(play1.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNetworkUrl(url:String) -> NSURL{
        let urlStr = url
        urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let nsurl = NSURL.fileURLWithPath(urlStr)
        return nsurl
    }
    func movieFinishedCallback(notify: NSNotification){
        let theMovie = notify.object
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: theMovie)
        self.dismissMoviePlayerViewControllerAnimated()
        
        performSegueWithIdentifier("playConnect", sender: nil)
    }
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.LandscapeRight
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
