//
//  UIViewExtension.swift
//  ContactTest
//
//  Created by smile on 2017/3/28.
//  Copyright © 2017年 ayang. All rights reserved.
//

import Foundation
import UIKit

// MARK:- | ****** view的扩展 ****** |
extension UIView {
    
    
    /// x
    var x : CGFloat {
        
        get {
            
            return frame.origin.x
        }
        
        set {
            
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newValue
            frame                 = tmpFrame
        }
    }
    
    /// y
    var y : CGFloat {
        
        get {
            
            return frame.origin.y
        }
        
        set {
            
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newValue
            frame                 = tmpFrame
        }
    }
    
    /// height
    var height : CGFloat {
        
        get {
            
            return frame.size.height
        }
        
        set {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newValue
            frame                 = tmpFrame
        }
    }
    
    /// width
    var width : CGFloat {
        
        get {
            
            return frame.size.width
        }
        
        set {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newValue
            frame                 = tmpFrame
        }
    }
    
    /// left
    var left : CGFloat {
        
        get {
            
            return x
        }
        
        set {
            
            x = newValue
        }
    }
    
    /// right
    var right : CGFloat {
        
        get {
            
            return x + width
        }
        
        set {
            
            x = newValue - width
        }
    }
    
    /// top
    var top : CGFloat {
        
        get {
            
            return y
        }
        
        set {
            
            y = newValue
        }
    }
    
    /// bottom
    var bottom : CGFloat {
        
        get {
            
            return y + height
        }
        
        set {
            
            y = newValue - height
        }
    }
    
    /// 中心点X
    var centerX : CGFloat {
        
        get {
            
            return center.x
        }
        
        set {
            
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    
    /// 中心点Y
    var centerY : CGFloat {
        
        get {
            
            return center.y
        }
        
        set {
            
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    
    
    /// 自身中点X
    var middleX : CGFloat {
        
        get {
            
            return width / 2
        }
    }
    
    /// 自身中点Y
    var middleY : CGFloat {
        
        get {
            
            return height / 2
        }
    }
    
    /// 自身中点
    var middlePoint : CGPoint {
        
        get {
            
            return CGPoint(x: middleX, y: middleY)
        }
    }
}
