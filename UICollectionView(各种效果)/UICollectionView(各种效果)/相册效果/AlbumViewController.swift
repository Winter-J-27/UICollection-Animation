//
//  AlbumViewController.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/8.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let ScreenW = UIScreen.mainScreen().bounds.size.width
    private let ScreenH = UIScreen.mainScreen().bounds.size.height
    
    var albumType : AlbumType = AlbumType.Horizontal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建UIColleciontView
        setUpUI()
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func setUpUI(){
        
        
        let collectionView = self.collectionView()
        
        view.addSubview(collectionView)
        
        collectionView.registerClass(AlbumCell.self, forCellWithReuseIdentifier: AlbumLayout.identifier())
        
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        
//        collectionView.backgroundColor = UIColor.init(patternImage: UIImage(named: "back.png")!)
    }
}


extension AlbumViewController : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AlbumLayout.identifier(), forIndexPath: indexPath) as! AlbumCell
        
        let image = UIImage(named: "\(indexPath.row + 1)")
        
        cell.image = image
        
        return cell
    }
    
}

extension AlbumViewController {
    func collectionView() -> UICollectionView {
        
        if albumType == .Horizontal {
            let collectionView = UICollectionView(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenW, height: 300)), collectionViewLayout: AlbumLayout())
            collectionView.center = view.center
            
            return collectionView
        }
        
        let albumLayout : AlbumType = albumType
        let collectionLayout = AlbumLayout()
        collectionLayout.albumType = albumLayout
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH), collectionViewLayout:collectionLayout)
        
        return collectionView
    }
}
