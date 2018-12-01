//
//  ForzaDataReceiver.swift
//  ForzaData
//
//  Created by Quentin Zervaas on 29/11/18.
//

import CocoaAsyncSocket

public class ForzaDataReceiver: NSObject {
    public let port: UInt16
    
    public var rawPacketHandler: ((Data) -> Void)?
    public var sledPacketHandler: ((ForzaPacket.ForzaSledPacket) -> Void)?
    public var dashPacketHandler: ((ForzaPacket.ForzaDashPacket) -> Void)?
    
    private var socket: GCDAsyncUdpSocket?
    
    public init(port: UInt16) {
        self.port = port
    }
    
    public func startListening() throws {
        self.socket?.close()
        
        
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        try socket.bind(toPort: self.port)
        try socket.beginReceiving()
        
        self.socket = socket
    }
    
    public func stopListening() throws {
        self.socket?.close()
        self.socket = nil
    }
}

extension ForzaDataReceiver: GCDAsyncUdpSocketDelegate {
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        
        if let handler = self.rawPacketHandler {
            handler(data)
        }
        
        guard self.dashPacketHandler != nil || self.sledPacketHandler != nil else {
            return
        }
        
        let v0Size = MemoryLayout<ForzaPacket.RawPacket.V0Packet>.size.self
        
        guard data.count >= v0Size else {
            return
        }
        
        let v0Data = data.subdata(in: 0 ..< v0Size)
        
        guard let v0Packet: ForzaPacket.RawPacket.V0Packet = v0Data.decode() else {
            return
        }
        
        let v1Size = MemoryLayout<ForzaPacket.RawPacket.V1Packet>.size.self
        
        if data.count >= v0Size + v1Size {
            let v1Data = data.subdata(in: v0Size ..< v0Size + v1Size)
            
            if let v1Packet: ForzaPacket.RawPacket.V1Packet = v1Data.decode() {
                
                let dashPacket = ForzaPacket.ForzaDashPacket(v0: v0Packet, v1: v1Packet)
                self.dashPacketHandler?(dashPacket)
                return
            }
        }
        
        
        self.sledPacketHandler?(ForzaPacket.ForzaSledPacket(v0: v0Packet))
    }
}
