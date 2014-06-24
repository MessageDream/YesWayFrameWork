//
//  NtspHeader.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

class NtspHeader:NSObject{
    var uuid:String?
    var mobileNumber:String?
    var accessToken:String?
    var tuid:String?
    
    class func shareHeader()->NtspHeader{
        struct HeaderSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NtspHeader? = nil
        }
        dispatch_once(&HeaderSingleton.predicate, {
            HeaderSingleton.instance=NtspHeader()
            })
        
        return HeaderSingleton.instance!
    }
    
    func setWithJson(jsonDic:NSDictionary){
        var ntspHeader=NtspHeader.shareHeader()
        ntspHeader.uuid = jsonDic.objectForKey("uuid") as? String
        ntspHeader.mobileNumber = jsonDic.objectForKey("mobilenumber") as? String
        ntspHeader.accessToken = jsonDic.objectForKey("access_token") as? String
        ntspHeader.tuid = jsonDic.objectForKey("tuid") as? String
    }
    
    func toDicValue()->NSDictionary!{
        var ntspHeaderDictionary:NSMutableDictionary   = NSMutableDictionary()
        if self.uuid {
            ntspHeaderDictionary.setValue(self.uuid, forKey:"uuid")
        }
        if self.mobileNumber {
            ntspHeaderDictionary.setValue(self.mobileNumber ,forKey:"mobilenumber")
        }
        if self.accessToken {
            ntspHeaderDictionary.setValue(self.accessToken ,forKey:"access_token")
        }
        if self.tuid {
            ntspHeaderDictionary.setValue(self.tuid ,forKey:"tuid")
        }
        
        if ntspHeaderDictionary.count == 0 {
            return nil
        }else{
            return ntspHeaderDictionary
        }

    }
}