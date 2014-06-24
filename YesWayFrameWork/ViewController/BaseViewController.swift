//
//  BaseViewController.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-13.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController:UIViewController,DataModuleDelegate{
    //UIViewController<DataModuleDelegate,TextFiledReturnEditingDelegate,CustomTitleBar_ButtonDelegate>
    
    
    var  customActivityIndicatorView: CustomActivityIndicatorView!
    var lockViewCount: Int=0
    var viewControllerId: NodeAndViewControllerID=NodeAndViewControllerID.VIEWCONTROLLER_NONE
    var parentNode:BaseNode!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!){
        super.init(nibName:nibNameOrNil,bundle:nibBundleOrNil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lockViewCount = 0;
        self.createUIActivityIndicatorView()
        ViewControllerPathManager.addViewControllerID(viewControllerId)
        
    }
    
    func destroyDataBeforeDealloc(){}
    func sendMessage(message:Message){
        if !self.parentNode{
            return
        }
        if message.receiveObjectID == NodeAndViewControllerID.VIEWCONTROLLER_RETURN{
            var ID:NodeAndViewControllerID! = ViewControllerPathManager.getPreviousViewControllerIDWithDelete()
            if ID {
                message.receiveObjectID = ID
            }
        }
        self.parentNode.receiveMessage(message)
        
    }
    func receiveMessage(message:Message){
        
    }
    
    func createUIActivityIndicatorView(){
        customActivityIndicatorView = CustomActivityIndicatorView(frame:self.view.bounds)
        customActivityIndicatorView.alpha = 0.9;
        self.view.addSubview(customActivityIndicatorView)
    }
    
    func lockView(){
        lockViewCount++
        if !customActivityIndicatorView.isAnimating(){
            self.view.userInteractionEnabled = false
            self.view.bringSubviewToFront(customActivityIndicatorView)
            customActivityIndicatorView.startAnimating()
        }
    }
    
    func lockViewAddCount()->Bool{
        if customActivityIndicatorView.isAnimating(){
            lockViewCount++
            return true
        }
        return false
    }
    
    func unlockView(){
        self.view.userInteractionEnabled = true
        customActivityIndicatorView.showText = nil
        customActivityIndicatorView.stopAnimating()
    }
    
    func unlockViewSubtractCount()->Bool{
        
        if !customActivityIndicatorView.isAnimating(){
            return true
        }
        
        lockViewCount--;
        if lockViewCount<0{
            lockViewCount = 0
        }
        if lockViewCount == 0{
            self.unlockView()
        }
        return true
    }
    
    func createViewFrame()->CGRect{
        var frame :CGRect=CGRect()
        frame.origin.x = 0
        frame.origin.y = 0
        frame.size.width = UIScreen.mainScreen().applicationFrame.size.width
        frame.size.height = UIScreen.mainScreen().applicationFrame.size.height
        
        if  UIDevice.currentDevice().systemVersion.compare("7") >= 0{
            frame.origin.y = UIScreen.mainScreen().applicationFrame.origin.y
        }
        return frame
    }
    
    
    func didDataModuleNoticeSucess(baseDataModule:BaseDataModule, forBusinessType businessID: BusinessType){
        self.unlockViewSubtractCount()
        println("\(businessID)")
        println("sucess")
    }
    
    func didDataModuleNoticeFail(baseDataModule:BaseDataModule,forBusinessType businessID: BusinessType, forErrorCode errorCode:Int ,forErrorMsg errorMsg:String!)
    {
        self.unlockViewSubtractCount()
        println("\(businessID)")
        var error:String = ""; //= @"failMessage:";
        if !errorMsg{
            return
        }
        error = error.stringByAppendingString(errorMsg)
        var baseCustomMessageBox:  BaseCustomMessageBox = BaseCustomMessageBox(text:error ,forBackgroundImage:UIImage(named:NSLocalizedString("base_messagebox_background",tableName:Res_Image,comment:"")))
        baseCustomMessageBox.animation = true
        baseCustomMessageBox.autoCloseTimer = 1
        
        //    CustomMessageBox *customMessageBox = [[CustomMessageBox alloc] initWithTitle:NSLocalizedStringFromTable(@"Message",Res_String,@"") forText:error forLeftButtonText:nil forRightButtonText:nil forIconImage:[UIImage imageNamed:NSLocalizedStringFromTable(@"messagebox_title_icon",Res_Image,@"")]];
        //    customMessageBox.lbl_text.textAlignment = NSTextAlignmentCenter;
        self.view.addSubview(baseCustomMessageBox)
        println("\(error)")
        
    }
    
    deinit{
//        if self.view.isKindOfClass(TitleBarView){
//            (self.view as TitleBarView).customTitleBar.buttonEventObserver = nil
//        }
    }
}