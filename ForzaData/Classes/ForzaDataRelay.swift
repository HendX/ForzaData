//
//  ForzaDataRelay.swift
//  CocoaAsyncSocket
//
//  Created by Quentin Zervaas on 1/12/18.
//

import CocoaAsyncSocket

public protocol ForzaDataRelayProtocol: class {
    func relayDidForwardPacket()
}

public class ForzaDataRelay: NSObject {

    private var socket: GCDAsyncUdpSocket?

    private let receiver: ForzaDataReceiver

    public let destinationIpAddress: String
    public let destinationPort: UInt16
    
    public weak var delegate: ForzaDataRelayProtocol?

    public init(receiver: ForzaDataReceiver, destinationIpAddress: String, destinationPort: UInt16) {
        self.receiver = receiver
        
        // TODO: Represent this as sockaddr as this will slow things down
        self.destinationIpAddress = destinationIpAddress
        self.destinationPort = destinationPort
    }
    
    public func startRelay() throws {
        
        self.receiver.rawPacketHandler = { data in
            self.socket?.send(
                data,
                toHost: self.destinationIpAddress,
                port: self.destinationPort,
                withTimeout: -1,
                tag: 0
            )
            
            self.delegate?.relayDidForwardPacket()
        }
        
        self.socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: nil)

        try self.receiver.startListening()
    }
    
    public func stopRelay() throws {
        self.socket?.closeAfterSending()
        try self.receiver.stopListening()
    }
}

extension ForzaDataRelay: GCDAsyncUdpSocketDelegate {
    
}
