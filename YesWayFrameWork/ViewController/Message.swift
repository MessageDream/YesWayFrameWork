//
//  Message.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-13.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

class Message:NSObject{
    var receiveObjectID: NodeAndViewControllerID=NodeAndViewControllerID.NODE_NONE
    var sendObjectID:NodeAndViewControllerID=NodeAndViewControllerID.NODE_NONE
    var commandID:CommandID!
    var externData:AnyObject!
    
    deinit{
        externData=nil
    }
}