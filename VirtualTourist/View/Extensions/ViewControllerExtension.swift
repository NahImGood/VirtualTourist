//
//  ViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/14/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
