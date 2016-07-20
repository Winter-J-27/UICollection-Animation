//
//  TheFirstViewController.swift
//  UICollectionView(各种效果)
//
//  Created by Ian on 16/7/5.
//  Copyright © 2016年 Ian. All rights reserved.


import UIKit

protocol PresentedProtocol : class{
    
    func getImageView(indexPath : NSIndexPath) -> UIImageView
    func getStartRect(indexPath : NSIndexPath) -> CGRect
    func getEndRect(indexPath : NSIndexPath) -> CGRect
    func getEndCell(indexPath : NSIndexPath) -> TheFirstCell?
}


protocol dismissProtocol : class{
    func getImageView() -> UIImageView
    func getEndRect() -> NSIndexPath
}

class YJBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    
    weak var presentDelegate : PresentedProtocol?
    weak var dismissDelegate : dismissProtocol?
    var indexPath : NSIndexPath?
    var isPresent : Bool = false
    var isMask : Bool = false
    var transitionContext : UIViewControllerContextTransitioning?
    
    // 告诉系统modal的动画由Animator来负责
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    // 告诉系统dismiss的动画由Animator来负责
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        return self
    }
}


extension YJBrowserAnimator : UIViewControllerAnimatedTransitioning{
    
    // 返回动画的执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    
    // 这个方法用来做具体的动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent{
            if isMask{
                maskPresentAnimate(transitionContext)
            }else{
                presentAnimate(transitionContext)
            }
        }else{
            
            if isMask{
                maskDismissAnimate(transitionContext)
            }else{
                dismissAnimate(transitionContext)
            }
        }
    }
}


//MARK:-modal出来的转场动画
extension YJBrowserAnimator{
    
    func presentAnimate(transitionContext : UIViewControllerContextTransitioning){
        
        // 获取用来做转场动画的"舞台"
        let containerView = transitionContext.containerView()
        containerView?.backgroundColor = UIColor.blackColor()
        
        // 获取modal出来的View
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        toView?.alpha = 0
        containerView?.addSubview(toView!)
        
        // 拿到delegate给的imageView
        guard let presentDelegate = presentDelegate else{
            return
        }
        
        let imageView = presentDelegate.getImageView(indexPath!)
        
        imageView.frame = presentDelegate.getStartRect(indexPath!)
        
        containerView?.addSubview(imageView)
        
        UIView .animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = presentDelegate.getEndRect(self.indexPath!)
            }) { (_) -> Void in
                toView?.alpha = 1
                imageView.removeFromSuperview()
                
                // 完成动画之后一定要调用这个方法,不然会出现很多意想不到的bug
                transitionContext.completeTransition(true)
        }
    }
}


extension YJBrowserAnimator{
    
    func dismissAnimate(transitionContext : UIViewControllerContextTransitioning){
        
        guard let dismissDelegate = dismissDelegate, presentDelegate = presentDelegate else{
            return
        }
        
        let containerView = transitionContext.containerView()
        containerView?.backgroundColor = UIColor.clearColor()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        fromView?.removeFromSuperview()
        
        let imageView = dismissDelegate.getImageView()
        
        containerView?.addSubview(imageView)
        
        let startRect = presentDelegate.getStartRect(dismissDelegate.getEndRect())
        
        guard let homeCell = presentDelegate.getEndCell(dismissDelegate.getEndRect()) else{
            UIView .animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                imageView.alpha = 0
                }) { (_) -> Void in
                    transitionContext.completeTransition(true)
            }
            return
        }
        
        homeCell.alpha = 0
        
        UIView .animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            
            if startRect == CGRectZero{
                imageView.alpha = 0
            }else{
                imageView.frame = startRect
            }
            
            }) { (_) -> Void in
                homeCell.alpha = 1
                transitionContext.completeTransition(true)
        }
    }
}


extension YJBrowserAnimator{
    
    func maskPresentAnimate(transitionContext : UIViewControllerContextTransitioning){
        
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()
        
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        transitionContext.containerView()!.addSubview(toView!)
        
        guard let presentDelegate = presentDelegate else{return}
        
        guard let indexPath = indexPath else{return}
        
        let imageView = presentDelegate.getImageView(indexPath)
        imageView.frame = presentDelegate.getStartRect(indexPath)
        
        let startCircle = UIBezierPath(ovalInRect: presentDelegate.getStartRect(indexPath))
        
        // 计算半径
        let x = max(imageView.center.x, UIScreen.mainScreen().bounds.width - imageView.center.x)
        let y = max(imageView.center.y, CGRectGetHeight(UIScreen.mainScreen().bounds) - imageView.center.y)
        
        let startRadius = sqrt(pow(x,2) + pow(y,2))
        
        let endPath = UIBezierPath(ovalInRect: CGRectInset(imageView.frame, -startRadius, -startRadius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = endPath.CGPath
        toView?.layer.mask = shapeLayer
        
        // 核心动画
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startCircle.CGPath
        animation.toValue = endPath.CGPath
        animation.duration = transitionDuration(transitionContext)
        animation.delegate = self
        shapeLayer.addAnimation(animation, forKey: "")
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if isMask{
            
            transitionContext?.completeTransition(true)
            transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
            transitionContext?.viewForKey(UITransitionContextFromViewKey)?.removeFromSuperview()
        }
    }
}


extension YJBrowserAnimator {
    
    func maskDismissAnimate(transitionContext : UIViewControllerContextTransitioning){
        
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 拿到要返回的尺寸
        let startRect = presentDelegate?.getStartRect((dismissDelegate?.getEndRect())!)
        let endPath = UIBezierPath(ovalInRect: startRect!)
        
        let radius = sqrt(pow((containerView?.frame.size.height)!,2) + pow((containerView?.frame.size.width)!,2)) / 2
        
        let startPath = UIBezierPath(arcCenter: containerView!.center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = endPath.CGPath
        shapeLayer.backgroundColor = UIColor.clearColor().CGColor
        fromView!.layer.mask = shapeLayer
        
        let animate = CABasicAnimation(keyPath: "path")
        animate.fromValue = startPath.CGPath
        animate.toValue = endPath.CGPath
        animate.duration = transitionDuration(transitionContext)
        animate.delegate = self
        shapeLayer.addAnimation(animate, forKey: "")
        
    }
}


