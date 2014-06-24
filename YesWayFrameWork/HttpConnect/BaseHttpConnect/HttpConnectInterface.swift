//
//  HttpConnectedInterface.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

protocol HttpConnectInterface{
    var connection:NSURLConnection!{get set}
    var timer:NSTimer!{get set}
    var dataBuffer:NSMutableData{get set}
    var timeOut:Int{get set}
    var errorCode:Int {get}
    var status:HttpContentStatus{get}
    var url:String?{get set}
    var resquestHeads:HttpHead[]{get set}
    var body:NSMutableData{get set}
    var resquestType:String {get set}
    var response:HttpConnectRespones{get}
    var observer:HttpConnectDelegate!{get set}
    
    init(observer:HttpConnectDelegate,resquestType:String,url:String)
    
    func sendWithParam(param:NSDictionary)
    func send()
    func cancel()
}