//
//  BaseBusinessInterface.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

protocol BusinessProtocl{
    func didBusinessSucess(business:BusinessInterface , withData businessData:NSDictionary)
    func didBusinessFail()
    func didBusinessError(business:BusinessInterface )
}


protocol BusinessInterface{
    var errCode:Int?{get}
    var errmsg:String?{get}
    var businessId:BusinessType?{get set}
    var businessErrorType:BusinessErrorType{get set}
    var businessHttpConnect:HttpConnectInterface!{get set}
    var businessObserver:BusinessProtocl!{get set}
    init(observer:BusinessProtocl)
    //执行网络请求
    func execute(param:NSDictionary!)
    //取消请求
    func cancel()
    //解析返回数据
    func parseBaseBusinessHttpConnectResponseData()->NSDictionary!
    
    //获取错误码
    func errorCodeFromResponse(theResponseBody:NSDictionary!)
}