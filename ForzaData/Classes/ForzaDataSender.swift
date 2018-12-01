//
//  ForzaDataSender.swift
//  ForzaData
//
//  Created by Quentin Zervaas on 1/12/18.
//

import CocoaAsyncSocket

public class ForzaDataSender: NSObject {
    public let destinationIpAddress: String
    public let destinationPort: UInt16
    
    private var socket: GCDAsyncUdpSocket?

    public init(destinationIpAddress: String, destinationPort: UInt16) {
        // TODO: Represent this as sockaddr as this will slow things down
        self.destinationIpAddress = destinationIpAddress
        self.destinationPort = destinationPort

    }
    
    public func start() {
        self.socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: nil)
    }
    
    public func stop() {
        self.socket?.close()
    }

    public func send(data: Data) {
        self.socket?.send(
            data,
            toHost: self.destinationIpAddress,
            port: self.destinationPort,
            withTimeout: -1,
            tag: 0
        )

    }
    
    public func send(packet: ForzaPacket.ForzaSledPacket) {
        self.send(data: packet.toData)
    }
    
    public func send(packet: ForzaPacket.ForzaDashPacket) {
        self.send(data: packet.toData)
    }
}

extension ForzaDataSender: GCDAsyncUdpSocketDelegate {
    public func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        
    }
}
