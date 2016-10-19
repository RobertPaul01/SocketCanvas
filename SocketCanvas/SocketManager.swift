//
//  SocketManager.swift
//  SocketCanvas
//
//  Created by Robert Paul on 10/19/16.
//  Copyright © 2016 Robert Paul. All rights reserved.
//

import Foundation

class SocketManager {
    
    var socket: SocketIOClient?
    
    init() {
        socket = SocketIOClient(socketURL: NSURL(string:"http://54.218.125.161:3000")! as URL)
        
        socket?.on("touchBegan", callback: {
            data,ack in

        })
    }
    
}
