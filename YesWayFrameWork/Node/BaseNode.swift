//
//  BaseNode.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-13.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

let AnimationDuration:Double = 0.5
var currentCommandID:CommandID!

class BaseNode:NSObject{
    var saveData: NSMutableDictionary!
    // var childNode:NSDictionary!
    var childNode:BaseNode[]!
    var nodeId:NodeAndViewControllerID!
    var workRange:NSRange = NSRange(location:0,length: NODE_WORK_LENGTH)
    
    var parentNode:BaseNode!
    var rootViewController:UIViewController!
    var previousViewController: BaseViewController!
    var holdViewController: BaseViewController!
    var showViewController:BaseViewController!
    
    init() {
    }
    
    func receiveMessage(message:Message)->Bool{
        var checkFlag:Bool = true
        if !self.checkWorkRange(message.receiveObjectID){
            checkFlag = false
        }
        if !checkFlag{
            var node:BaseNode!  = self.checkChildNodeWorkRange(message.receiveObjectID)
            if node {
                node.receiveMessage(message)
            }else{
                self.sendMessage(message)
                return false
            }
        }
        return true
    }
    
    func sendMessage(message:Message){
        if self.parentNode == nil{
            return
        }
        self.parentNode.receiveMessage(message)
    }
    
    
    func addViewControllToRootViewController(viewcontroller:BaseViewController, forMessage message:Message){
        //NSArray *a = self.rootViewController.childViewControllers;
        if currentCommandID == CommandID.MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER{
            holdViewController = self.rootViewController.childViewControllers[1] as BaseViewController
        }
        
        var currentViewcontroller=viewcontroller
        
        if self.rootViewController.childViewControllers.count>0{
            previousViewController = self.rootViewController.childViewControllers[0] as BaseViewController
            if message.commandID != CommandID.MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER{
                previousViewController.destroyDataBeforeDealloc()
            }else{
                currentViewcontroller = previousViewController
                previousViewController = holdViewController
            }
        }
        
        currentCommandID = message.commandID;
        currentViewcontroller.parentNode = self
        currentViewcontroller.receiveMessage(message)
        showViewController = currentViewcontroller
        if message.commandID != CommandID.MC_CREATE_NORML_VIEWCONTROLLER{
            showViewController.view.userInteractionEnabled = false
        }
        
        self.rootViewController.addChildViewController(currentViewcontroller)
        //a = self.rootViewController.childViewControllers;
        
        switch message.commandID!{
        case .MC_CREATE_NORML_VIEWCONTROLLER:
            self.animationDidStop()
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER:
            self .customAnimationBlock(currentViewcontroller,forCommandID:.MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER:
            self.animationSystemBlock(currentViewcontroller ,forDuration:AnimationDuration ,forType:kCATransitionPush, forSubtype:kCATransitionFromRight)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER:
            self.animationSystemBlock(currentViewcontroller ,forDuration:AnimationDuration ,forType:kCATransitionPush, forSubtype:kCATransitionFromLeft)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER:
            self .customAnimationBlock(previousViewController,forCommandID:message.commandID)
            self.rootViewController.view.insertSubview(currentViewcontroller.view,belowSubview:previousViewController.view)
        case .MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER:
            self.customAnimationBlock(currentViewcontroller,forCommandID:message.commandID)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER:
            self .customAnimationBlock(currentViewcontroller ,forCommandID:message.commandID)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER:
            self.customAnimationBlock(currentViewcontroller,forCommandID:message.commandID)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER:
            self.customAnimationBlock(currentViewcontroller ,forCommandID:message.commandID)
            self.rootViewController.view.addSubview(currentViewcontroller.view)
        case .MC_CREATE_GRADUALLYOUT_VIEWCONTROLLER:
            self.customAnimationBlock(currentViewcontroller, forCommandID:message.commandID)
            self.rootViewController.view.insertSubview(currentViewcontroller.view, belowSubview:previousViewController.view)
        default:
            return
        }
        //[viewcontroller receiveMessage:message];
        previousViewController.view.userInteractionEnabled = false
    }
    
    func createChildNode()->Bool{
        return false
    }
    
    func checkWorkRange(ID:NodeAndViewControllerID)->Bool{
        if ID != self.nodeId{
            var id=ID.toRaw()
            if  id < self.workRange.location || id > self.workRange.location+self.workRange.length{
                return false
            }
        }
        return true
    }
    
    func checkChildNodeWorkRange(ID:NodeAndViewControllerID)->BaseNode!{
        if childNode{
            for node in childNode {
                if node.checkWorkRange(ID){
                    return node
                }
                var cnode = node.checkChildNodeWorkRange(ID)
                if cnode {
                    return cnode
                }
            }
        }
        return nil
    }
    
    //-(BOOL)nodeSaveValue:(Message*)message;
    
    func nodeClearValue(){
        if saveData {
            saveData.removeAllObjects()
        }
    }
    
    func addNodeOfSaveData(key:String, forValue value:AnyObject){
        if saveData==nil{
            saveData = NSMutableDictionary()
        }
        saveData.setObject(value,forKey:key)
    }
    
    func getNodeOfSaveDataAtKey(key:String)->AnyObject{
        return saveData.objectForKey(key)
    }
    
    
    func animationSystemBlock(viewcontroller:BaseViewController, forDuration duration:Double ,forType type:String, forSubtype subtype:String){
        var animation: CATransition  = CATransition()
        animation.duration=duration
        animation.timingFunction=CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.delegate=self
        animation.type=type
        animation.subtype=subtype
        viewcontroller.view.layer.addAnimation(animation, forKey:"animation")
    }
    
    func customAnimationBlock(viewcontroller:BaseViewController, forCommandID ID:CommandID){
        switch ID {
        case .MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER:
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            
            var frame: CGRect  = viewcontroller.view.frame;
            frame.origin.x = UIScreen.mainScreen().bounds.size.width-100
            viewcontroller.view.frame = frame;
            UIView.commitAnimations()
            break
        case .MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER:
            var frame: CGRect  = viewcontroller.view.frame;
            frame.origin.x = UIScreen.mainScreen().bounds.size.width-100
            viewcontroller.view.frame = frame;
            
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            
            frame.origin.x = 0;
            viewcontroller.view.frame = frame;
            UIView.commitAnimations()
            break
        case .MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER:
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            UIView.transitionFromView(previousViewController.view, toView:viewcontroller.view ,duration:AnimationDuration, options:UIViewAnimationOptions.TransitionFlipFromLeft ,completion:nil)
            UIView.commitAnimations()
            break
            
        case .MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER:
            var newFrame: CGRect  = viewcontroller.view.frame
            newFrame.origin.x = newFrame.size.width
            viewcontroller.view.frame = newFrame
            
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            
            newFrame.origin.x = 0;
            viewcontroller.view.frame = newFrame;
            
            var previousFrame:CGRect  = previousViewController.view.frame;
            previousFrame.origin.x=previousFrame.origin.x-previousFrame.size.width
            previousViewController.view.frame = previousFrame
            UIView.commitAnimations()
            break
        case .MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER:
            var newFrame: CGRect  = viewcontroller.view.frame
            newFrame.origin.x = newFrame.origin.x - newFrame.size.width
            viewcontroller.view.frame = newFrame
            
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            
            newFrame.origin.x = 0;
            viewcontroller.view.frame = newFrame;
            
            var previousFrame: CGRect  = previousViewController.view.frame
            previousFrame.origin.x=previousFrame.size.width
            previousViewController.view.frame = previousFrame
            UIView.commitAnimations()
            break
        case .MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER:
            viewcontroller.view.alpha = 0.0
            
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            
            viewcontroller.view.alpha = 1.0
            UIView.commitAnimations()
            break
            
        case .MC_CREATE_GRADUALLYOUT_VIEWCONTROLLER:
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(AnimationDuration)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("animationDidStop")
            previousViewController.view.alpha = 0.0
            UIView.commitAnimations()
            break
        default:
            break
        }
    }
    
    override func animationDidStop(anim:CAAnimation,finished flag:Bool){
        self.animationDidStop()
    }
    
    func animationDidStop(){
        if previousViewController{
            if currentCommandID != CommandID.MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER{
                previousViewController.view.removeFromSuperview()
                previousViewController.removeFromParentViewController()
            }
            if holdViewController{
                holdViewController.view.removeFromSuperview()
                holdViewController.removeFromParentViewController()
                holdViewController = nil
            }
            previousViewController = nil
        }
        showViewController.view.userInteractionEnabled = true
        showViewController = nil
    }
}
