//
//  ViewController.swift
//  simpleCalc
//
//  Created by Keran Zheng on 10/22/15.
//  Copyright © 2015 Lijuan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var calcLabel: UILabel!
    
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Action for clicking digit button
    @IBAction func clickBtnOne(sender: UIButton) {
        NSLog(sender.titleLabel!.text!)
        //self.textField.text = sender.titleLabel!.text!
        if self.calcLabel.text != nil {
            self.calcLabel.text = self.calcLabel.text! + sender.titleLabel!.text!
        }
        else {
            self.calcLabel.text = sender.titleLabel!.text!
        }
    }

    //Action for clicking space button
    @IBAction func clickBtnSpace(sender: UIButton) {
        if self.calcLabel.text != nil {
            self.calcLabel.text = self.calcLabel.text! + " "
        }
    }
    
    //Action for clicking operator button
    @IBAction func clickBtnOper(sender: UIButton) {
        if self.calcLabel.text != nil {
            self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text! + " "
            NSLog("output" + sender.titleLabel!.text!)
        }
    }
    
    //Action for clicking operator button
    @IBAction func clickBtnFact(sender: UIButton) {
        if self.calcLabel.text != nil {
            self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text!
            //Triger calculation
            let inputStr: [String] = getData(self.calcLabel.text!)
            let result = fact(inputStr)
            self.calcLabel.text = self.calcLabel.text! + " = \(result)"
        }
    }
    
    //Action for clicking equal button
    @IBAction func clickBtnEqual(sender: UIButton) {
        if self.calcLabel.text != nil {
            //self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text! + " "
            
            //Triger calculation
            let inputStr: [String] = getData(self.calcLabel.text!)
            let result = calc(inputStr)
            self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text! + " \(result)"
            
        }
    }
    
    //Action for clicking clear button
    @IBAction func clickBtnClear(sender: UIButton) {
        NSLog("Clear")
        self.calcLabel.text = nil
        self.errorMsg.text = nil
    }
    
    func getData(incoming:String) -> [String] {
        let arrData : [String]
        arrData = incoming.componentsSeparatedByString(" ")
        return arrData
    }
    
    func convertStrToDouble(inputStr:String) -> Double {
        return (inputStr as NSString).doubleValue
    }
    
    func calc(inputStr: [String]) -> Double {
        var result: Double = 0
        if inputStr.count >= 2 {
            switch inputStr[1] {
                case "+", "-", "*", "/", "%":
                    result = simpleCalc(inputStr)
                case "Avg", "Count":
                    result = multiOperCalc(inputStr)
                default:
                    self.errorMsg.text = "Invalid input!"
            }
        }
        return result
    }
    
    func simpleCalc(inputStr: [String]) -> Double {
        var result: Double = 0
        if inputStr.count != 3 {
            self.errorMsg.text = "Invalid input!"
        }
        else {
            let inputLeft: Double = convertStrToDouble(inputStr[0])
            let inputRight: Double = convertStrToDouble(inputStr[2])
            switch inputStr[1]{
                case "+":
                    result = inputLeft + inputRight
                case "-":
                    result = inputLeft - inputRight
                case "*":
                    result = inputLeft * inputRight
                case "/":
                    result = inputLeft / inputRight
                case "%":
                    result = inputLeft % inputRight
                default:
                    self.errorMsg.text = "Invalid input!"
            }
        }
        return result
    }
    
    func multiOperCalc(inputStr: [String]) -> Double {
        var result: Double = 0
        switch inputStr[1]{
            case "Avg":
                result = calcAvg(inputStr)
            case "Count":
                result = Double(calcCount(inputStr))
            default:
                self.errorMsg.text = "Invalid input!"
        }
        
        return result
    }
    
    func checkMultiOperCalcInput(inputStr: [String]) -> Bool {
        if inputStr.count < 4 {
            return true
        }
        for var i = 3; i < inputStr.count; i += 2 {
            if inputStr[i-2] != inputStr[i] {
                return false
            }
        }
        return true
    }
    
    func calcAvg(inputStr: [String]) -> Double {
        if checkMultiOperCalcInput(inputStr) {
            var sum : Double = 0
            var n = 0
            for var index = 0; index < inputStr.count; index += 2 {
                sum += convertStrToDouble(inputStr[index])
                n++
            }
            return sum/Double(n)
        }
        else {
            self.errorMsg.text = "Invalid input!"
            return 0.0
        }
    }
    
    func calcCount(inputStr: [String]) -> Int {
        if checkMultiOperCalcInput(inputStr) {
            var n = 0
            for var index = 0; index < inputStr.count; index += 2 {
                n++
            }
            return n
        }
        else {
            self.errorMsg.text = "Invalid input!"
            return 0
        }
    }
    
    func fact(inputStr: [String]) -> Int {
        if inputStr.count != 2 {
            self.errorMsg.text = "Invalid input!"
            return 0
        }
        
        var result = 1
        for var value = 1; value <= Int(convertStrToDouble(inputStr[0])); value++ {
            result *= value
        }
        
        return result
    }
}

