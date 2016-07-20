//
//  TheFirstViewController.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TheFirstViewController: UICollectionViewController {
    
    private let identifier = "fristCell"
    
    var browserAnimator : YJBrowserAnimator = YJBrowserAnimator()
    
    private lazy var imageArr = [UIImage]()
    
    var isMask : Bool = false
    
    private var curPath : NSIndexPath?
    private var lastPath : NSIndexPath?
    
    private var imageView : UIImageView?
    private var cell : TheFirstCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerClass(TheFirstCell.self, forCellWithReuseIdentifier: identifier)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        // 添加长按手势
        let longGest = UILongPressGestureRecognizer(target: self, action: "longGestHandle:")
        collectionView?.addGestureRecognizer(longGest)
        
        
        for i in 1...20{
            let image = UIImage(named: "\(i)")
            imageArr.append(image!)
        }
        
    }
}

extension TheFirstViewController{
    func longGestHandle(longGest : UILongPressGestureRecognizer){
        
        switch longGest.state{
        case .Began :
            // 获取点击的点
            let touchP = longGest.locationInView(collectionView)
            
            // 拿到这个点对应的indexPath
            guard let indexPath = collectionView?.indexPathForItemAtPoint(touchP) else {return}
            
            // 记录
            curPath = indexPath
            lastPath = indexPath
            
            // 拿到indexPath对应的cell
            let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! TheFirstCell
            self.cell = cell
            
            let imageView = UIImageView()
            imageView.frame = cell.frame
            imageView.image = cell.image
            imageView.transform = CGAffineTransformMakeScale(1.15, 1.15)
            collectionView?.addSubview(imageView)
            self.imageView = imageView
            
        case .Changed :
            
            cell?.alpha = 0
            
            // 获取手指的位置
            let touchP = longGest.locationInView(collectionView)
            imageView?.center = touchP
            
            // 根据手指位置获取对应的indexpath
            let indexPath = collectionView?.indexPathForItemAtPoint(touchP)
            
            if (indexPath != nil) {
                curPath = indexPath
                
                collectionView?.moveItemAtIndexPath(lastPath!, toIndexPath: curPath!)
            }
            
            
            // 修改数据源
            if lastPath != nil{
            let lastImg = imageArr[lastPath!.item]
            imageArr.removeAtIndex(lastPath!.item)
            imageArr.insert(lastImg, atIndex: curPath!.item)
            
            lastPath = curPath
            }
            
        case .Ended :
            
            imageView?.removeFromSuperview()
            
            cell?.alpha = 1
            
        default : break
        }
        
    }
}



// MARK: - 数据源和代理
extension TheFirstViewController{
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! TheFirstCell
        
        cell.image = imageArr[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let browserVC = YJBrowserViewController()
        browserVC.indexPath = indexPath
        browserVC.imageArr = imageArr
        
        browserVC.modalPresentationStyle = .Custom
        browserVC.transitioningDelegate = browserAnimator
        browserAnimator.indexPath = indexPath
        browserAnimator.presentDelegate = self
        browserAnimator.dismissDelegate = browserVC
        browserAnimator.isMask = self.isMask
        
        presentViewController(browserVC, animated: true, completion: nil)
    }
    
}

extension TheFirstViewController : PresentedProtocol{
    func getImageView(indexPath: NSIndexPath) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! TheFirstCell
        imageView.image = cell.imageView.image
        
        return imageView
    }
    
    func getStartRect(indexPath: NSIndexPath) -> CGRect {
        
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? TheFirstCell
        
        if cell == nil{
            return CGRectZero
        }
        
        let startRect =  collectionView!.convertRect(cell!.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startRect
    }
    
    func getEndRect(indexPath: NSIndexPath) -> CGRect {
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! TheFirstCell
        return calculateWithImage(cell.imageView.image!)
    }
    
    func getEndCell(indexPath: NSIndexPath) -> TheFirstCell? {
        
        var cell = collectionView?.cellForItemAtIndexPath(indexPath) as? TheFirstCell
        
        if cell == nil{
            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Right, animated: false)
            cell = collectionView?.cellForItemAtIndexPath(indexPath) as? TheFirstCell
            return cell
        }
        
        return cell!
    }
}

