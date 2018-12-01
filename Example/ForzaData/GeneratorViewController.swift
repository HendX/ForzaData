//
//  GeneratorViewController.swift
//  ForzaData_Example
//
//  Created by Quentin Zervaas on 1/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ForzaData

class GeneratorViewController: UIViewController {

    var generatorIpAddress: String!
    var generatorPort: UInt16!
    
    private var generator: ForzaDataGenerator!
    private var sender: ForzaDataSender!
    
    var packetCount = 0
    
    @IBOutlet var packetCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Generator"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(GeneratorViewController.doneTapped(_:)))

        self.sender = ForzaDataSender(destinationIpAddress: self.generatorIpAddress, destinationPort: self.generatorPort)

        self.generator = ForzaDataGenerator(packetsPerSecond: 10)
        self.generator.packetGeneratedCallack = { packet in
            self.sender.send(packet: packet)
            DispatchQueue.main.async {
                self.packetCount += 1
                self.packetCountLabel.text = String(self.packetCount)
            }
        }
        
        self.sender.start()
        self.generator.startGeneratingDash(paused: false)
    }

    @objc func doneTapped(_ sender: UIBarButtonItem) {
        self.generator.stopGenerating()
        self.sender.stop()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        self.generator.pauseRace()
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        self.generator.resumeRace()
    }
}
