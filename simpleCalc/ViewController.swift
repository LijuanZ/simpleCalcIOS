//
//  ViewController.swift
//  simpleCalc
//
//  Created by Lijuan Zhang on 10/22/15.
//  Copyright © 2015 Lijuan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var calcLabel: UILabel!
    
    @IBOutlet weak var errorMsg: UILabel!
    
    @IBOutlet weak var rpnSwitch: UISwitch!
    
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
            if self.rpnSwitch.on {
                self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text!
                //rpn Calc
                let inputStr: [String] = getData(self.calcLabel.text!)
                let result = rpnCalc(inputStr)
                self.calcLabel.text = self.calcLabel.text! + " = \(result)"
            }
            else {
                self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text! + " "
            }
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
            //Triger calculation
            let inputStr: [String] = getData(self.calcLabel.text!)
            let result = calc(inputStr)
            self.calcLabel.text = self.calcLabel.text! + " " + sender.titleLabel!.text! + " \(result)"
            
        }
    }
    
    //Action for clicking clear button
    @IBAction func clickBtnClear(sender: UIButton) {
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
                case "+":
                    result = calcTraditional(inputStr, oper: calcAdd)
                case "-":
                    result = calcTraditional(inputStr, oper: calcSubtract)
                case "*":
                    result = calcTraditional(inputStr, oper: calcMultiply)
                case "/":
                    result = calcTraditional(inputStr, oper: calcDivide)
                case "%":
                    result = calcTraditional(inputStr, oper: calcMode)
                case "Avg":
                    result = calcTraditional(inputStr, oper: calcAvg)
                case "Count":
                    result = calcTraditional(inputStr, oper: calcCount)
                default:
                    self.errorMsg.text = "Invalid input!"
            }
        }
        else {
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
    
    func calcTraditional(inputStr: [String], oper: [String] -> Double) -> Double {
        if checkMultiOperCalcInput(inputStr) {
            return oper(inputStr)
        }
        else {
            self.errorMsg.text = "Invalid input!"
            return 0.0
        }
    }
    
    func calcAdd(inputStr: [String]) -> Double {
            var sum : Double = 0
            for var index = 0; index < inputStr.count; index += 2 {
                sum += convertStrToDouble(inputStr[index])
            }
            return sum
    }
    
    func calcSubtract(inputStr: [String]) -> Double {
        var result : Double = convertStrToDouble(inputStr[0])
        for var index = 2; index < inputStr.count; index += 2 {
            result -= convertStrToDouble(inputStr[index])
        }
        return result
    }
    
    func calcMultiply(inputStr: [String]) -> Double {
        var result : Double = 1.0
        for var index = 0; index < inputStr.count; index += 2 {
            result *= convertStrToDouble(inputStr[index])
        }
        return result
    }
    
    func calcDivide(inputStr: [String]) -> Double {
        var result : Double = convertStrToDouble(inputStr[0])
        for var index = 2; index < inputStr.count; index += 2 {
            result /= convertStrToDouble(inputStr[index])
        }
        return result
    }
    
    func calcMode(inputStr: [String]) -> Double {
        var result : Double = convertStrToDouble(inputStr[0])
        for var index = 2; index < inputStr.count; index += 2 {
            result %= convertStrToDouble(inputStr[index])
        }
        return result
    }
    
    func calcAvg(inputStr: [String]) -> Double {
            var sum : Double = 0
            var n = 0
            for var index = 0; index < inputStr.count; index += 2 {
                sum += convertStrToDouble(inputStr[index])
                n++
            }
            return sum/Double(n)
    }
    
    func calcCount(inputStr: [String]) -> Double {
            var n = 0
            for var index = 0; index < inputStr.count; index += 2 {
                n++
            }
            return Double(n)
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
    
    func rpnCalc(inputData: [String]) -> Double {
        var result: Double = 0.0
        let length = inputData.count
        
        //Get operation
        let oper = inputData.last!
        
        //Get data
        let dataStrArr = Array(inputData[0..<length - 1])
        let dataDoubleArr = convertStrArrToDouble(dataStrArr)
        
        
        switch oper {
        case "Count":
            result = Double(dataDoubleArr.count)
        case "Avg":
            result = rpnCalcAvg(dataDoubleArr)
        case "Fact":
            if dataDoubleArr.count > 1 {
                self.errorMsg.text = "Invalid input! Fact operation can only take one number"
            }
            else {
                result = Double(fact(inputData))
            }
        case "+":
            result = rpnAdd(dataDoubleArr)
        case "-":
            result = rpnSubtract(dataDoubleArr)
        case "*":
            result = rpnMultiply(dataDoubleArr)
        case "/":
            result = rpnDivide(dataDoubleArr)
        case "%":
            result = rpnMode(dataDoubleArr)
        default:
            self.errorMsg.text = "Invalid input"
        }
        
        return result

    }
    
    func convertStrArrToDouble(inputArr:[String]) -> [Double] {
        let doubleArr = inputArr.map {
            ($0 as NSString).doubleValue
        }
        return doubleArr
    }
    
    func rpnCalcAvg(dataArr:[Double]) -> Double {
        var sum : Double = 0
        for var index = 0; index < dataArr.count; index++ {
            sum += dataArr[index]
        }
        return sum / Double(dataArr.count)
    }
    
    func rpnAdd(dataArr:[Double]) -> Double {
        var sum : Double = 0
        for var index = 0; index < dataArr.count; index++ {
            sum += dataArr[index]
        }
        
        return sum
    }
    
    func rpnSubtract(dataArr:[Double]) -> Double {
        var result: Double = dataArr[0]
        for var index = 1; index < dataArr.count; index++ {
            result -= dataArr[index]
        }
        return result
    }
    
    func rpnMultiply(dataArr:[Double]) -> Double {
        var result : Double = 1
        for number in dataArr {
            result *= number
        }
        return result
    }
    
    func rpnDivide(dataArr:[Double]) -> Double {
        var result: Double = dataArr[0]
        for var index = 1; index < dataArr.count; index++ {
            result /= dataArr[index]
        }
        return result
    }
    
    func rpnMode(dataArr:[Double]) -> Double {
        var result: Double = dataArr[0]
        for var index = 1; index < dataArr.count; index++ {
            result %= dataArr[index]
        }
        return result
    }
}

