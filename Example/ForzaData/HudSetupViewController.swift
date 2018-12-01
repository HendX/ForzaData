//
//  HudSetupViewController.swift
//  ForzaData
//
//  Created by HendX on 11/29/2018.
//  Copyright (c) 2018 HendX. All rights reserved.
//

import UIKit
import ForzaData

class HudSetupViewController: UIViewController {

    static let hudPortKey = "hud_port"
    
    @IBOutlet var ipAddressLabel: UILabel!
    @IBOutlet var portTextField: UITextField!

    var port: UInt16 {
        return UInt16(UserDefaults.standard.string(forKey: HudSetupViewController.hudPortKey) ?? "") ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let addr = ForzaTools.getWiFiAddress() {
            self.ipAddressLabel.text = addr
        }
        else {
            self.ipAddressLabel.text = "(unknown)"
        }
        
        self.portTextField.text = String(self.port)
    }

    @IBAction func beginTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HudSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HudSegue" {
            if let navController = segue.destination as? UINavigationController, let vc = navController.viewControllers.first as? HudViewController {
                vc.port = self.port
            }
        }
    }
}

extension HudSetupViewController: UITextFieldDelegate {
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
        if textField == self.portTextField {
            UserDefaults.standard.set(textField.text, forKey: HudSetupViewController.hudPortKey)
        }
        
        UserDefaults.standard.synchronize()
    }
}
