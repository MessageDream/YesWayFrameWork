//
//  BaseBusiness.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

enum BusinessErrorType:Int{
    //    201	接口处理超时。
    //    202	必需的参数为空。
    //    203	系统错误。
    //    204	参数错误。
    //    8001	令牌失效
    
    case   REQUEST_NOERROR=0
    case   REQUEST_TIME_ERROR=201
    case   REQUEST_PARAMNULL_ERROR=202
    case   REQUEST_SYSTEM_ERROR=203
    case   REQUEST_PARAM_ERROR=204
    case   REQUEST_AUTH_ERROR=8001
    
}

protocol DownLoadBusinessProtocl{
    func didDownLoadFileOfByteCount(business:BusinessInterface , forByteCount byteCount:Int64 ,forTotalByteCount totalByteCount:Int64)
}



class BaseBusiness<T:HttpConnectInterface> :HttpConnectDelegate,BusinessInterface{
    var errCode:Int?
    var errmsg:String?
    var businessId:BusinessType?
    var businessErrorType:BusinessErrorType=BusinessErrorType.REQUEST_NOERROR
    var businessHttpConnect:HttpConnectInterface!
    var businessObserver:BusinessProtocl!
    
    init(resquestType:String,url:String){
        self.businessHttpConnect = T(observer: self,resquestType:resquestType,url:url)
    }
    
    convenience init(observer:BusinessProtocl){
        self.init(resquestType:"",url:"")
        self.businessObserver=observer
    }
   
    //执行网络请求
    func execute(param:NSDictionary!){
        if param{//可能有无参数的情况：例如注销登录
            if !NSJSONSerialization.isValidJSONObject(param){
                return
            }
        }
        
        if self.businessHttpConnect {
            self.businessHttpConnect.sendWithParam(param)
        }
    }
    
    //取消请求
    func cancel(){
        if self.businessHttpConnect {
            self.businessHttpConnect.cancel()
        }
    }
    
    //解析返回数据
    func parseBaseBusinessHttpConnectResponseData()->NSDictionary!{
        var error: NSErrorPointer=nil
        if self.businessHttpConnect.response.responesData {
            return NSJSONSerialization.JSONObjectWithData(self.businessHttpConnect.response.responesData,options:NSJSONReadingOptions.MutableContainers ,error:error) as NSDictionary
        }else{
            return nil
        }
    }
    
    
    //获取错误码
    func errorCodeFromResponse(theResponseBody:NSDictionary!){
        if theResponseBody {
            if theResponseBody.isKindOfClass(NSDictionary) {
                errCode = theResponseBody.objectForKey("errcode") as? Int
                errmsg = theResponseBody.objectForKey("errmsg") as? String
            }
        }
        switch (errCode!) {
        case NO_ERROR:
            self.businessErrorType = .REQUEST_NOERROR
        case TIME_ERROR:
            self.businessErrorType = .REQUEST_TIME_ERROR
        case SYSTEM_ERROR:
            self.businessErrorType = .REQUEST_SYSTEM_ERROR
        case AUTH_ERROR:
            self.businessErrorType = .REQUEST_AUTH_ERROR
        case PARAM_ERROR:
            self.businessErrorType = .REQUEST_PARAM_ERROR
        default:
            break
        }

    }
    
    func willHttpConnectResquest(httpContent:HttpConnectInterface){
    
    }
    
    func didGetHttpConnectResponseHead(allHead:NSDictionary){
    
    }
    
    func httpConnectResponse(httpContent:HttpConnectInterface,GetByteCount byteCount:Int){
        
    }
    
    func didHttpConnectError(errorCode: HttpErrorCode){
        if self.businessObserver{
            errmsg = HttpErrorCodeManager.getDesFromErrorCode(errorCode)
            self.businessObserver.didBusinessError(self)
        }
    }
    
    func didHttpConnectFinish(httpContent:HttpConnectInterface){
        var responseBodyDic: NSDictionary! = self.parseBaseBusinessHttpConnectResponseData()
        
        if DEBUG_LOG{
            println("rece:\(responseBodyDic)")
        }
        if responseBodyDic {
            self.errorCodeFromResponse(responseBodyDic)
            if errCode == BusinessErrorType.REQUEST_NOERROR.toRaw(){
                //不需要"errcode"和"errmsg"的数据，数据通过getNtspHeaderFromBaseBusinessHttpConnectResponseData取得
                (responseBodyDic as NSMutableDictionary).removeObjectForKey("errcode")
                (responseBodyDic as NSMutableDictionary).removeObjectForKey("errmsg")
            }
            else if errCode >= TIME_ERROR || errCode <= BusinessErrorType.REQUEST_PARAM_ERROR.toRaw()
            {
                self.businessObserver.didBusinessError(self)
                return
            }
        }
        self.businessObserver.didBusinessSucess(self,withData:responseBodyDic)
    }
}


