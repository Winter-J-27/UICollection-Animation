//
//  AppDelegate.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

// 全局函数
func calculateWithImage(image : UIImage) -> CGRect{
    
    let imageViewX : CGFloat = 0
    let imageViewW : CGFloat = UIScreen.mainScreen().bounds.width
    let imageViewH : CGFloat = imageViewW / image.size.width * image.size.height
    let imageViewY : CGFloat = (UIScreen.mainScreen().bounds.height - imageViewH) * 0.5
    
    return CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)
}

