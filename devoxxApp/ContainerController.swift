//
//  ContainerController.swift
//  MDRotatingPieChart
//
//  Created by Maxime DAVID on 2015-04-03.
//  Copyright (c) 2015 Maxime DAVID. All rights reserved.
//

import UIKit


class ContainerController: UIViewController {
    
    var pieChart:MDRotatingPieChart!
    var goButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initi(){
        
        
        let color = UIColor(red: 248/255, green: 185/255, blue: 17/255, alpha: 1)
        

        
        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, 380, 380))
        pieChart.textLabel = UILabel()
    
        let pieChartView = UIView(frame: CGRectMake(0, 100, 380, 380))
        pieChartView.addSubview(pieChart)
        
        let globe = UIImageView(frame: CGRectMake(0, 0, 130, 130))
        globe.center = CGPointMake(pieChart.center.x, pieChart.center.y)
        globe.image = UIImage(named: "globe")
        
        
        
        
        self.view.addSubview(pieChartView)
        pieChart.addSubview(globe)
        
        goButton = UIButton(frame: CGRectMake(40, 500, 300, 40))
        goButton.backgroundColor = color
        goButton.setTitle("GO !", forState: .Normal)
        goButton.titleLabel?.font = UIFont(name: "Pirulen", size: 25)!
        view.addSubview(goButton)
        
        
        
        

        
        
        
        
    }

}