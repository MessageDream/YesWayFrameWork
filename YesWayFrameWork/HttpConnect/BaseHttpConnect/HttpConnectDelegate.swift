//
//  HttpConnectDelegate.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

protocol HttpConnectDelegate{
    func willHttpConnectResquest(httpContent:HttpConnectInterface)
    func didGetHttpConnectResponseHead(allHead:NSDictionary)
    func httpConnectResponse(httpContent:HttpConnectInterface,GetByteCount byteCount:Int)
//func didHttpConnectSucuss(httpContent:HttpConnectInterface)
    func didHttpConnectError(errorCode: HttpErrorCode)
    func didHttpConnectFinish(httpContent:HttpConnectInterface)
//func didTimeout(httpContent:HttpConnectInterface ){}
//func didHttpConnectFail(error:Int){}
}