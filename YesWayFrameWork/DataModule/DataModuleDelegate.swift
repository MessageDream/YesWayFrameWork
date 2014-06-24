//
//  DataModuleDelegate.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-11.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation

 protocol DataModuleDelegate {
    func didDataModuleNoticeSucess(baseDataModule:BaseDataModule, forBusinessType businessID:BusinessType)
    func didDataModuleNoticeFail(baseDataModule:BaseDataModule, forBusinessType businessID: BusinessType ,forErrorCode errorCode:Int, forErrorMsg errorMsg:String!)
}


 protocol DataModuleTransferFileDelegate{
    func didDataModuleNoticeDownLoadFileing(baseDataModule:BaseDataModule,forByteCount byteCount: Int64, forTotalByteCount totalByteCount:Int64)
}