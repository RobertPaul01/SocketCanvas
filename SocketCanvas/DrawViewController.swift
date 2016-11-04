//
//  ViewController.swift
//  SocketCanvas
//
//  Created by Robert Paul on 10/12/16.
//  Copyright © 2016 Robert Paul. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, SocketManagerDelegate {
    
    // MARK: Color settings
    var brushColor: CGColor = UIColor.black.cgColor
    var brushWidth: CGFloat = 10.0
    var alpha: CGFloat = 1.0
    
    // MARK: Drawing vars
    var lastPoint = CGPoint.zero
    var swiped = false
    
    // MARK: Outlets
    @IBOutlet weak var tempImageView: UIImageView!
    
    // MARK: SocketManagerDelegate
    
    internal func touchesBegan(location: CGPoint) {
        print("TOUCH BEGAN: \(location)")
        swiped = false
        lastPoint = location
    }
    
    internal func touchesMoved(location: CGPoint) {
        print("TOUCH MOVED: \(location)")
        swiped = true
        drawLineFrom(fromPoint: lastPoint, toPoint: location, with: brushColor)
        lastPoint = location
    }
    
    internal func touchesEnded() {
        print("TOUCH ENDED: \(swiped)")
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint, with: brushColor)
        }
    }
    
    // MARK: Drawing functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
            //SocketManager.getInstance().touchesBegan(point: touch.location(in: self.view))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint, with: brushColor)
            lastPoint = currentPoint
            //SocketManager.getInstance().touchesMoved(point: touch.location(in: self.view))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //SocketManager.getInstance().touchesEnded()
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint, with: brushColor)
        }
    }

    
    internal func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, with color: CGColor) {
        
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

    // MARK: Boilerplate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketManager.getInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

