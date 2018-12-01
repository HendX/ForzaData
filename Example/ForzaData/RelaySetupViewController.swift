//
//  RelaySetupViewController.swift
//  ForzaData_Example
//
//  Created by Quentin Zervaas on 1/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ForzaData

class RelaySetupViewController: UIViewController {
    
    static let relayLocalPortKey = "relay_local_port"
    static let relayDestinationIpAddressKey = "relay_destination_ip"
    static let relayDestinationPortKey = "relay_destination_port"

    @IBOutlet var relayIpAddressLabel: UILabel!
    @IBOutlet var relayPortTextField: UITextField!
    
    @IBOutlet var destinationIpAddressTextField: UITextField!
    @IBOutlet var destinationPortTextField: UITextField!
    
    var relayPort: UInt16 {
        return UInt16(UserDefaults.standard.string(forKey: RelaySetupViewController.relayLocalPortKey) ?? "") ?? 0
    }

    var destinationIpAddress: String {
        return UserDefaults.standard.string(forKey: RelaySetupViewController.relayDestinationIpAddressKey) ?? ""
    }

    var destinationPort: UInt16 {
        return UInt16(UserDefaults.standard.string(forKey: RelaySetupViewController.relayDestinationPortKey) ?? "") ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let addr = ForzaTools.getWiFiAddress() {
            self.relayIpAddressLabel.text = addr
        }
        else {
            self.relayIpAddressLabel.text = "(unknown)"
        }
        
        self.relayPortTextField.text = String(self.relayPort)
        self.destinationIpAddressTextField.text = self.destinationIpAddress
        self.destinationPortTextField.text = String(self.destinationPort)
    }
    
    @IBAction func beginTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RelaySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RelaySegue" {
            if let navController = segue.destination as? UINavigationController, let vc = navController.viewControllers.first as? RelayViewController {
                
                vc.relayPort = self.relayPort
                vc.destinationIpAddress = self.destinationIpAddress
                vc.destinationPort = self.destinationPort
            }
        }
    }
}

extension RelaySetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            self.save(textField: textField, text: updatedText)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.save(textField: textField, text: textField.text)
    }
    
    func save(textField: UITextField, text: String?) {
        if textField == self.relayPortTextField {
            UserDefaults.standard.set(textField.text, forKey: RelaySetupViewController.relayLocalPortKey)
        }
        else if textField == self.destinationIpAddressTextField {
            UserDefaults.standard.set(textField.text, forKey: RelaySetupViewController.relayDestinationIpAddressKey)
        }
        if textField == self.destinationPortTextField {
            UserDefaults.standard.set(textField.text, forKey: RelaySetupViewController.relayDestinationPortKey)
        }
        
        UserDefaults.standard.synchronize()
    }
}
