//
//  HttpErrorCodeManager.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-6.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

enum HttpErrorCode:Int{
   case HttpErrorCode_NetworkFail = -1004
   case HttpErrorCode_None = 200
   case HttpErrorCode_TimerOut = 10
   case HttpErrorCode_WriteFileFail
}

class HttpErrorCodeManager : NSObject{
   class func getDesFromErrorCode(code:HttpErrorCode)->String{
        switch code{
        case .HttpErrorCode_NetworkFail:
            return NSLocalizedString("HttpError4", tableName: Res_String,comment:"")
        case .HttpErrorCode_TimerOut:
             return NSLocalizedString("HttpError2", tableName: Res_String,comment:"")
        case .HttpErrorCode_WriteFileFail:
             return NSLocalizedString("HttpError3", tableName: Res_String,comment:"")
        default:
            return NSLocalizedString("HttpError1", tableName: Res_String,comment:"")
        }
    }
}

