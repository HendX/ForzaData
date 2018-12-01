//
//  RelayViewController.swift
//  ForzaData_Example
//
//  Created by Quentin Zervaas on 1/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ForzaData

class RelayViewController: UIViewController {

    var relayPort: UInt16!
    var destinationIpAddress: String!
    var destinationPort: UInt16!

    var relay: ForzaDataRelay!
    
    var packetCount = 0
    
    @IBOutlet var packetCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Relay"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(RelayViewController.doneTapped(_:)))
        
        let receiver = ForzaDataReceiver(port: self.relayPort)
        self.relay = ForzaDataRelay(receiver: receiver, destinationIpAddress: self.destinationIpAddress, destinationPort: self.destinationPort)
        self.relay.delegate = self
        
        do {
            try self.relay.startRelay()
        }
        catch {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        do {
            try self.relay.stopRelay()
        }
        catch {
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension RelayViewController: ForzaDataRelayProtocol {
    func relayDidForwardPacket() {
        DispatchQueue.main.async {
            self.packetCount += 1
            
            self.packetCountLabel.text = String(self.packetCount)
        }
    }
}
