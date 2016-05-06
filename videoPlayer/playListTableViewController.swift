//
//  playListTableViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/11/21.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreData
import Alamofire

class playListTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var video:Video!
    var fetchResultController:NSFetchedResultsController!
    var videos:[Video] = []
    var url:NSURL!
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    
    @IBOutlet weak var itemButton: UIBarButtonItem!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
       
        let urlStr = NSBundle.mainBundle().pathForResource("11", ofType: "mp4")
         url = NSURL.fileURLWithPath(urlStr!)
        
        
        
       //从coredata 中读取数据
        let fetchRequest = NSFetchRequest(entityName: "Video")
        let sortDescriptor = NSSortDescriptor(key: "videoPath", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext2 = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext2, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                videos = fetchResultController.fetchedObjects as! [Video]
            }catch{
                print(error)
            }
        }
     
       
        //截取视频的图像
//        let parhUrl = NSURL.fileURLWithPath(videos[0].videoPath)
//        print(path)
//                let asset = AVURLAsset(URL: parhUrl)
//                let generatel = AVAssetImageGenerator(asset: asset)
//                generatel.appliesPreferredTrackTransform = true
//                let time = CMTimeMake(1, 2)
//                do{
//                    let oneRef = try generatel.copyCGImageAtTime(time, actualTime: nil)
//                    image = UIImage(CGImage: oneRef)
//                }catch{
//                    print(error)
//                }

        
        
        //let urlStr = NSBundle.mainBundle().pathForResource("11", ofType: "mp4")
//        let url = NSURL.fileURLWithPath(urlStr!)
//        let play1 = MPMoviePlayerViewController(contentURL: url)
//        play1?.moviePlayer.requestThumbnailImagesAtTimes([1.0], timeOption: .NearestKeyFrame)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "thumImageGet:", name: MPMoviePlayerThumbnailImageRequestDidFinishNotification, object: play1.moviePlayer)
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
        return videos.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! playListTableViewCell
        
        //得到文件的地址
        let documentsDirectory = paths[0] as NSString
        let parhUrl = NSURL.fileURLWithPath(documentsDirectory.stringByAppendingPathComponent(videos[indexPath.row].videoPath))
        //得到文件的图片
        let asset = AVURLAsset(URL: parhUrl)
        let generatel = AVAssetImageGenerator(asset: asset)
        generatel.appliesPreferredTrackTransform = true
        let time = CMTimeMake(1, 2)
        do{
            let oneRef = try generatel.copyCGImageAtTime(time, actualTime: nil)
            image = UIImage(CGImage: oneRef)
        }catch{
            print(error)
        }

        cell.palyListImage.image = image
        cell.labelName.text = videos[indexPath.row].name
        cell.labelTime.text = videos[indexPath.row].time
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deletAction = UITableViewRowAction(style: .Default, title: "删除") { (action, indexPath) -> Void in
            
            let documentsDirectory = self.paths[0] as NSString
            let fileManager = NSFileManager.defaultManager()
            do{
                try fileManager.removeItemAtPath(documentsDirectory.stringByAppendingPathComponent(self.videos[indexPath.row].videoPath))
                print("成功")
            }catch
            {
                print(error)
            }

            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
                let videoToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Video
                managedObjectContext.deleteObject(videoToDelete)
                
                do{
                    try managedObjectContext.save()
                }catch{
                    print(error)
                }
            }
        }
        return [deletAction]
    }
    
    @IBAction func rightButtonItem(sender: UIBarButtonItem) {
        if sender.tag == 10{
            super.setEditing(true, animated: true)
            self.tableView.setEditing(true, animated: true)
            itemButton.title = "完成"
            itemButton.tag = 20
        }else{
            self.tableView.setEditing(false, animated: true)
            itemButton.title = "编辑"
            itemButton.tag = 10        }
    }
    

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            if let _newIndexPath = newIndexPath{
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath{
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _indexPath = indexPath{
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
        }
        videos = controller.fetchedObjects as! [Video]
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
//        return 500
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            self.name.removeAtIndex(indexPath.row)
//            self.time.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }


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

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playConnect1"{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let destinationController = segue.destinationViewController as! startPlayViewController
                destinationController.video = videos[indexPath.row]
                destinationController.paths = paths[0]
            }
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    @IBAction func close(segue:UIStoryboardSegue){
        
    }

}
