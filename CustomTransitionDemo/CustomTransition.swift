//
//  CustomTransition.swift
//  CustomTransitionDemo
//
//  Created by MingbaoZhu on 15/2/9.
//  Copyright (c) 2015年 yipinapp. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning{
    
    override init() {
        
    }

    var holdTransitionContext: UIViewControllerContextTransitioning!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval{
        return Double(0.7);
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        holdTransitionContext = transitionContext
        
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ViewController
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ToViewController
        
        var button = fromVC.button
        
        var containerView = transitionContext.containerView()
        /*
        UIButton *abutton = [[UIButton alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height)];
        abutton.backgroundColor = [UIColor blackColor];
        abutton.layer.cornerRadius = 24.0f;
        abutton.alpha = 0;
        abutton.transform = CGAffineTransformScale(abutton.transform, 0.1, 0.1);
        [fromVC.view addSubview:abutton];

        */
        
        var newButton = UIButton(frame: button.frame)
        newButton.backgroundColor = UIColor.blackColor()
        newButton.layer.cornerRadius = button.frame.size.height/2
        newButton.alpha = 0
        newButton.transform = CGAffineTransformScale(button.transform, 0.1, 0.1)
        toVC.view.addSubview(newButton)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            newButton.alpha = 1
            newButton.transform = CGAffineTransformIdentity
        }) { (Bool finished) -> Void in
            newButton.alpha = 0
            newButton.removeFromSuperview()
        }
        
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        var animatePath = UIBezierPath(ovalInRect: newButton.frame)
        
        var finalPoint: CGPoint
        
        if (newButton.frame.origin.x > (toVC.view.bounds.size.width/2)){
            if (button.frame.origin.y < toVC.view.bounds.size.height/2){
                finalPoint = CGPointMake(newButton.center.x - 0, newButton.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
            }else{
                finalPoint = CGPointMake(newButton.center.x, button.center.y)
            }
        }else{
            if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
                //第二象限
                finalPoint = CGPointMake(newButton.center.x - CGRectGetMaxX(toVC.view.bounds), newButton.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
            }else{
                //第三象限
                finalPoint = CGPointMake(newButton.center.x - CGRectGetMaxX(toVC.view.bounds), newButton.center.y - 0);
            }
        }
        
        var radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y)
        
        var startPath = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        
        var maskLayer = CAShapeLayer()
        maskLayer.frame = fromVC.view.bounds;
        maskLayer.path = animatePath.CGPath
        toVC.view.layer.mask = maskLayer

        var animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = animatePath.CGPath
        animation.toValue = startPath.CGPath
        animation.duration = transitionDuration(transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self;
        
        maskLayer.addAnimation(animation, forKey: "transition")
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        holdTransitionContext.completeTransition(!holdTransitionContext.transitionWasCancelled())
        var fromVC = holdTransitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as ViewController
        var toVC = holdTransitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as ToViewController
        
        fromVC.view.layer.mask = nil
        toVC.view.layer.mask = nil
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

}