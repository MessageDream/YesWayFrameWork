//
//  CustomActivityIndicatorView.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
import UIKit

let ActivityIndicatorViewWidth:CGFloat = 60
let ActivityIndicatorViewHeight:CGFloat = 60

class CustomActivityIndicatorView : UIView{
    
    var backgroundView: UIView!
    var activityIndicatorView: UIActivityIndicatorView!
    var color:UIColor!{
    willSet{
        backgroundView.backgroundColor = newValue
    }
    }
    
    
    var showText:String!{
    willSet{
        if !newValue{
            if lbl_text{
                backgroundView.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width/2-ActivityIndicatorViewWidth/2,UIScreen.mainScreen().bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight)
                
                activityIndicatorView.frame = CGRectMake(backgroundView.bounds.size.width/2-ActivityIndicatorViewWidth/2,backgroundView.bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight)
                lbl_text.removeFromSuperview()
                lbl_text = nil
            }
            return
        }
        
        var size:CGSize  = (newValue as NSString).sizeWithFont(UIFont.systemFontOfSize(15), constrainedToSize:CGSizeMake(200, MAXFLOAT), lineBreakMode:NSLineBreakMode.ByWordWrapping)
        
        var backgroundViewFrame:CGRect  = backgroundView.frame
        backgroundViewFrame.size.width = size.width
        backgroundViewFrame.size.height = size.height+activityIndicatorView.bounds.size.height+10
        backgroundViewFrame.origin.x = UIScreen.mainScreen().bounds.size.width/2-size.width/2
        backgroundViewFrame.origin.y = UIScreen.mainScreen().bounds.size.height/2-size.height/2
        backgroundView.frame = backgroundViewFrame
        
        lbl_text = UILabel(frame:CGRectMake(0, 10,size.width, size.height))
        lbl_text.backgroundColor = UIColor.clearColor()
        lbl_text.textAlignment = NSTextAlignment.Center
        lbl_text.text = newValue
        lbl_text.font = UIFont.systemFontOfSize(15)
        lbl_text.textColor = UIColor(red:153.0/255.0 ,green:153.0/255.0,blue:153.0/255.0 , alpha:1)
        lbl_text.numberOfLines = 0;
        backgroundView.addSubview(lbl_text)
        
        var activityIndicatorViewFrame:CGRect  = activityIndicatorView.frame
        activityIndicatorViewFrame.origin.x = backgroundViewFrame.size.width/2-activityIndicatorViewFrame.size.width/2
        activityIndicatorViewFrame.origin.y = lbl_text.frame.origin.y+lbl_text.frame.size.height
        activityIndicatorView.frame = activityIndicatorViewFrame;
    }
    }
    var lbl_text:UILabel!
    
    override var alpha: CGFloat{
    willSet{
        backgroundView.alpha = newValue
    }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width/2-ActivityIndicatorViewWidth/2,UIScreen.mainScreen().bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight))
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 6.0
        backgroundView.layer.borderWidth = 0.7
        backgroundView.backgroundColor = UIColor.blackColor()
        self.addSubview(backgroundView)
        
        
        activityIndicatorView = UIActivityIndicatorView(frame:CGRectMake(backgroundView.bounds.size.width/2-ActivityIndicatorViewWidth/2,backgroundView.bounds.size.height/2-ActivityIndicatorViewHeight/2,ActivityIndicatorViewWidth,ActivityIndicatorViewHeight))
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        backgroundView.addSubview(activityIndicatorView)
        
        
        self.hidden = true
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    
    func startAnimating(){
        self.hidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating(){
        self.hidden = true
        activityIndicatorView.stopAnimating()
    }
    func isAnimating()->Bool{
     return activityIndicatorView.isAnimating()
    }
}



