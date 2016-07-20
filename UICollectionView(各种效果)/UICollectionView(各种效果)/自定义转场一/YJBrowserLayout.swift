//
//  YJBrowserLayout.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

class YJBrowserLayout: UICollectionViewFlowLayout{
    
    override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        scrollDirection = .Horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        
    }
}
