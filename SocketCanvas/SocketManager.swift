//
//  SocketManager.swift
//  SocketCanvas
//
//  Created by Robert Paul on 10/19/16.
//  Copyright © 2016 Robert Paul. All rights reserved.
//

import Foundation
import UIKit

class SocketManager {
    
    static var instance: SocketManager?
    var socket: SocketIOClient
    
    var delegate: SocketManagerDelegate?
    
    static func getInstance() -> SocketManager! {
        if instance == nil {
            instance = SocketManager()
        }
        return instance
    }
    
    // http://54.213.175.58:3000
    private init() {
        socket = SocketIOClient(socketURL: NSURL(string:"http://54.213.175.58:3000")! as URL)
        socket.connect()
        print("DID CONNECT: \(socket.status.rawValue)")
        
        socket.on("touchesBegan", callback: {
            data,ack in
            let json = data.first as! NSDictionary
            self.delegate?.touchesBegan(location: CGPoint(x: json["x"] as! CGFloat, y: json["y"] as! CGFloat))
        })
        
        socket.on("touchesMoved", callback: {
            data,ack in
            let json = data.first as! NSDictionary
            self.delegate?.touchesMoved(location: CGPoint(x: json["x"] as! CGFloat, y: json["y"] as! CGFloat))
        })
        
        socket.on("touchesEnded", callback: {
            data,ack in
            self.delegate?.touchesEnded()
        })
        
        socket.on("drawLineFrom", callback: {
            data,ack in
            let json = data.first as! NSDictionary
            self.delegate?.drawLineFrom(fromPoint: CGPoint(x: json["fX"] as! CGFloat, y: json["fY"] as! CGFloat), toPoint: CGPoint(x: json["tX"] as! CGFloat, y: json["tY"] as! CGFloat), with: UIColor.black.cgColor)
        })
    }
    
    func touchesBegan(point: CGPoint) {
        let json = ["x": point.x,
                    "y": point.y]
        socket.emit("touchesBegan", json)
    }
    
    func touchesMoved(point: CGPoint) {
        let json = ["x": point.x,
                    "y": point.y]
        socket.emit("touchesMoved", json)
    }
    
    func touchesEnded() {
        socket.emit("touchesEnded", "touchesEnded")
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, with color: CGColor) {
        let json = ["fX": fromPoint.x,
                    "fY": fromPoint.y,
                    "tX": toPoint.x,
                    "tY": toPoint.y,] as [String : Any]
        socket.emit("drawLineFrom", json)
    }
    
}

protocol SocketManagerDelegate: class {
    
    func touchesBegan(location: CGPoint)
    func touchesMoved(location: CGPoint)
    func touchesEnded()
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, with color: CGColor)
    
}
