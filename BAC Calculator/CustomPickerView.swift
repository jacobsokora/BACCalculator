//
//  CustomPickerView.swift
//  BAC Calculator
//
//  Created by Jacob Sokora on 2/27/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//
import Foundation
import UIKit

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerData: [String]!
    var pickerTextField: UITextField!
    var nextField: UITextField?
    
    init(pickerData: [String], dropdownField: UITextField, nextField: UITextField?) {
        super.init(frame: CGRect.zero)
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        self.nextField = nextField
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.main.async {
            if pickerData.count > 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
        backgroundColor = .white
        
        let nextBar = UIToolbar()
        nextBar.barStyle = .default
        nextBar.isTranslucent = true
        nextBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        nextBar.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEdit))
        let spaceBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goToNext))
        nextBar.setItems([cancelButton, spaceBar, nextButton], animated: false)
        nextBar.isUserInteractionEnabled = true
        pickerTextField.inputAccessoryView = nextBar
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
    
    @objc func goToNext() {
        if let next = nextField {
            next.becomeFirstResponder()
        } else {
            pickerTextField.resignFirstResponder()
        }
    }
    
    @objc func cancelEdit() {
        pickerTextField.resignFirstResponder()
    }
}
