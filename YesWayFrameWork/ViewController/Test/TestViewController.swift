//
//  Test1.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
import UIKit

class TestViewCotroller:BaseViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        var rootView=UIView(frame:self.createViewFrame())
        
        var btn=UIButton(frame:CGRectMake(50, 50,  200,  50))
        btn.setTitle("Test", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "Test", forControlEvents: UIControlEvents.TouchUpInside)
        rootView.addSubview(btn)
        rootView.backgroundColor=UIColor.greenColor()
        self.view=rootView
    }

    func Test(){
        var user:TestUser=TestUser()
        user.observer=self
        user.login("15605842515", password: "123456")
        self.lockView()
    }
}
