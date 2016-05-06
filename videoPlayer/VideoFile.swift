//
//  VideoFile.swift
//  videoPlayer
//
//  Created by  wj on 15/11/22.
//  Copyright © 2015年 gzq. All rights reserved.
//

import Foundation
import CoreData

class Video:NSManagedObject {
    
    @NSManaged var name:String?
    @NSManaged var time:String?
    @NSManaged var videoPath:String
}