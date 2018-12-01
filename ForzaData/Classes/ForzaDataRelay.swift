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

    private let receiver: ForzaDataReceiver
    private let sender: ForzaDataSender

    public weak var delegate: ForzaDataRelayProtocol?

    public init(receiver: ForzaDataReceiver, sender: ForzaDataSender) {
        self.receiver = receiver
        self.sender = sender
    }
    
    public func startRelay() throws {
        
        self.receiver.rawPacketHandler = { data in
            self.sender.send(data: data)
            self.delegate?.relayDidForwardPacket()
        }
        
        try self.receiver.startListening()
        self.sender.start()
    }
    
    public func stopRelay() throws {
        self.sender.stop()
        try self.receiver.stopListening()
    }
}
