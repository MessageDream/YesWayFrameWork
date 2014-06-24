//
//  BaseHttpConnect.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

let HTTP_REQUEST_GET = "GET"
let HTTP_REQUEST_POST = "POST"
let CONNECT_DEFAULT_TIMEOUT = 30
let NO_TIMEOUT = -1

enum HttpContentStatus:Int{
    case HttpContentStatus_DidStart = 1
    case HttpContentStatus_DidStop
    case HttpContentStatus_WillStart
    case HttpContentStatus_WillStop
    case HttpContentStatus_WillRespones
    case HttpContentStatus_DidRespones
    case HttpContentStatus_DidFinishRespones
};

class BaseHttpConnect : NSObject,HttpConnectInterface{
    var connection:NSURLConnection!
    var timer:NSTimer!
    var dataBuffer:NSMutableData=NSMutableData()
    var timeOut:Int = NO_TIMEOUT
    var errorCode:Int = HttpErrorCode.HttpErrorCode_None.toRaw()
    var status:HttpContentStatus=HttpContentStatus.HttpContentStatus_WillStart
    var url:String?
    var resquestHeads:HttpHead[]=[]
    var body:NSMutableData=NSMutableData()
    var resquestType:String = HTTP_REQUEST_POST
    var response:HttpConnectRespones=HttpConnectRespones()
    var observer:HttpConnectDelegate!
    
    init(observer:HttpConnectDelegate,resquestType:String,url:String) {
        self.observer=observer
        self.resquestType=resquestType
        self.url=url
    }
    
    func send(){
        if self.status == .HttpContentStatus_DidStart {
            return;
        }
        
        if timeOut == 0 {
            timeOut = CONNECT_DEFAULT_TIMEOUT;
        }
        
        if !url{
            return;
        }
        
        var urlAddress  = NSURL.URLWithString(self.url)
        var urlRequest = NSMutableURLRequest(URL: urlAddress)
        urlRequest.HTTPMethod=self.resquestType
        if self.resquestType == HTTP_REQUEST_POST {
            if body != nil {
                urlRequest.HTTPBody=self.body
            }
        }
        if self.resquestHeads.count>0{
            for head in self.resquestHeads{
                if let value=head.headValue{
                    urlRequest.setValue(value, forHTTPHeaderField: head.headName)
                }
            }
            if self.observer  {
                self.observer.willHttpConnectResquest(self)
            }
            self.connection = NSURLConnection(request: urlRequest, delegate: self)
            
            if self.timeOut != NO_TIMEOUT{
                 timer = NSTimer(timeInterval: NSTimeInterval(CONNECT_DEFAULT_TIMEOUT), target: self, selector: "onTimer:", userInfo: nil, repeats: true)
            }
        }
    }
    
    func sendWithParam(param:NSDictionary){
        send()
    }
    
    func removeTimer(){
        if let time=timer {
            time.invalidate()
            timer = nil;
        }
    }
    
    func closeConnect(){
        connection.cancel()
        removeTimer()
    }
    
    func onTimer(sender:AnyObject){
        status = .HttpContentStatus_DidStop
        errorCode = HttpErrorCode.HttpErrorCode_TimerOut.toRaw()
        if let obs = self.observer {
            let code=HttpErrorCode.fromRaw(errorCode)
            obs.didHttpConnectError(code!)
        }
        closeConnect()
    }
    
    func cancel(){
        closeConnect()
        status = HttpContentStatus.HttpContentStatus_DidStop
    }
    
    func connection(connection:NSURLConnection, didSendBodyData bytesWritten:NSInteger, totalBytesWritten:NSInteger,  totalBytesExpectedToWrite:NSInteger)
    {
        status = .HttpContentStatus_DidStart;
        if self.observer {
            self.observer.willHttpConnectResquest(self)
        }
    }
    
    func connection(theConnection:NSURLConnection,didReceiveResponse response:NSURLResponse)
        // A delegate method called by the NSURLConnection when the request/response
        // exchange is complete.  We look at the response to check that the HTTP
        // status code is 2xx and that the Content-Type is acceptable.  If these checks
        // fail, we give up on the transfer.
    {
        assert(theConnection == connection)
        status = .HttpContentStatus_DidRespones;
        
        
        assert(response.isKindOfClass(NSHTTPURLResponse))
        var httpResponse:NSHTTPURLResponse = response as NSHTTPURLResponse
        errorCode = httpResponse.statusCode
        println("the response status code is \(httpResponse.statusCode)\n")
        self.response.responesHead = httpResponse.allHeaderFields
        if self.observer{
            self.observer.didGetHttpConnectResponseHead(self.response.responesHead)
        }
    }
    
    func connection(theConnection:NSURLConnection, didReceiveData data:NSData)
        // A delegate method called by the NSURLConnection as data arrives.  We just
        // write the data to the file.
    {
        assert(theConnection == connection)
        dataBuffer.appendData(data)
        if self.observer{
            self.observer.httpConnectResponse(self,GetByteCount:data.length)
        }
        
    }
    
    func connection(theConnection:NSURLConnection , didFailWithError error:NSError)
        // A delegate method called by the NSURLConnection if the connection fails.
        // We shut down the connection and display the failure.  Production quality code
        // would either display or log the actual error.
    {
        assert(theConnection == connection)
        
        closeConnect()
        status = .HttpContentStatus_DidStop;
        errorCode = error.code
        if self.observer {
            self.observer.didHttpConnectError(HttpErrorCode.fromRaw(errorCode)!)
        }
    }
    
    func connectionDidFinishLoading(theConnection:NSURLConnection)
        // A delegate method called by the NSURLConnection when the connection has been
        // done successfully.  We shut down the connection with a nil status, which
        // causes the image to be displayed.
    {
        assert(theConnection == connection);
        println("the connection is \(dataBuffer.length)")
        
        status = .HttpContentStatus_DidFinishRespones;
        if self.observer{
            //需要加上业务错误对象判断的机制
            if self.errorCode != HttpErrorCode.HttpErrorCode_None.toRaw() && resquestType == HTTP_REQUEST_POST{
                self.observer.didHttpConnectError(HttpErrorCode.fromRaw(self.errorCode)!)
            }else{
                self.response.responesData = dataBuffer
                self.observer.didHttpConnectFinish(self)
            }
        }
        self.closeConnect()
    }
    deinit{
            connection = nil
    }
}