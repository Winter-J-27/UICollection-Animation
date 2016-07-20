//
//  AlbumLayout.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/8.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

enum AlbumType{
    case Vertical
    case Horizontal
}

class AlbumLayout: UICollectionViewFlowLayout {
    
    var albumType : AlbumType = AlbumType.Horizontal
    
    override func prepareLayout() {
        
        super.prepareLayout()
        
        if albumType == .Horizontal{
            layoutHorizontal()
        }else{
            layoutVertical()
        }
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}

extension AlbumLayout{
    
    class func identifier() -> String{
        return "AlbumCell"
    }
}

extension AlbumLayout{
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if albumType == .Horizontal{
            return layoutHorizontalAttributesForElementsInRect(rect)
        }
        
        return layoutVerticalAttributesForElementsInRect(rect)
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let arr = super.layoutAttributesForElementsInRect(CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: collectionView!.bounds.size)) else {return CGPointZero}
        
        var lesserDis = CGFloat(MAXFLOAT)
        
        var proposedContentOffsetX = proposedContentOffset.x
        
        for cellAttr in arr {
            
            let cellDistance = cellAttr.center.x - (collectionView!.bounds.width * 0.5 + proposedContentOffset.x)
            
            if fabs(cellDistance) < fabs(lesserDis) {
                lesserDis = cellDistance
            }
        }
        
        proposedContentOffsetX += lesserDis
        
        if proposedContentOffsetX < 0{
            proposedContentOffsetX = 0
        }
        
        return CGPoint(x: proposedContentOffsetX, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}


extension AlbumLayout{
    
    func layoutHorizontal(){
        let itemWH : CGFloat = 150
        itemSize = CGSize(width: itemWH, height: itemWH)
        scrollDirection = .Horizontal
        minimumLineSpacing = 50
        let margin = (UIScreen.mainScreen().bounds.width - itemWH) * 0.5
        sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    
    
    func layoutVertical(){
        let itemWH : CGFloat = UIScreen.mainScreen().bounds.width - 20
        itemSize = CGSize(width: itemWH, height: itemWH)
        scrollDirection = .Vertical
        minimumInteritemSpacing = 10
    }
    
    func layoutHorizontalAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?{
        
        guard let arr = super.layoutAttributesForElementsInRect(collectionView!.bounds) else{return nil}
        
        let cellAttrs = NSArray.init(array: arr, copyItems: true) as! [UICollectionViewLayoutAttributes]
        
        for cellAttr in cellAttrs {
            
            let offsetX = collectionView!.contentOffset.x
            
            let cellDistance = fabs(cellAttr.center.x - ((collectionView?.bounds.width)! * 0.5 + offsetX))
            
            let scale = 1 - cellDistance / ((collectionView?.bounds.width)! * 0.5) * 0.25
            
            cellAttr.transform = CGAffineTransformMakeScale(scale, scale)
            
        }
        return cellAttrs
    }
    
    
    func layoutVerticalAttributesForElementsInRect(rect : CGRect) -> [UICollectionViewLayoutAttributes]?{
        guard let arr = super.layoutAttributesForElementsInRect(collectionView!.bounds) else{return nil}
        
        //http://stackoverflow.com/questions/31508153/warning-uicollectionviewflowlayout-has-cached-frame-mismatch-for-index-path-ab/31508225#31508225
        
        let cellAttrs = NSArray.init(array: arr, copyItems: true) as! [UICollectionViewLayoutAttributes]
        
        for cellAttr in cellAttrs {
            
            let offsetX = collectionView!.contentOffset.y
            
            let cellDistance = fabs(cellAttr.center.y - ((collectionView?.bounds.height)! * 0.5 + offsetX))
            
            let scale = 1 - cellDistance / ((collectionView?.bounds.height)! * 0.5) * 0.25
            
            cellAttr.transform = CGAffineTransformMakeScale(scale, scale)
            
        }
        return cellAttrs
    }
    
}


