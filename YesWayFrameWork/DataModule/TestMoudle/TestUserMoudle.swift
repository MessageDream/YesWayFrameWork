//
//  TestUserMoudle.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

class TestUser:BaseDataModule{
    func login(mobileNumber:String,password:String){
        var dict:  NSMutableDictionary = NSMutableDictionary()
        dict.setObject(mobileNumber ,forKey:"mobilenumber")
        dict.setObject(password,forKey:"password")
        self.creatBusinessWithId(BusinessType.TEST ,andExecuteWithData:dict)
    }
}