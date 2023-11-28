//
//  SettingViewController.swift
//  profileUI
//
//  Created by Phincon on 31/10/23.
//

import UIKit
import StepSlider

class SettingViewController: UIViewController {
    
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var stepSliderLabel: UILabel!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var timePickerLabel: UILabel!
    @IBOutlet weak var isPowerSwitch: UISwitch!
    @IBOutlet weak var isPowerLabel: UILabel!
    // initial for stepslider
    let pulsaOptions = ["10K", "25K", "50K", "100K", "200K"]
    
    // initial for UIPicker
    let hours = Array(1...12)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    let amPm = ["AM", "PM"]
    
    var selectedHour = 1
    var selectedMinute = 0
    var selectedSecond = 0
    var selectedAmPm = "AM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        // Configure the StepSlider
        stepSlider.trackHeight = 4.0
        stepSlider.trackCircleRadius = 8.0
        stepSlider.sliderCircleRadius = 12.0
        stepSlider.labels = pulsaOptions
        stepSlider.labelColor = UIColor.black
        stepSlider.index = 2 // Set the initial index
        stepSlider.sliderCircleColor = UIColor.black
        // Set the initial label
        updateSelectionLabel()
        
        // Add a target to track value changes
        stepSlider.addTarget(self, action: #selector(stepSliderValueChanged), for: .valueChanged)
        
        // Set the data source and delegate for the UIPickerView
        timePickerView.dataSource = self
        timePickerView.delegate = self
        
        
        // Set the initial selected row for each component
        timePickerView.selectRow(0, inComponent: 0, animated: false)
        timePickerView.selectRow(0, inComponent: 1, animated: false)
        timePickerView.selectRow(0, inComponent: 2, animated: false)
        timePickerView.selectRow(0, inComponent: 3, animated: false)
        
        // UISwitch
        updateLabel()
        
        // Add a target to the UISwitch to detect state changes
        isPowerSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)


    }
    
    @objc func stepSliderValueChanged() {
        updateSelectionLabel()
        changeSliderCircleColor()
    }
    
    func updateSelectionLabel() {
        let selectedValue = stepSlider.index
        stepSliderLabel.text = "Pulsa: " + pulsaOptions[Int(selectedValue)]
        

    }
    func changeSliderCircleColor() {
        let selectedValue = stepSlider.index
        if selectedValue % 2 == 0{
            stepSlider.sliderCircleColor = UIColor.systemBlue
        } else {
            stepSlider.sliderCircleColor = UIColor.systemRed
        }
    }
    
    @objc func switchValueChanged() {
        updateLabel()
    }

    func updateLabel() {
        if isPowerSwitch.isOn {
            isPowerLabel.text = "Power is ON"
            self.view.backgroundColor = UIColor.black
        } else {
            isPowerLabel.text = "Power is OFF"
            self.view.backgroundColor = UIColor.systemBackground
        }
    }
}

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UIPickerView Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        case 3:
            return amPm.count
        default:
            return 0
        }
    }

    // MARK: - UIPickerView Delegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hours[row])"
        case 1:
            return String(format: "%02d", minutes[row])
        case 2:
            return String(format: "%02d", seconds[row])
        case 3:
            return amPm[row]
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTimeLabel()
    }

    func updateTimeLabel() {
        let selectedHour = hours[timePickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[timePickerView.selectedRow(inComponent: 1)]
        let selectedSecond = seconds[timePickerView.selectedRow(inComponent: 2)]
        let selectedAmPm = amPm[timePickerView.selectedRow(inComponent: 3)]

        let formattedTime = String(format: "%02d:%02d:%02d %@", selectedHour, selectedMinute, selectedSecond, selectedAmPm)
        timePickerLabel.text = "Time: " + formattedTime
    }
}
