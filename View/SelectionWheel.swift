//
//  SelectionWheel.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SelectionWheelDatasource {
    func imageForSliceAtIndex(_ index:Int) -> UIImage
}

protocol SelectionWheelDelegate {
    func updateIndex(_ index:Int)
}

class SelectionWheel: UIView {
    
    var layers = [CAShapeLayer]()
    var imgViews = [UIImageView]()
    var currentIndex = -1
    var orig : CGAffineTransform!
    
    var globe : UIImageView!
    
    var datasource : SelectionWheelDatasource!
    var delegate : SelectionWheelDelegate!
    
    func rotate90() {
        transform = transform.rotated(by: CGFloat(-M_PI_2))
        orig = transform
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        //backgroundColor = UIColor.blueColor()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.check(_:)))
        addGestureRecognizer(tap)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func check(_ sender : UITapGestureRecognizer) {
        let point = sender.location(in: self)
        var i = 0
        
        for shape in layers {
            
            if (shape.path!.contains(point)) {
                click(i)
                return
            }
            i += 1
        }
    }
    
    
    func createCenterCircle(_ center : CGPoint, radius : CGFloat, color : UIColor, angle : CGFloat, index: Int)  -> CAShapeLayer {
        return createCircle(center, radius: radius, color: color, angle : angle, index : index, isCenter : true)
    }
    
    func createEventCircle(_ center : CGPoint, radius : CGFloat, color : UIColor, angle : CGFloat, index : Int)  -> CAShapeLayer {
        return createCircle(center, radius: radius, color: color, angle : angle, index : index, isCenter : false)
    }
    
    
    
    func createCircle(_ center : CGPoint, radius : CGFloat, color : UIColor, angle : CGFloat, index : Int, isCenter : Bool) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        
        
        
        
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        
        
        
        if !isCenter {
            
            
            shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            
            
            let image = datasource.imageForSliceAtIndex(index)
            
            
            
            let imgV = UIImageView(frame : CGRect(x: 0,y: 0, width: 159/3, height: 191/3))
            imgV.image = image
            
            
            
            addSubview(imgV)
            
            
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            
            
            /*
            let scale = CGAffineTransformMakeScale(0.1, 0.1)
            let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            cell.tickedImg.transform = CGAffineTransformConcat(rotate, scale)
            */
            
            
            let rotate = CGAffineTransform(rotationAngle: CGFloat(M_PI_2) + angle)
            
            imgV.center = CGPoint(x: circlePath.bounds.midX + cos(angle) * 10, y: circlePath.bounds.midY + sin(angle) * 10)
            
            imgV.transform = rotate
            
            imgViews.append(imgV)
            layers.append(shapeLayer)
            
        }
            
        else {
            
            
            shapeLayer.fillColor = color.cgColor
            
            
        }
        shapeLayer.strokeColor = UIColor.clear.cgColor
        
        return shapeLayer
        
    }
    
    
    
    func reset() {
        
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        
    }
    
    func setup() {
        
        reset()
        
        let radius = min((frame.size.width - 150)/2, 200)
        
        
        let centerPoint = CGPoint(x: center.x - frame.origin.x, y: center.y - self.frame.origin.y)
        
        layer.addSublayer(createCenterCircle(centerPoint, radius: radius, color : ColorManager.centerWheelColor, angle: 0, index: 0))
        
        
        let width = radius - 25
        globe = UIImageView(frame: CGRect(x: 0, y: 0, width: width*2, height: width*2))
        globe.center = centerPoint
        globe.image = UIImage(named: "globe")
        
        addSubview(globe)
        
        
        for i in 0...0 {
            
            
            
            let a:CGFloat = CGFloat(M_PI)
            let b:CGFloat = CGFloat(2)
            let fakeC = CGFloat(i)/5.0
            let c:CGFloat = CGFloat(fakeC)
            
            
            let firstPoint = CGPoint(x: centerPoint.x + radius*cos(CGFloat(a*b*c)), y: centerPoint.y + radius*sin(CGFloat(a*b*c)))
            
            
            
            layer.addSublayer(createEventCircle(firstPoint, radius: CGFloat(151/4), color : UIColor.green, angle : a*b*c, index: i))
            
        }
        
        
        
        
        
        
        
        
        
        rotate90()
        
    }
    
    func click(_ index : Int) {
        
        if(currentIndex == index)  {
            return
        }
        
        
        
        let oneSlice = CGFloat(-M_PI) * CGFloat(2) / CGFloat(layers.count)
        let diff = CGFloat(index)
        
        
        
        let rotate = CGAffineTransform(rotationAngle: diff*oneSlice)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            let r = self.orig.concatenating(rotate)
            
            if self.currentIndex != -1 {
                let zoomCurrent = CGAffineTransform(scaleX: 1/1.4, y: 1/1.4)
                let saveTransformCurrent = self.imgViews[self.currentIndex].transform
                self.imgViews[self.currentIndex].transform = saveTransformCurrent.concatenating(zoomCurrent)
            }
            
            let zoom = CGAffineTransform(scaleX: 1.4, y: 1.4)
            let saveTransform = self.imgViews[index].transform
            self.imgViews[index].transform = saveTransform.concatenating(zoom)
            
            self.transform = r
        })
        
        currentIndex = index
        
        delegate.updateIndex(currentIndex)
        
    }
    
}
