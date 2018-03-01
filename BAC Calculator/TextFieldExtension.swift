//
//  TextFieldExtension.swift
//  BAC Calculator
//
//  Created by Jacob Sokora on 2/27/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func loadDropdown(data: [String], nextField: UITextField?) {
        self.inputView = CustomPickerView(pickerData: data, dropdownField: self, nextField: nextField)
    }
}
