//
//  onlineTableViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/12/1.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreData
import Alamofire



class onlineTableViewController: UITableViewController,MBProgressHUDDelegate {
typealias Task = (cancel:Bool) -> ()
    
    var name :String?
    var image :UIImage?
    var inUrl:String!
    var video:Video!
    var pathComponent = ""
    var HUD:MBProgressHUD?
    var HUD1:MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        onlinePlay()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! onlineTableViewCell
        
        cell.videoName.text = name
        
        
        let asset = AVURLAsset(URL: NSURL(string: inUrl)!)
        print(inUrl)
        let generatel = AVAssetImageGenerator(asset: asset)
        generatel.appliesPreferredTrackTransform = true
        let time = CMTimeMake(1, 2)
        do{
            let oneRef = try generatel.copyCGImageAtTime(time, actualTime: nil)
            image = UIImage(CGImage: oneRef)
        }catch{
           // print(error)
//            let alert = UIAlertController(title: "错误", message: "没有此文件", preferredStyle: .Alert)
//            let action = UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
//                
               // self.dismissViewControllerAnimated(true, completion: nil)
//            })
//            alert.addAction(action)
//            self.presentViewController(alert, animated: true, completion: nil)
        }

        cell.videoImage.image = image
        // Configure the cell...

        return cell
    }
    func onlinePlay(){
        //let URL = "http://ac-e15jcs72.clouddn.com/b8c29636820838c3.mp4"
        print(inUrl)
        
        let play1 = MPMoviePlayerViewController(contentURL: NSURL(string: inUrl))
                play1.moviePlayer.prepareToPlay()
                play1.view.frame = self.view.bounds
                play1.view.backgroundColor = UIColor.orangeColor()
                let transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2.0))
                play1.view.transform = transform
                self.presentMoviePlayerViewControllerAnimated(play1)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "startPlay", name: MPMediaPlaybackIsPreparedToPlayDidChangeNotification, object: play1.moviePlayer)
        
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieFinishedCallback:", name: MPMoviePlayerPlaybackDidFinishNotification, object: play1.moviePlayer)

        HUD1 = MBProgressHUD.showHUDAddedTo(play1.view, animated: true)
        HUD1!.delegate = self
        //hud.mode = MBProgressHUDMode.CustomView
        HUD1!.labelText = "加载中"
        HUD1!.show(true)
        HUD1!.hide(true, afterDelay: 10)
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(9 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
       
        self.HUD1!.mode = MBProgressHUDMode.CustomView
        self.HUD1!.labelText = "加载失败,请观看其他资源"
        self.HUD1!.show(true)
        self.HUD1!.hide(true, afterDelay: 3)
        }

        
    }
    func startPlay(){
        print("开始播放")
        HUD1?.removeFromSuperview()
    }
    func movieFinishedCallback(notify: NSNotification){
        let theMovie = notify.object
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: theMovie)
        self.dismissMoviePlayerViewControllerAnimated()
        self.clearAllNotice()
        
        print("执行")
    }

    @IBAction func downloadButton(sender: UIButton) {
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            Alamofire.download(.GET, self.inUrl!) { (temporaryURL, response) -> NSURL in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                self.pathComponent = self.name!
                let path = directoryURL.URLByAppendingPathComponent(self.pathComponent)
                print(path)
                
                return path
                }.progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        self.HUD!.delegate = self
                        self.HUD!.mode = MBProgressHUDMode.AnnularDeterminate
                        self.HUD!.labelText = "下载中..."
                        self.HUD!.showAnimated(true, whileExecutingBlock: { () -> Void in
                            
                            let precent:Float = (Float)(totalBytesRead) / (Float)(totalBytesExpectedToRead)
                            print(precent)
                           
                            self.HUD!.progress = precent
                            sleep(1)
                            
                            }, completionBlock: { () -> Void in
                                
                                //self.HUD!.removeFromSuperview()
                        })
                        
                    })
                    
                }).response(completionHandler: { (_, _, _, error) -> Void in
                    if let error = error{
                        print("下载失败\(error)")
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.delegate = self
                            hud.mode = MBProgressHUDMode.Text
                            hud.labelText = "下载失败，检查网络重新下载"
                            hud.show(true)
                            hud.hide(true, afterDelay: 1)
                        })
                     }else{
                        print("下载成功")
                        
                        self.saveData()
                       
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.delegate = self
                            hud.mode = MBProgressHUDMode.CustomView
                            hud.labelText = "下载完成"
                            hud.show(true)
                            hud.hide(true, afterDelay: 1)
                        })
                    }
                })

        }
        

    }
    func saveData(){
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            video = NSEntityDescription.insertNewObjectForEntityForName("Video", inManagedObjectContext: managedObjectContext) as! Video
            
            let data = NSDate()
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyyy年MM月dd日"
            
            video.name = removeTag(pathComponent)
            video.time = timeFormatter.stringFromDate(data) as String
            video.videoPath = pathComponent
            
            do{
                try managedObjectContext.save()
            }catch{
                print(error)
                return
            }
        }
        
    }
    //删除字符串的一段特定字符
    func removeTag(source:String) -> String{
        let tag = ".mp4"
        var sourceString = source
        
        let range = source.rangeOfString(tag, options: .RegularExpressionSearch, range: nil, locale: nil)
        sourceString.removeRange(range!)
        print(sourceString)
        
        return sourceString
    }
    
    
    func delay(time:NSTimeInterval,task:() -> ()) -> Task?{
        
        func dispatch_later(block:() -> ()){
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
            }
        var closure:dispatch_block_t? = task
        var result:Task?
        
        let delayedClosure:Task = {
            cancel in
            if let internalClosure = closure{
                if (cancel == false){
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result{
                delayedClosure(cancel: false)
            }
        }
        return result;
    }
    
    func cancel(task:Task?){
        task?(cancel: true)
    }
//    func myProgressTask() {
//         sleep(10)
//        HUD1?.mode = MBProgressHUDMode.Text
//        HUD1?.labelText = "网络不给力"
//        HUD1?.margin = 10.0
//        HUD1?.removeFromSuperViewOnHide = true
//        HUD1?.hide(true, afterDelay: 3)
//        print("执行")
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
