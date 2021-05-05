//
//  SettingsViewController.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    var coordinator: SettingsCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = AppColors.sharedInstance.accentBlue

    }
    
}
