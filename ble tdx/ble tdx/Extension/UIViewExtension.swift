//
//  UIViewExtension.swift
//  farmland smk
//
//  Created by Hoang Tran on 10/26/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

extension UIView {
    func topMostController() -> UIViewController? {
        
        var controllersHierarchy = [UIViewController]()
        
        if var topController = self.window?.rootViewController {
            controllersHierarchy.append(topController)
            
            while let presented = topController.presentedViewController {
                
                topController = presented
                
                controllersHierarchy.append(presented)
            }
            
            var matchController :UIResponder? = viewContainingController()
            
            while matchController != nil && controllersHierarchy.contains(matchController as! UIViewController) == false {
                
                repeat {
                    matchController = matchController?.next
                    
                } while matchController != nil && matchController is UIViewController == false
            }
            
            return matchController as? UIViewController
            
        } else {
            return viewContainingController()
        }
    }
    
    func viewContainingController()->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}
