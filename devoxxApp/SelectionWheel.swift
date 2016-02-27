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
    var currentIndex = 0
    
    
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
                click(i)
                return
            }
            ++i
        }
    }
    
    
    func createCenterCircle(center : CGPoint, radius : CGFloat, color : UIColor, angle : CGFloat)  -> CAShapeLayer {
        return createCircle(center, radius: radius, color: color, angle : angle, isCenter : true)
    }
    
    func createEventCircle(center : CGPoint, radius : CGFloat, color : UIColor, angle : CGFloat)  -> CAShapeLayer {
        return createCircle(center, radius: radius, color: color, angle : angle, isCenter : false)
    }
    
    
    
    func createCircle(center : CGPoint, radius : CGFloat, color : UIColor, angle : CGFloat, isCenter : Bool) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        
        
        
       
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath

        
        
        
        if !isCenter {
            
            
            shapeLayer.anchorPoint = CGPointMake(0.5, 0.5)
            
            
            let image = UIImage(named: "splash_btn_DevoxxFR2016.png")
            let colorImg = UIColor(patternImage: image!)
            //shapeLayer.fillColor = colorImg.CGColor
            
            let imgV = UIImageView(frame : CGRectMake(0,0, 159/2, 191/2))
            imgV.image = image
            imgV.center = CGPointMake(circlePath.bounds.midX, circlePath.bounds.midY)
           
            print("bounds = \(CGPointMake(shapeLayer.bounds.origin.x, shapeLayer.bounds.origin.y))")
            addSubview(imgV)
           
            
            shapeLayer.strokeColor = color.CGColor
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.lineWidth = 1.0
            
            
            /*
            let scale = CGAffineTransformMakeScale(0.1, 0.1)
            let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            cell.tickedImg.transform = CGAffineTransformConcat(rotate, scale)
            */
            
            
            let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_2) + angle)
            imgV.transform = rotate
            
            
            layers.append(shapeLayer)
        }
        
        else {
            
            shapeLayer.strokeColor = color.CGColor
            shapeLayer.fillColor = color.CGColor
            shapeLayer.lineWidth = 3.0
        
        }
       
        
        return shapeLayer
        
    }
    
    
    
    func reset() {
    
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        
    }
    
    func setup() {
        
        reset()
        
        let radius = (frame.size.width - 100)/2
        
        let centerPoint = CGPointMake(center.x - frame.origin.x, center.y - self.frame.origin.y)
        
        layer.addSublayer(createCenterCircle(centerPoint, radius: radius, color : UIColor.redColor(), angle: 0))
        

        
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
            
            layer.addSublayer(createEventCircle(firstPoint, radius: CGFloat(191/4), color : UIColor.greenColor(), angle : a*b*c))
            
        }
        
        rotate90()
    
    }
    
    func click(index : Int) {
        
        
        
        let a:CGFloat = CGFloat(M_PI)
        let b:CGFloat = CGFloat(2)
        let fakeC = CGFloat(currentIndex - index)/CGFloat(layers.count)
        
        
        let rotate = CGAffineTransformMakeRotation(a*b*fakeC)
        transform = rotate
        
        currentIndex = index
        
    }
    
}