//
//  onlineCollectionViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/12/10.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "Cell"

class onlineCollectionViewController: UICollectionViewController {

    var name :[String] = []
    var image:UIImage?
    var number:Int?
    var imageCache = NSCache()
    var count = 0
    var urls:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            let query2 = AVQuery(className: "_File")
            query2.whereKey("name", notEqualTo: "图片.png")
            
            let object =  query2.findObjects()
            self.count = object.count
            self.urls = [String](count: self.count, repeatedValue: "")
            self.name = [String](count: self.count, repeatedValue: "")
            for i in 0..<self.count{
                self.urls[i] = object[i]["url"] as! String
                self.name[i] = object[i]["name"] as! String
                
            }
            
                self.collectionView?.reloadData()
            

        
        
//        query2.findObjectsInBackgroundWithBlock { (object, error) -> Void in
//            if error == nil{
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.count = object.count
//                    // print(self.count)
//                    self.urls = [String](count: self.count, repeatedValue: "")
//                    for i in 0..<self.count{
//                        self.urls![i] = object[i]["url"] as! String
//                        print(self.urls![i])
//
//                }
//                    
//                })
//            }
//        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(omlineCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        self.view.addSubview(self.collectionView!)
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.count
    }

   
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) 
        
        var image1 = UIImage(named: "photoalbum")
       (cell.contentView.viewWithTag(10) as! UILabel).text = name[indexPath.row]
        (cell.contentView.viewWithTag(100) as! UIImageView).image = image1
        
        //缓存图片，待测试！
        if let imageFileURL = imageCache.objectForKey(name[indexPath.row]) as? NSURL{
            (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
        }else{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
                
                image1 = self.getPhoto(self.urls[indexPath.row])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    (cell.contentView.viewWithTag(100) as! UIImageView).image = image1
                    self.imageCache.setObject((cell.contentView.viewWithTag(100) as! UIImageView).image!, forKey: self.name[indexPath.row])
                })
            }
            
        }
        // Configure the cell
    
        return cell
    }
    func getPhoto(url:String) -> UIImage{
        
//        let inUrl = url + name
        let asset = AVURLAsset(URL: NSURL(string: url)!)
       
        print(url)
        let generatel = AVAssetImageGenerator(asset: asset)
        generatel.appliesPreferredTrackTransform = true
        let time = CMTimeMake(1, 2)
        do{
            let oneRef = try generatel.copyCGImageAtTime(time, actualTime: nil)
            image = UIImage(CGImage: oneRef)
        }catch{
          print(error)
        }
        return image!
    }
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        number = indexPath.row
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "onlinePlay" {
            if let indexPath = collectionView?.indexPathsForSelectedItems(){
            let destinationController = segue.destinationViewController as! onlineTableViewController
            destinationController.name = name[indexPath[0].row]
            destinationController.inUrl = urls[indexPath[0].row]
            }
        }
        
    }


}
