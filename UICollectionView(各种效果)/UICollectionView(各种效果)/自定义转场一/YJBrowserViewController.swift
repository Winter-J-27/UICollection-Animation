//
//  TheFirstViewController.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

private let reuseIdentifier : String = "BrowserCell"

class YJBrowserViewController: UIViewController {
    
    lazy var collectionView  = UICollectionView(frame: CGRectZero, collectionViewLayout: YJBrowserLayout())
    
    var indexPath : NSIndexPath?
    
    lazy var imageArr = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置子控件
        setUpChildView()
        
        // 注册cell
        collectionView.registerClass(YJBrowserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .Left, animated: false)
        
    }
}

extension YJBrowserViewController{
    
    func setUpChildView(){
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
}


// MARK:-collectionView的数据源和代理方法
extension YJBrowserViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! YJBrowserCell
        
        cell.image = imageArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK:- dismiss代理方法
extension YJBrowserViewController : dismissProtocol{
    
    func getImageView() -> UIImageView {
        // 获取当前显示的cell
        let cell =  collectionView.visibleCells().first as! YJBrowserCell
        
        let imageView = UIImageView()
        imageView.image = cell.imageView.image
        imageView.contentMode = .ScaleToFill
        imageView.clipsToBounds = true
        imageView.frame = cell.imageView.frame
        
        return imageView
    }
    
    func getEndRect() -> NSIndexPath {
        // 获取当前显示的cell
        let cell =  collectionView.visibleCells().first as! YJBrowserCell
        
        return collectionView.indexPathForCell(cell)!
    }
    
}

