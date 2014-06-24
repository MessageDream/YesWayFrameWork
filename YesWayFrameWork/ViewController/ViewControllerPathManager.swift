//
//  ViewControllerPathManager.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
var viewControllerPathArray:NodeAndViewControllerID[]=NodeAndViewControllerID[]()

class ViewControllerPathManager:NSObject{
    
    class func addViewControllerID(viewControllerID:NodeAndViewControllerID){
        //        if viewControllerPathArray == nil{
        //            viewControllerPathArray =Array<NodeAndViewControllerID>[]()
        //        }
        //
        if viewControllerID != NodeAndViewControllerID.VIEWCONTROLLER_NONE{
            if ViewControllerPathManager.getCurrentViewControllerID() != viewControllerID{
                viewControllerPathArray.append(viewControllerID)
            }
        }
        
    }
    
    class func getCurrentViewControllerID()->NodeAndViewControllerID!{
        return viewControllerPathArray[viewControllerPathArray.endIndex]
    }
    
    class func getPreviousViewControllerID()->NodeAndViewControllerID!{
        var index: Int = viewControllerPathArray.count-2
        if index<0{
            return nil
        }
        return viewControllerPathArray[index]
    }
    
    class func getPreviousViewControllerIDWithDelete()->NodeAndViewControllerID!{
        var number = ViewControllerPathManager.getPreviousViewControllerID()
        if number{
            ViewControllerPathManager.deleteLastViewControllerID()
        }
        return number
    }
    
    class func deleteViewControllerID(viewControllerID:NodeAndViewControllerID){
        var i:Int
        for i=0; i < viewControllerPathArray.count;++i{
            if viewControllerPathArray[i] == viewControllerID{
                break
            }
        }
        viewControllerPathArray.removeAtIndex(i)
    }
    
    class func deleteAllViewControllerID(){
        viewControllerPathArray.removeAll(keepCapacity: true)
    }
    
    class func deleteLastViewControllerID(){
        viewControllerPathArray.removeLast()
    }
    
    class func deleteViewControllerFromIDLater(viewControllerID:NodeAndViewControllerID){
        var index:Int
        for index=0; index < viewControllerPathArray.count;++index{
            if viewControllerPathArray[index] == viewControllerID{
                break
            }
        }
        if index == viewControllerPathArray.count-1{
            return
        }
        //    for
        //        var range:NSRange = _NSRange {
        //            location = index
        //            length = viewControllerPathArray.count-index
        //        }
        var end = viewControllerPathArray.count-1
        viewControllerPathArray[index+1...end]=[]
    }
}
