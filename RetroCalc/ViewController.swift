//
//  ViewController.swift
//  RetroCalc
//
//  Created by J. M. Lowe on 2/17/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//


import UIKit
import AVFoundation


//struct Stack<Element> {
//    var items = [Element]()
//}

struct Stack {
    var stackItems = [String]()
    mutating func push(_ item: String) {
        stackItems.append(item)
    }
    mutating func pop() -> String {
        return stackItems.removeLast()
    }
    func stackItemCount() -> Int {
        return stackItems.count
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
//    var myStack = Stack.self
//    myStack.push("test")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "button6", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
        
    }
    
//    func pushToStack(_ item: Element) {
//        items.append(item)
//    }
//    func popFromStack() -> Element {
//        return items.removeLast()
//    }
//    func countStack() -> Int {
//        return items.count
//    }
    // All the number buttons are assigned to the @IBAction below
    // Every time user presses a number, this action is triggered
    // The click sound plays, then the "runningNumber" is updated to append the new number that was pressed, and the outputLbl is updated with the new complete number
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    // Operator buttons only work if there is at least one entry in the stack AND there is a runningNumber (these operators all require two operands
    // So...first thing to do is make sure that there are in fact two operands
    @IBAction func onDividePressed(sender: AnyObject) {
        
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    // If the Enter button is pressed, add runningNumber to the stack - but leave runningNumber alone
    @IBAction func onEnterPressed(sender: AnyObject) {
//        pushToStack(runningNumber)
        processOperation(operation: currentOperation)
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            //A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    

    
}

