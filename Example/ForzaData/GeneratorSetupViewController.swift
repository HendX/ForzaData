//
//  GeneratorSetupViewController.swift
//  ForzaData_Example
//
//  Created by Quentin Zervaas on 1/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class GeneratorSetupViewController: UIViewController {

    static let generatorDestinationIpAddressKey = "generator_destination_ip"
    static let generatorDestinationPortKey = "generator_destination_port"
    
    @IBOutlet var generatorIpAddressTextField: UITextField!
    @IBOutlet var generatorPortTextField: UITextField!
    
    var generatorIpAddress: String {
        return UserDefaults.standard.string(forKey: GeneratorSetupViewController.generatorDestinationIpAddressKey) ?? ""
    }
    
    var generatorPort: UInt16 {
        return UInt16(UserDefaults.standard.string(forKey: GeneratorSetupViewController.generatorDestinationPortKey) ?? "") ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Generator"

        self.generatorIpAddressTextField.text = self.generatorIpAddress
        self.generatorPortTextField.text = String(self.generatorPort)
    }

    @IBAction func beginTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GeneratorSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GeneratorSegue" {
            if let navController = segue.destination as? UINavigationController, let vc = navController.viewControllers.first as? GeneratorViewController {
                
                vc.generatorIpAddress = self.generatorIpAddress
                vc.generatorPort = self.generatorPort
            }
        }
    }
}
