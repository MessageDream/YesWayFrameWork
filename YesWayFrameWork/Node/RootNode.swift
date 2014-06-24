//
//  RootNode.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-15.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
import UIKit

class NodeRoot : BaseNode{
    var window:UIWindow!
    
    init(){
        super.init()
        nodeId = NodeAndViewControllerID.NODE_ROOT;
        workRange.location = NodeAndViewControllerID.NODE_ROOT.toRaw()
    }
    
    override func createChildNode()->Bool{
        //        var testNode :TestNode = TestNode()
        //        testNode.rootViewController = self.rootViewController
        //        testNode.parentNode = self
        //        testNode.createChildNode()
        //        //    [_childNode setObject:testNode forKey:[NSString stringWithFormat:@"%d",testNode.nodeId]];
        //
        //       var systemNode:SystemNode = SystemNode()
        //        systemNode.rootViewController = self.rootViewController
        //        systemNode.parentNode = self
        //        systemNode.createChildNode()
        //        //    [_childNode setObject:systemNode forKey:[NSString stringWithFormat:@"%d",systemNode.nodeId]];
        //
        //        var appletNode:AppletNode = AppletNode()
        //        appletNode.rootViewController = self.rootViewController
        //        appletNode.parentNode = self
        //        appletNode.createChildNode
        //    [_childNode setObject:appletNode forKey:[NSString stringWithFormat:@"%d",appletNode.nodeId]];
        //        childNode=[NSDictionary dictionaryWithObjects:@[testNode,systemNode,appletNode] forKeys:@[[NSString stringWithFormat:@"%d",testNode.nodeId],[NSString stringWithFormat:@"%d",systemNode.nodeId ],[NSString stringWithFormat:@"%d",appletNode.nodeId]]];
        return true
    }
    
    func allNodeClearValue(){
        for item in childNode{
            item.nodeClearValue()
        }
    }
    
    override func receiveMessage(message:Message)->Bool{
        if !super.receiveMessage(message){
            return false
        }
        
        if message.commandID == CommandID.MC_CHILD_NODE_CLEAR_VALUE{
            self.allNodeClearValue()
        }
        //    BaseNode *node = [self checkChildNodeWorkRange:message.receiveObjectID];
        //
        //    if(node==nil)
        //    {
        //        BaseViewController *viewcontroller;
        //        if(message.receiveObjectID == VIEWCONTROLLER_TEST2)
        //        {
        //            viewcontroller = [[test2ViewController alloc] initWithNibName:@"test2ViewController" bundle:nil];
        //        }
        //        else if(message.receiveObjectID == VIEWCONTROLLER_TEST3)
        //        {
        //            viewcontroller = [[testProductViewController alloc] initWithNibName:@"testProductViewController" bundle:nil];
        //        }
        //        if(viewcontroller != nil)
        //            [self addViewControllToRootViewController:viewcontroller forMessage:message];
        //    }
        
        return true
    }
}