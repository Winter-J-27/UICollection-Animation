//
//  AlbumCell.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/8.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView()
    
    
    
    var image : UIImage?{
        didSet{
            guard let image = image else{return}
            
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}
