//
//  TestBusiness.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

let API_ADDRESS = "http://111.207.170.13:8093/"

class TestBusiness<T:HttpConnectInterface>:BaseBusiness<T>,BusinessInterface{
    init(observer:BusinessProtocl){
            var ip:String = API_ADDRESS;
            ip = ip.stringByAppendingString("system/user/login")
            super.init(resquestType:HTTP_REQUEST_POST,url:ip)
            businessId = BusinessType.TEST
            self.businessObserver=observer
    }
}