//
//  NodeAndViewControllerID.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-13.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

let NODE_WORK_LENGTH = 100

enum NodeAndViewControllerID:Int{
    case VIEWCONTROLLER_NONE = -3
    case NODE_NONE = -2
    case VIEWCONTROLLER_RETURN = -1
    case NODE_ROOT = 0
    
    
    //SystemNode节点
    case NODE_SYSTEM = 1000
    case VIEWCONTROLLER_LOGIN
    //AppNode节点
    case NODE_APP=1101
    case VIEWCONTROLLER_FEEDBACK
    
    //GuideNode节点
    case NODE_GUIDE=1201
    case VIEWCONTROLLER_GUIDE
    case VIEWCONTROLLER_LOADING
    
    
    //AppletNode节点
    case NODE_APPLET=2000
    case VIEWCONTROLLER_HALL
    //VehicleControlNode节点
    case NODE_VEHICLECONTROL=2101
}