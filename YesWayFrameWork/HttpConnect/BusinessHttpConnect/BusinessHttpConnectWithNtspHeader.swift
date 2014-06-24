//
//  BusinessHttpConnectWithNtspHeader.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
class BusinessHttpConnectWithNtspHeader : BaseBusinessHttpConnect,HttpConnectInterface{
   var ntspHeaderJLH:NtspHeader!
    init(observer:HttpConnectDelegate,resquestType:String,url:String) {
        super.init(observer:observer,resquestType:resquestType,url:url)
        self.ntspHeaderJLH=NtspHeader.shareHeader()
    }
    
    
    override func createBaseBussinessHttpBody(theParam:NSDictionary!){
        var theError: NSErrorPointer=nil
        var baseBusinessHttpBodyDic: NSMutableDictionary
        if theParam {
            baseBusinessHttpBodyDic = NSMutableDictionary(dictionary: theParam)
        }else{
            baseBusinessHttpBodyDic = NSMutableDictionary()
        }
        if self.ntspHeaderJLH{
            baseBusinessHttpBodyDic.setObject(self.ntspHeaderJLH.toDicValue() ,forKey:"ntspheader")
        }
        
        if self.resquestType == HTTP_REQUEST_POST{
            if body.isKindOfClass(NSMutableData) {
                (body as NSMutableData).appendData(NSJSONSerialization.dataWithJSONObject(baseBusinessHttpBodyDic,options:NSJSONWritingOptions.PrettyPrinted ,error:theError))
            }
        }
        
    }
}