//
//  HudViewController.swift
//  ForzaData_Example
//
//  Created by Quentin Zervaas on 29/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ForzaData

class HudViewController: UIViewController {

    var port: UInt16!
    var receiver: ForzaDataReceiver!
    
    @IBOutlet var pausedLabel: UILabel!
    
    @IBOutlet var contentContainer: UIView!
    
    @IBOutlet var rpmLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var gearLabel: UILabel!
    
    @IBOutlet var miscLabel: UILabel!
    
    var lastReceived: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HUD"
        
        self.pausedLabel.text = "Waiting For Data"
        self.pausedLabel.isHidden = false
        
        self.contentContainer.isHidden = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(HudViewController.doneTapped(_:)))
        
        self.receiver = ForzaDataReceiver(port: self.port)
        self.receiver.sledPacketHandler = { [weak self] packet in
            self?.handle(packet: packet)
        }
        
        self.receiver.dashPacketHandler = { [weak self] packet in
            self?.handle(packet: packet)
        }
        
        do {
            try self.receiver.startListening()
        }
        catch {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        do {
            try self.receiver.stopListening()
        }
        catch {
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func handle(packet: ForzaPacket.ForzaSledPacket) {
        let misc1 = self.handle(packet: packet.v0)
        let misc2 = self.handle(packet: nil)

        let misc = misc1 + misc2
        
        let parts = misc.compactMap { String(format: "%@: %@", $0.label, $0.value)}
        
        self.miscLabel.text = parts.joined(separator: "\n")
    }
    
    func handle(packet: ForzaPacket.ForzaDashPacket) {
        let misc1 = self.handle(packet: packet.v0)
        let misc2 = self.handle(packet: packet.v1)
        
        let misc = misc1 + misc2
        
        let parts = misc.compactMap { String(format: "%@: %@", $0.label, $0.value)}
        
        self.miscLabel.text = parts.joined(separator: "\n")
    }
    
    func handle(packet: ForzaPacket.RawPacket.V0Packet) -> [MiscItem] {
        if packet.isRaceOn {
            self.pausedLabel.isHidden = true
            self.contentContainer.isHidden = false
        }
        else {
            self.pausedLabel.text = "Game Paused"
            self.pausedLabel.isHidden = false
            self.contentContainer.isHidden = true
        }

        self.rpmLabel.text = String(format: "%01.0f", packet.CurrentEngineRpm)
        
        let items: [MiscItem] = [
            MiscItem(label: "Yaw/Pitch/Roll", value: String(format: "(%01.2f, %01.2f, %01.2f)", packet.Yaw, packet.Pitch, packet.Roll)),
            MiscItem(label: "Acceleration", value: String(format: "(%01.2f, %01.2f, %01.2f)", packet.AccelerationX, packet.AccelerationY, packet.AccelerationY)),
            MiscItem(label: "Velocity", value: String(format: "(%01.2f, %01.2f, %01.2f)", packet.VelocityX, packet.VelocityY, packet.VelocityZ)),
            MiscItem(label: "Angular Velocity", value: String(format: "(%01.2f, %01.2f, %01.2f)", packet.AngularVelocityX, packet.AngularVelocityY, packet.AngularVelocityZ)),
        ]

        return items
    }
    
    struct MiscItem {
        let label: String
        let value: String
    }
    
    func handle(packet: ForzaPacket.RawPacket.V1Packet?) -> [MiscItem] {
        if let packet = packet {
            self.speedLabel.text = String(Int(packet.speedKmh))
            
            switch packet.currentGear {
            case .reverse:
                self.gearLabel.text = "R"
            case .forward(let gear):
                self.gearLabel.text = String(gear)
            }
            
            let items: [MiscItem] = [
                MiscItem(label: "Position", value: String(format: "(%01.2f, %01.2f, %01.2f)", packet.PositionX, packet.PositionY, packet.PositionZ)),
                MiscItem(label: "Tyres", value: String(format: "(%01.2f, %01.2f, %01.2f, %01.2f)", packet.TireTempFrontLeft, packet.TireTempFrontRight, packet.TireTempRearLeft, packet.TireTempRearRight)),
                MiscItem(label: "Power", value: String(format: "%01.0f", packet.Power)),
                MiscItem(label: "Torque", value: String(format: "%01.0f", packet.Torque)),
                MiscItem(label: "Boost", value: String(format: "%01.0f", packet.Boost)),
                MiscItem(label: "Fuel", value: String(format: "%01.0f%%", packet.Fuel * 100)),
                MiscItem(label: "Accelerator", value: String(packet.Accel)),
                MiscItem(label: "Brake", value: String(packet.Brake)),
                MiscItem(label: "Clutch", value: String(packet.Clutch)),
                MiscItem(label: "Handbrank", value: String(packet.HandBrake)),
                MiscItem(label: "Steer", value: String(packet.Steer)),
            ]
            
            return items
            
        }
        else {
            self.speedLabel.text = "-"
            self.gearLabel.text = "-"
            
            return []
        }
    }
}
