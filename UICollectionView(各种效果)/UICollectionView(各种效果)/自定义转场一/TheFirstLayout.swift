//
//  TheFirstLayout.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

class TheFirstLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let margin : CGFloat = 10
        let row : CGFloat = 3
        
        let itemWH = (UIScreen.mainScreen().bounds.width - (row + 1) * margin) * 0.33
        
        collectionView?.contentInset = UIEdgeInsets(top: margin + 64, left: margin, bottom: margin, right: margin)
        
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
    }
    
}
