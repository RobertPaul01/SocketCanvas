//
//  SocketManager.swift
//  SocketCanvas
//
//  Created by Robert Paul on 10/19/16.
//  Copyright © 2016 Robert Paul. All rights reserved.
//

import Foundation

class SocketManager {
    
    static var instance: SocketManager?
    var socket: SocketIOClient?
    
    static func getInstance() -> SocketManager! {
        if instance == nil {
            instance = SocketManager()
        }
        return instance!
    }
    
    private init() {
        socket = SocketIOClient(socketURL: URL(string:"")! as URL)
        
        let json = ["x": 5,
                    "y": 10]
        
        socket?.emit("draw", json)
        
        socket?.on("draw", callback: {
            data,ack in
            
        })
    }
    
}
