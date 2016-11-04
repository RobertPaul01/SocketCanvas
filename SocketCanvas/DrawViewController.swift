//
//  ViewController.swift
//  SocketCanvas
//
//  Created by Robert Paul on 10/12/16.
//  Copyright © 2016 Robert Paul. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, SocketManagerDelegate {
    
    
    @IBOutlet var colorPicker: UIButton!
    // MARK: Color settings
    var brushColor: CIColor = CIColor.magenta()
    var brushWidth: CGFloat = 10.0
    var alpha: CGFloat = 1.0
    
    // MARK: Drawing vars
    var lastPoint = CGPoint.zero
    var swiped = false
    
    // MARK: Outlets
    @IBOutlet weak var tempImageView: UIImageView!
    
    // MARK: SocketManagerDelegate
    
    internal func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, with color: CGColor) {
        print("Draw from: \(fromPoint), toPoint: \(toPoint), with color: \(color)")
        
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(brushWidth)
            
            context.setStrokeColor(color)
            context.setBlendMode(CGBlendMode.colorBurn)
            
            context.strokePath()
            
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImageView.alpha = alpha
        } else {
            print("Error: Drawing context not found!!!")
        }
        UIGraphicsEndImageContext()
        
    }
    
    // MARK: Drawing functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            SocketManager.getInstance().drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint, with: brushColor)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            SocketManager.getInstance().drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint, with: brushColor)
        }
    }

    // MARK: Boilerplate
    
    @IBAction func colorPickerPressed(_ sender: Any) {
        //cyan, green, blue, red, orange, purple, brown, yellow, magenta
        
        
        if(colorPicker.backgroundColor == UIColor(ciColor: CIColor.cyan()))
        {
            colorPicker.backgroundColor = UIColor(ciColor: CIColor.green())
        }
        else if(colorPicker.backgroundColor == UIColor(ciColor: CIColor.green()))
        {
            colorPicker.backgroundColor = UIColor(ciColor: CIColor.blue())
        }
        else if(colorPicker.backgroundColor == UIColor(ciColor: CIColor.blue()))
        {
            colorPicker.backgroundColor = UIColor(ciColor: CIColor.red())
        }
        else if(colorPicker.backgroundColor == UIColor(ciColor: CIColor.red()))
        {
            colorPicker.backgroundColor = UIColor(ciColor: CIColor.yellow())
        }
        else if(colorPicker.backgroundColor == UIColor(ciColor: CIColor.yellow()))
        {
            colorPicker.backgroundColor = UIColor(ciColor: CIColor.magenta())
        }
        else if(colorPicker.backgroundColor == UIColor(ciColor: CIColor.magenta()))
        {
            colorPicker.backgroundColor = UIColor(ciColor: CIColor.cyan())
        }
        
        
    }
    
    
    // MARK: Boilerplate

    override func viewDidLoad() {
        super.viewDidLoad()
        SocketManager.getInstance().delegate = self
        colorPicker.backgroundColor = UIColor(ciColor: CIColor.cyan())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

