//
//  ViewController.swift
//  CustomTransitionDemo
//
//  Created by MingbaoZhu on 15/2/9.
//  Copyright (c) 2015年 yipinapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = button.frame.size.height/2
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if (operation == UINavigationControllerOperation.Push){
            var transition = CustomTransition()
            return transition
        }else{
            return nil
        }
        
    }

}

