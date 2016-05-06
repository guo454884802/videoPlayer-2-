//
//  networkPlayViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/11/22.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import MediaPlayer
import Alamofire
import AVFoundation
import CoreData
import SafariServices


class networkPlayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
//    
//    let inUrl2 = "rtmp://www.bj-mobiletv.com:8000/live/live1"
//    let inurl1 = "rtmp://ftv.sun0769.com/dgrtv1/mp4:b1"
//    let inUrl = "rtmp://live.hkstv.hk.lxdns.com/live/hks"
//    let inUrl3 = "rtmp://127.0.0.1/live/livestream"
    var image:UIImage!
    var video:Video!
    var pathComponent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决了第一个cell上面有空白
        self.automaticallyAdjustsScrollViewInsets = false
        
//        let vc = KxMovieViewController.movieViewControllerWithContentPath(inUrl3, parameters: nil) as! UIViewController
//        self.presentViewController(vc, animated: true, completion: nil)
        
//        let inUrl = "http://mudu.tv/?a=index&c=show&id=3351&type=mobile"
//        let inUrl2 = "http://ac-e15jcs72.clouddn.com/2df1bc800ba3c5e6.mp4"
        
//        let play1 = MPMoviePlayerViewController(contentURL: NSURL(string: inUrl))
//        play1.moviePlayer.prepareToPlay()
//        play1.view.frame = self.view.bounds
//        play1.view.backgroundColor = UIColor.orangeColor()
//        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
//        play1.view.transform = transform
//        self.presentMoviePlayerViewControllerAnimated(play1)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieFinishedCallback:", name: MPMoviePlayerPlaybackDidFinishNotification, object: play1.moviePlayer)
//        
//        self.view.addSubview(play1.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func movieFinishedCallback(notify: NSNotification){
//        let theMovie = notify.object
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: theMovie)
//        self.dismissMoviePlayerViewControllerAnimated()
//        
//       
//        print("执行")
//    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! networkPlayTableViewCell
        
       
//        let asset = AVURLAsset(URL: NSURL(string: inUrl)!)
//        let generatel = AVAssetImageGenerator(asset: asset)
//        generatel.appliesPreferredTrackTransform = true
//        let time = CMTimeMake(1, 2)
//        do{
//            let oneRef = try generatel.copyCGImageAtTime(time, actualTime: nil)
//            image = UIImage(CGImage: oneRef)
//        }catch{
//            print(error)
//        }
//        
//        cell.networkImage.image = image
//        
        return cell
    }
    @IBAction func downloadButton(sender: UIButton) {
        
        //performSegueWithIdentifier("showWebView", sender: self)
        let url = NSURL(string: "http://mudu.tv/?a=index&c=show&id=3351&type=mobile")
        let safariController = SFSafariViewController(URL: url!, entersReaderIfAvailable: true)
        presentViewController(safariController, animated: true, completion: nil)
        
//        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
//           Alamofire.download(.GET, self.inUrl) { (temporaryURL, response) -> NSURL in
//                let fileManager = NSFileManager.defaultManager()
//                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//                 self.pathComponent = response.suggestedFilename!
//                let path = directoryURL.URLByAppendingPathComponent(self.pathComponent)
//                print(path)
//                
//                return path
//            }.progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
//                print(totalBytesRead)
//            }).response(completionHandler: { (_, _, _, error) -> Void in
//                if let error = error{
//                    print("下载失败\(error)")
//                }else{
//                    print("下载成功")
//                    self.saveData()
//                    let alert = UIAlertController(title: "下载成功！", message:nil, preferredStyle: .Alert)
//                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                    alert.addAction(action)
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//            })
//
//        }
//        
            }
//    func saveData(){
//        
//        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
//            video = NSEntityDescription.insertNewObjectForEntityForName("Video", inManagedObjectContext: managedObjectContext) as! Video
//            
//            let data = NSDate()
//            let timeFormatter = NSDateFormatter()
//            timeFormatter.dateFormat = "yyyy年MM月dd日"
//            
//            video.name = removeTag(pathComponent)
//            video.time = timeFormatter.stringFromDate(data) as String
//            video.videoPath = pathComponent
//            
//            do{
//                try managedObjectContext.save()
//            }catch{
//                print(error)
//                return
//            }
//        }
//        
//    }
//    //删除字符串的一段特定字符
//    func removeTag(source:String) -> String{
//        let tag = ".mp4"
//        var sourceString = source
//        
//        let range = source.rangeOfString(tag, options: .RegularExpressionSearch, range: nil, locale: nil)
//        sourceString.removeRange(range!)
//        print(sourceString)
//        
//        return sourceString
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
