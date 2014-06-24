//
//  BaseCustomMessageBox.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-16.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation
import UIKit

@objc protocol BaseCustomMessageBoxDelegate {
    @optional func messageBoxConfirmButton_onClick(sender:AnyObject)
    @optional func messageBoxCancelButton_onClick(sender:AnyObject)
    @optional func messageBoxDisappear(box:BaseCustomMessageBox)
}
let BaseCustomMessageBox_Width:CGFloat=280

class BaseCustomMessageBox : UIView{
    var backgroundImageView: UIImageView!
    var backgroundImage:UIImage!
    var  lbl_text:UILabel!
    var  text:String!
    var  autoCloseTimer:Double!{
    willSet{
        if timer{
            timer.invalidate()
            timer = nil
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(newValue, target:self, selector:"onTimer:", userInfo:nil, repeats:true)
    }
    }
    var animation:Bool=false
    var btn_cancel:UIButton!
    var btn_confirm:UIButton!
    
    var timer:NSTimer!
    var overView:UIView!
    
    var observer:BaseCustomMessageBoxDelegate!
    
    init(frame: CGRect) {
        super.init(frame:frame)
        // Initialization code
        
        var newFrame:CGRect=CGRect(origin:CGPoint(x:0,y:0),size:frame.size)
        backgroundImageView = UIImageView(frame:newFrame)
        backgroundImageView.contentMode = UIViewContentMode.ScaleToFill
        backgroundImageView.image = backgroundImage.resizableImageWithCapInsets(UIEdgeInsetsMake(20,20,backgroundImage.size.height-10,backgroundImage.size.width-10))
        self.addSubview(backgroundImageView)
        
        lbl_text = UILabel(frame:CGRectMake(10,10,newFrame.size.width-20, newFrame.size.height-20))
        lbl_text.backgroundColor = UIColor.clearColor()
        lbl_text.textAlignment = NSTextAlignment.Center
        lbl_text.text = text
        lbl_text.numberOfLines = 0
        lbl_text.font = UIFont.systemFontOfSize(15)
        lbl_text.textColor = UIColor.whiteColor()
        backgroundImageView.addSubview(lbl_text)
    }
    
    convenience init(text:String,forBackgroundImage image:UIImage){
        var height:Float  = 15
        var textFont:UIFont = UIFont.systemFontOfSize(15)
        var size:CGSize  = (text as NSString).sizeWithFont(textFont,constrainedToSize:CGSizeMake(BaseCustomMessageBox_Width-20, MAXFLOAT) , lineBreakMode:NSLineBreakMode.ByWordWrapping)
        height += size.height
        height += 15
        
        var frame: CGRect  = CGRectMake(UIScreen.mainScreen().bounds.size.width/2-BaseCustomMessageBox_Width/2, UIScreen.mainScreen().bounds.size.height/2-height/2, BaseCustomMessageBox_Width, height)
        self.init(frame:frame)
        self.backgroundImage = image
        self.text = text
    }
    
    func setButtonImageWithButtonText(buttonImage:UIImage!, forText text:String, forColor textColor:UIColor=UIColor.blackColor()){
        if buttonImage{
            var frame:CGRect  = self.frame
            frame.size.width = buttonImage.size.width+30
            frame.size.height += buttonImage.size.height+40
            frame.origin.x = UIScreen.mainScreen().bounds.size.width/2-frame.size.width/2
            frame.origin.y = UIScreen.mainScreen().bounds.size.height/2-frame.size.height/2
            self.frame = frame
            
            var backgroundImageViewFrame:CGRect  = backgroundImageView.frame
            backgroundImageViewFrame.size.width = self.bounds.size.width
            backgroundImageViewFrame.size.height = self.bounds.size.height
            backgroundImageView.frame = backgroundImageViewFrame
            
            var lbl_textFrame:CGRect  = lbl_text.frame
            lbl_textFrame.size.width = self.bounds.size.width-20
            lbl_textFrame.size.height = self.bounds.size.height-buttonImage.size.height-20
            lbl_text.frame = lbl_textFrame
            
            btn_cancel = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            btn_cancel.frame = CGRectMake(self.bounds.size.width/2-buttonImage.size.width/2,self.bounds.size.height-buttonImage.size.height-10,buttonImage.size.width,buttonImage.size.height)
            btn_cancel.titleLabel.font = UIFont.systemFontOfSize(14)
            btn_cancel.titleLabel.textColor = textColor
            btn_cancel.setTitle(text ,forState:UIControlState.Normal)
            btn_cancel.setBackgroundImage(buttonImage ,forState:UIControlState.Normal)
            btn_cancel.addTarget(self,action:"messageBoxCancelButton_onClick:", forControlEvents:UIControlEvents.TouchUpInside)
            self.addSubview(btn_cancel)
        }
        
    }
    
    func setConfirmAndCancelButtonImageWithButtonText(confirmButtonImage:UIImage!, forLeftText confirmText:String!, forLeftColor confirmTextColor:UIColor=UIColor.blackColor(), forRightButtonImage cancelButtonImage:UIImage!, forRightText cancelText:String!, forRightColor cancelTextColor:UIColor=UIColor.blackColor()){
        if confirmButtonImage != nil && cancelButtonImage != nil {
            var frame:CGRect  = self.frame
            frame.size.width = confirmButtonImage.size.width*2+10+30
            frame.size.height += confirmButtonImage.size.height+40
            frame.origin.x = UIScreen.mainScreen().bounds.size.width/2-frame.size.width/2
            frame.origin.y = UIScreen.mainScreen().bounds.size.height/2-frame.size.height/2
            self.frame = frame
            
            var backgroundImageViewFrame: CGRect  = backgroundImageView.frame
            backgroundImageViewFrame.size.width = self.bounds.size.width
            backgroundImageViewFrame.size.height = self.bounds.size.height
            backgroundImageView.frame = backgroundImageViewFrame
            
            var lbl_textFrame: CGRect  = lbl_text.frame
            lbl_textFrame.size.width = self.bounds.size.width-20
            lbl_textFrame.size.height = self.bounds.size.height-confirmButtonImage.size.height-20
            lbl_text.frame = lbl_textFrame;
            
            btn_confirm = UIButton.buttonWithType(UIButtonType.Custom)  as UIButton
            btn_confirm.frame = CGRectMake(10,self.bounds.size.height-confirmButtonImage.size.height-10,confirmButtonImage.size.width,confirmButtonImage.size.height)
            btn_confirm.titleLabel.font = UIFont.systemFontOfSize(14)
            btn_confirm.titleLabel.textColor = confirmTextColor
            btn_confirm.setTitle(confirmText ,forState:UIControlState.Normal)
            btn_confirm.setBackgroundImage(confirmButtonImage, forState:UIControlState.Normal)
            btn_confirm.addTarget(self, action:"messageBoxConfirmButton_onClick:", forControlEvents:UIControlEvents.TouchUpInside)
            self.addSubview(btn_confirm)
            
            btn_cancel = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
            btn_cancel.frame = CGRectMake(btn_confirm.frame.origin.x+btn_confirm.frame.size.width+20,self.bounds.size.height-cancelButtonImage.size.height-10,cancelButtonImage.size.width,cancelButtonImage.size.height)
            btn_cancel.titleLabel.font = UIFont.systemFontOfSize(14)
            btn_cancel.titleLabel.textColor = cancelTextColor
            btn_cancel.setTitle(cancelText,forState:UIControlState.Normal)
            btn_cancel.setBackgroundImage(cancelButtonImage ,forState:UIControlState.Normal)
            btn_cancel.addTarget(self, action:"messageBoxCancelButton_onClick:", forControlEvents:UIControlEvents.TouchUpInside)
            self.addSubview(btn_cancel)
        }
    }
    
    func close(){
        overView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func onTimer(sender:AnyObject){
        if animation{
            self.alpha = 1
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(0.6)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            self.alpha = 0
            UIView.commitAnimations()
        }
        timer.invalidate()
        timer = nil
        //self.performSelector("close",withObject:nil ,afterDelay:1)
        self.close()
        self.observer.messageBoxDisappear!(self)
    }
    
    @IBAction func messageBoxConfirmButton_onClick(sender:AnyObject){
        if self.observer{
            self.observer.messageBoxConfirmButton_onClick!(self)
        }
        overView.removeFromSuperview()
        self.removeFromSuperview()
        
    }
    
    @IBAction func messageBoxCancelButton_onClick(sender:AnyObject){
        if self.observer{
            self.observer.messageBoxCancelButton_onClick!(self)
        }
        overView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    override  func didMoveToSuperview(){
        overView = UIView(frame:UIScreen.mainScreen().bounds)
        overView.backgroundColor = UIColor.clearColor()
        self.superview.insertSubview(overView, belowSubview:self)
        
        if animation{
            self.alpha = 0
            UIView.beginAnimations("Animation" ,context:nil)
            UIView.setAnimationDuration(0.6)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            self.alpha = 1
            UIView.commitAnimations()
        }
    }
}
