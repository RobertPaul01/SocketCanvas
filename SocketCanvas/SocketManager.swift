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
    
    private init() {
        socket = SocketIOClient(socketURL: NSURL(string:"http://127.0.0.1:3000")! as URL)
        socket.connect()
        print("DID CONNECT: \(socket.status.rawValue)")
        
        socket.on("touchesBegan", callback: {
            data,ack in
            let json = data.first as! NSDictionary
            self.delegate?.touchesBegan(location: CGPoint(x: json["x"] as! CGFloat, y: json["y"] as! CGFloat))
        })
    }
    
    func touchesBegan(point: CGPoint) {
        let json = ["x": point.x,
                    "y": point.y]
        socket.emit("touchesBegan", json)
    }
    
}

protocol SocketManagerDelegate: class {
    
    func touchesBegan(location: CGPoint)
    
}
