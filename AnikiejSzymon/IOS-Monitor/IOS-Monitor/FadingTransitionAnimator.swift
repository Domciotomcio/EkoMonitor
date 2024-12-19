//
//  FadingTransitionAnimator.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//

import UIKit

class FadingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let direction: CGFloat // 1 for right-to-left, -1 for left to right
    init(direction: CGFloat) {
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let screenWidth = containerView.bounds.width
        
        toView.frame = containerView.frame.offsetBy(dx: direction*screenWidth, dy: 0)
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.frame = containerView.frame
            fromView.frame = containerView.frame.offsetBy(dx: -self.direction*screenWidth, dy: 0)
            fromView.alpha = 0.5
            toView.alpha = 1.0
        }, completion: { finished in
            fromView.alpha = 1.0
            transitionContext.completeTransition(finished)})
    }
}
