//
//  BaseDataModule.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

class BaseDataModule : BusinessProtocl{
    var business:BusinessInterface!
    var observer:DataModuleDelegate!
    init(){
    
    }
    func creatBusinessWithId(businessId:BusinessType, andExecuteWithData dic:NSDictionary){
        self.creatBusinessWithId(businessId, andObserver: self, andExecuteWithData: dic)
    }
    
    func creatBusinessWithId(businessId:BusinessType,andObserver observer:BusinessProtocl,andExecuteWithData dic:NSDictionary ){
        self.business = BusinessFactory.createBusiness(businessId,observer:observer)
        if self.business{
            business.execute(dic)
        }
        
    }
    
    func didBusinessSucess(business:BusinessInterface, withData businessData:NSDictionary){
        self.observer.didDataModuleNoticeSucess(self, forBusinessType:business.businessId!)
        
        if self.business.businessHttpConnect.status==HttpContentStatus.HttpContentStatus_DidStop || self.business.businessHttpConnect.status == HttpContentStatus.HttpContentStatus_DidFinishRespones{
            self.business = nil
        }
        
    }
    
    func didBusinessFail(){
    self.observer.didDataModuleNoticeFail(self, forBusinessType:self.business.businessId! ,forErrorCode:-1, forErrorMsg:"")
    
        if self.business.businessHttpConnect.status==HttpContentStatus.HttpContentStatus_DidStop || self.business.businessHttpConnect.status == HttpContentStatus.HttpContentStatus_DidFinishRespones{
         self.business = nil
        }
   
    }
    
    
    func didBusinessError(business:BusinessInterface ){
    self.observer.didDataModuleNoticeFail(self ,forBusinessType:business.businessId!, forErrorCode:business.errCode! ,forErrorMsg:business.errmsg!)
    
        if(self.business.businessHttpConnect.status==HttpContentStatus.HttpContentStatus_DidStop || self.business.businessHttpConnect.status == HttpContentStatus.HttpContentStatus_DidFinishRespones){
        self.business = nil
        }
    }
}