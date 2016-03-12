//
//  ViewController.swift
//  swift001
//
//  Created by lyle on 15/8/8.
//  Copyright (c) 2015年 lyleLH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 属性？？
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(labelNumber.text!)!.doubleValue
        }
        set {
            labelNumber.text = "\(newValue)"
            userIsInTheMiddleOfTypeingANumber = false
        }
    }
 
    
    @IBOutlet weak var labelNumber: UILabel!
    var userIsInTheMiddleOfTypeingANumber:Bool = false
  
    @IBAction func numberCliked(sender: UIButton) {
        
        let number = sender.currentTitle!
        if userIsInTheMiddleOfTypeingANumber {
            labelNumber.text = labelNumber.text! + number
        
            print("number = \(number)\n")
        } else {
            labelNumber.text = number
            userIsInTheMiddleOfTypeingANumber = true
 
        }
    }
    var operandStack = Array<Double>()
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypeingANumber = false
        
        operandStack.append(displayValue)
        
        println("operandStack = \(operandStack)")
    }


    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypeingANumber {
            enter()
        }
        

        switch operation {
            //  直接调用某个函数
            //        case "×" : preformOperation(multiply)
            //  闭包 写法1.1
            //        case "×" :preformOperation({ (op1:Double,op2:Double) -> Double in
            //            return op1 * op2
            //        })
//              闭包 写法1.2
                    case "×" :
                        preformOperation ( {(op1:Double,op2:Double) -> Double in return op1 * op2 })
            
            //  闭包 写法1.3  这种写法会报错
//        case "×" :
//            preformOperation {(op1 * op2 }
            
            
            case "÷" :preformOperation ( {(op1:Double,op2:Double) -> Double in return op1/op2 })
            
            case "+" :preformOperation ( {(op1:Double,op2:Double) -> Double in return op1 + op2 })
            
            case "−" :preformOperation ( {(op1:Double,op2:Double) -> Double in return op1 - op2 })
            
            default:break
        }
    }
    
    func preformOperation(operation:(Double,Double) -> Double) { //函数作为参数
    
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
        
    }

    
    
    /**
    乘法
 
    */
    func multiply (op1:Double,op2:Double) -> Double {
        
        return op1 * op2
    }
    /**
    *  除法。。。。。。
    */
    
    
    /**
    抽象重构
    *  函数作为参数传递
    */
    
    
}

