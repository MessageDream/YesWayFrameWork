//
//  BaseBusinessHttpConnect.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

let HEADER_CONTENT_TYPE_NAME = "Content-Type"
let HEADER_CONTENT_TYPE_VALUE = "application/json;charset=utf-8"

let HEADER_CONTENT_LENGTH_NAME = "Content-Length"
let HEADER_CONTENT_LENGTH_VALUE = "0"


class BaseBusinessHttpConnect : FileHttpConnect,HttpConnectInterface{

    var  baseBussinessHttpConnectId:Int!
    
    init(observer:HttpConnectDelegate,resquestType:String,url:String) {
        super.init(observer:observer,resquestType:resquestType,url:url)
    }

    func createBaseBussinessHeads(){
        var headerContentType: HttpHead   = HttpHead(headName: HEADER_CONTENT_TYPE_NAME,headValue:HEADER_CONTENT_TYPE_VALUE)
        var headerContentEncoding: HttpHead  = HttpHead(headName: HEADER_CONTENT_LENGTH_NAME,headValue:HEADER_CONTENT_LENGTH_VALUE)
        
        self.resquestHeads.append(headerContentType)
        self.resquestHeads.append(headerContentEncoding)
    }
    
    //创建消息体
    func createBaseBussinessHttpBody(theParam:NSDictionary!){
        var theError: NSErrorPointer=nil
        var baseBusinessHttpBodyDic: NSMutableDictionary
        if theParam {
            baseBusinessHttpBodyDic = NSMutableDictionary(dictionary: theParam)
        }else{
            baseBusinessHttpBodyDic = NSMutableDictionary()
        }
        
        if self.resquestType == HTTP_REQUEST_POST{
            if body.isKindOfClass(NSMutableData) {
                (body as NSMutableData).appendData(NSJSONSerialization.dataWithJSONObject(baseBusinessHttpBodyDic,options:NSJSONWritingOptions.PrettyPrinted ,error:theError))
            }
        }
    }
    
    override func sendWithParam(param:NSDictionary){
        self.createBaseBussinessHeads()
        self.createBaseBussinessHttpBody(param)
        //test
        if DEBUG_LOG {
        var str:String = self.body.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        println("send:\(self.url)\n\(str)")
        }
        super.send()
    }
}