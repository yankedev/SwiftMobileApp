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
        

        let title = UIImageView(frame: CGRectMake(40, 30, 300, 40))
        title.image = UIImage(named: "logo.png")
        view.addSubview(title)
        
        
        let devoxxTitle = UILabel(frame: CGRectMake(40, 75, 300, 40))
        devoxxTitle.textAlignment = .Center
        devoxxTitle.font = UIFont(name: "Pirulen", size: 25)
        devoxxTitle.textColor = color
        view.addSubview(devoxxTitle)
        
        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, 380, 380))
        pieChart.textLabel = devoxxTitle
    
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
        
        
        
        let number1 = UILabel(frame: CGRectMake(20, 580, 100, 40))
        //number1.backgroundColor = UIColor.redColor()
        number1.text = "102"
        number1.font = UIFont(name: "Pirulen", size: 30)!
        number1.textColor = UIColor.whiteColor()
        number1.textAlignment = .Center
        
        let number2 = UILabel(frame: CGRectMake(140, 580, 100, 40))
        //number2.backgroundColor = UIColor.blueColor()
        number2.text = "230"
        number2.font = UIFont(name: "Pirulen", size: 30)!
        number2.textColor = UIColor.whiteColor()
        number2.textAlignment = .Center
        
        let number3 = UILabel(frame: CGRectMake(260, 580, 100, 40))
        //number3.backgroundColor = UIColor.purpleColor()
        number3.text = "100"
        number3.font = UIFont(name: "Pirulen", size: 30)!
        number3.textColor = UIColor.whiteColor()
        number3.textAlignment = .Center
        
        pieChart.number1 = number1
        pieChart.number2 = number2
        pieChart.number3 = number3
        
        
        
        
        self.view.addSubview(number1)
        self.view.addSubview(number2)
        self.view.addSubview(number3)

        
        let label1 = UILabel(frame: CGRectMake(20, 620, 100, 20))
        //label1.backgroundColor = UIColor.redColor()
        label1.text = "DAYS LEFT"
        label1.font = UIFont(name: "Pirulen", size: 8)!
        label1.textColor = UIColor.whiteColor()
        label1.textAlignment = .Center
        let label2 = UILabel(frame: CGRectMake(140, 620, 100, 20))
        //label2.backgroundColor = UIColor.blueColor()
        label2.text = "PROPOSALS"
        label2.font = UIFont(name: "Pirulen", size: 8)!
        label2.textColor = UIColor.whiteColor()
        label2.textAlignment = .Center
        let label3 = UILabel(frame: CGRectMake(260, 620, 100, 20))
        //label3.backgroundColor = UIColor.purpleColor()
        label3.text = "% REGISTRATION"
        label3.font = UIFont(name: "Pirulen", size: 8)!
        label3.textColor = UIColor.whiteColor()
        label3.textAlignment = .Center
        
        
        self.view.addSubview(label1)
        self.view.addSubview(label2)
        self.view.addSubview(label3)

        
        
        
        
    }

}