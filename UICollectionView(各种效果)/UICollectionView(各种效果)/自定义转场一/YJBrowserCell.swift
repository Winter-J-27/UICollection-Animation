//
//  YJBrowserCell.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

class YJBrowserCell: UICollectionViewCell {
    lazy var imageView : UIImageView = UIImageView()
    
    var image : UIImage?{
        didSet{
            guard let image = image else{return}
            
            imageView.frame = calculateWithImage(image)
            imageView.image = image
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentView.addSubview(imageView)
    }
}
