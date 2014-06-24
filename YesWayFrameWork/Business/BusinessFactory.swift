//
//  BusinessFactory.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-13.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

class BusinessFactory:NSObject{
    class func createBusiness(type:BusinessType,observer:BusinessProtocl)->BusinessInterface!{
        switch type {
        case .BUSINESS_NONE:
            return nil
        case .TEST:
            return TestBusiness<BaseBusinessHttpConnect>(observer:observer)
        default:
            return nil
        }
    }
}