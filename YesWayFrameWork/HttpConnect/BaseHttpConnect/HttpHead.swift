//
//  HttpHead.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

class HttpHead:NSObject{
    var headName:String?
    var headValue:String?
    
    init(headName:String?,headValue:String?){
        self.headName=headName
        self.headValue=headValue
    }
}