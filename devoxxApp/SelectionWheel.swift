//
//  SelectionWheel.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class SelectionWheel: UIView {
    
    var layers = [CAShapeLayer]()
    
    func rotate90() {
        transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.blueColor()
    
        let tap = UITapGestureRecognizer(target: self, action: Selector("check:"))
        addGestureRecognizer(tap)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func check(sender : UITapGestureRecognizer) {
        let point = sender.locationInView(self)
        var i = 0
        print(layers.count)
        for shape in layers {
            print("loop")
            if CGPathContainsPoint(shape.path, nil, point, false) {
                print(i)
                return
            }
            ++i
        }
    }
    
    
    
    func createCircle(center : CGPoint, radius : CGFloat, color : UIColor) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        //shapeLayer.bounds = CGPathGetBoundingBox(shapeLayer.path)
        //change the fill color
        shapeLayer.fillColor = color.CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = color.CGColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        
        layers.append(shapeLayer)
        
        return shapeLayer
        
    }
    
    
    
    func reset() {
    
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        
    }
    
    func setup() {
        
        reset()
        
        let radius = 0.3*frame.size.width
        
        let centerPoint = CGPointMake(center.x - frame.origin.x, center.y - self.frame.origin.y)
        
        layer.addSublayer(createCircle(centerPoint, radius: radius, color : UIColor.redColor()))
        

        
        for i in 0...5 {
            
            
            let a:CGFloat = CGFloat(M_PI)
            let b:CGFloat = CGFloat(2)
            let fakeC = CGFloat(i)/5.0
            let c:CGFloat = CGFloat(fakeC)
            
            print("i= \(i), c= \(c)")
            print(cos(a*b*c))
            print(sin(a*b*c))
            print(c)
            
            let firstPoint = CGPointMake(centerPoint.x + radius*cos(CGFloat(a*b*c)), centerPoint.y + radius*sin(CGFloat(a*b*c)))
            
            print(firstPoint)
            
            layer.addSublayer(createCircle(firstPoint, radius: 30, color : UIColor.greenColor()))
            
        }
        
        rotate90()
    
    }
    
    
}