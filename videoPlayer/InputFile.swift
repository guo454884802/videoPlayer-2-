//
//  InputFile.swift
//  videoPlayer
//
//  Created by  wj on 15/12/11.
//  Copyright © 2015年 gzq. All rights reserved.
//

import Foundation


struct Inputs:OptionSetType {
    let rawValue:Int
    
    static let user = Inputs(rawValue: 1)
    static let pass = Inputs(rawValue: 1 << 1)
    static let rewirePass = Inputs(rawValue: 1 << 2)
}

extension Inputs{
    func isAllOK() -> Bool{
        //return self == [.user , .pass , .rewirePass]
        
        //选项的数目
        let count = 3
        //找到几项
        var found = 0
        //在数目范围内查找，若找到，次数加一
        for time in 0..<count{
            if self.contains(Inputs(rawValue: 1 << time)){
                found++
            }
        }
        //比较次数与选项的数目
        return found == count
    }
}