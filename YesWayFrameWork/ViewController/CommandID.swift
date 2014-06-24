//
//  CommandID.swift
//  YesWayFrameWork
//
//  Created by jayden on 14-6-14.
//  Copyright (c) 2014年 95190. All rights reserved.
//

import Foundation


enum CommandID:Int{
    //MC是message command的首字母大写
    case   MC_CREATE_NORML_VIEWCONTROLLER = 1              //普通建立
    case   MC_CREATE_SCROLLERFROMLEFT_VIEWCONTROLLER       //滚动建立从左
    case   MC_CREATE_SCROLLERFROMRIGHT_VIEWCONTROLLER      //滚动建立从右
    case   MC_CREATE_GRADUALLYINTO_VIEWCONTROLLER          //渐入建立
    case   MC_CREATE_GRADUALLYOUT_VIEWCONTROLLER           //淡出建立
    case   MC_CREATE_FLIPFROMLEFT_VIEWCONTROLLER           //翻滚建立从左
    case   MC_CREATE_PUSHFROMLEFT_VIEWCONTROLLER           //推入建立从左
    case   MC_CREATE_PUSHFROMRIGHT_VIEWCONTROLLER          //推入建立从右
    case   MC_CREATE_OPENFROMRIGHT_VIEWCONTROLLER          //打开方式建立
    case   MC_CREATE_CLOSEFROMRIGHT_VIEWCONTROLLER         //关闭方式建立
    case   MC_CHILD_NODE_CLEAR_VALUE                     //删除所属所有子节点的保存值
}