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
        
        socket.on("drawLineFrom", callback: {
            data,ack in
            let json = data.first as! NSDictionary
            self.delegate?.drawLineFrom(fromPoint: CGPoint(x: json["fX"] as! CGFloat, y: json["fY"] as! CGFloat), toPoint: CGPoint(x: json["tX"] as! CGFloat, y: json["tY"] as! CGFloat), with: UIColor.black.cgColor)
        })
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
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint, with color: CGColor)
    
}
