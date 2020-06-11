//
//  SettingInterfaceController.swift
//  Beep WatchKit Extension
//
//  Created by Water Flower on 5/30/20.
//  Copyright © 2020 Water Flower. All rights reserved.
//

import UIKit
import WatchKit

class SettingInterfaceController: WKInterfaceController {

    @IBOutlet weak var randomRadioImageView: WKInterfaceImage!
    @IBOutlet weak var fixedRadioImageView: WKInterfaceImage!
    
    @IBOutlet weak var frequencyGroup: WKInterfaceGroup!
    @IBOutlet weak var frequencyButton: WKInterfaceButton!
    
    @IBOutlet weak var fixedTimeSliderGroup: WKInterfaceGroup!
    @IBOutlet weak var fixedTimeSlider: WKInterfaceSlider!
    @IBOutlet weak var fixedTimeLabel: WKInterfaceLabel!
    
    @IBOutlet weak var promptTime4sImageView: WKInterfaceImage!
    @IBOutlet weak var promptTime5sImageView: WKInterfaceImage!
    @IBOutlet weak var promptTime6sImageView: WKInterfaceImage!
    
    @IBOutlet weak var beeperButton: WKInterfaceButton!
    
    @IBOutlet weak var soundLevelSlider: WKInterfaceSlider!
    
    @IBOutlet weak var sethourLabel: WKInterfaceLabel!
    @IBOutlet weak var setminuteLabel: WKInterfaceLabel!
    @IBOutlet weak var setsecondLabel: WKInterfaceLabel!
    
    var prompt_type = 0  //// 0: random, 1: fixed

    var frequency_picker_array = ["Low", "Medium", "High"]
    var beep_picker_array = ["Digital beep", "Electric beep", "Low high beep", "Phone beep", "Low Digital beep", "Bubbles", "Car beep", "Siren beep", "Quindar low", "Quindar high", "Fuzzy Beep", "Low Chrime", "Low Smooth", "Video game", "Vintage Chim"]
    
    var selected_prompt_time = 0  // 0: 4s, 1: 5s, 2: 6s
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if self.selected_prompt_time == 0 {
            self.promptTime4sImageView.setImageNamed("color_circle_button")
            self.promptTime5sImageView.setImageNamed("empty_circle_button")
            self.promptTime6sImageView.setImageNamed("empty_circle_button")
        } else if self.selected_prompt_time == 0 {
            self.promptTime4sImageView.setImageNamed("empty_circle_button")
            self.promptTime5sImageView.setImageNamed("color_circle_button")
            self.promptTime6sImageView.setImageNamed("empty_circle_button")
        } else if self.selected_prompt_time == 0 {
            self.promptTime4sImageView.setImageNamed("empty_circle_button")
            self.promptTime5sImageView.setImageNamed("empty_circle_button")
            self.promptTime6sImageView.setImageNamed("color_circle_button")
        }
        
        self.fixedTimeSlider.setValue(Float(Global.fixed_time))
        self.fixedTimeLabel.setText(String(Global.fixed_time) + "s")
        self.soundLevelSlider.setValue(Float(Global.selected_sound_level))
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.frequencyButton.setTitle(self.frequency_picker_array[Global.selected_frequency])
        self.beeperButton.setTitle(self.beep_picker_array[Global.selected_beep])
        
        self.sethourLabel.setText(String(Global.selected_set_hour))
        self.setminuteLabel.setText(String(Global.selected_set_minute))
        self.setsecondLabel.setText(String(Global.selected_set_second))
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func randomButtonAction() {
        
        if self.prompt_type == 1 {
            self.prompt_type = 0
            Global.prompt_type = 0
            self.randomRadioImageView.setImageNamed("color_circle_button")
            self.fixedRadioImageView.setImageNamed("empty_circle_button")
            self.frequencyGroup.setHidden(false)
            self.fixedTimeSliderGroup.setHidden(true)
        }
    }
    
    @IBAction func fixedButtonAction() {
        if self.prompt_type == 0 {
            self.prompt_type = 1
            Global.prompt_type = 1
            self.randomRadioImageView.setImageNamed("empty_circle_button")
            self.fixedRadioImageView.setImageNamed("color_circle_button")
            self.frequencyGroup.setHidden(true)
            self.fixedTimeSliderGroup.setHidden(false)
        }
        
    }
    
    @IBAction func frequencyButtonAction() {
        
        self.presentController(withName: "ModalInterfaceController", context: "frequency")

    }
    
    @IBAction func fixedTimeSliderAction(_ value: Float) {
        Global.fixed_time = Int(value)
        self.fixedTimeLabel.setText(String(Int(value)) + "s")
    }
    
    @IBAction func PromptTime4sButtonAction() {
        Global.selected_prompt_time = 0
        self.promptTime4sImageView.setImageNamed("color_circle_button")
        self.promptTime5sImageView.setImageNamed("empty_circle_button")
        self.promptTime6sImageView.setImageNamed("empty_circle_button")
    }
    
    @IBAction func PromptTime5sButtonAction() {
        Global.selected_prompt_time = 1
        self.promptTime4sImageView.setImageNamed("empty_circle_button")
        self.promptTime5sImageView.setImageNamed("color_circle_button")
        self.promptTime6sImageView.setImageNamed("empty_circle_button")
    }
    
    @IBAction func PromptTime6sButtonAction() {
        Global.selected_prompt_time = 2
        self.promptTime4sImageView.setImageNamed("empty_circle_button")
        self.promptTime5sImageView.setImageNamed("empty_circle_button")
        self.promptTime6sImageView.setImageNamed("color_circle_button")
    }
    
    @IBAction func beeperButtonAction() {
        self.presentController(withName: "ModalInterfaceController", context: "beep")
    }
    
    @IBAction func soundlevelSliderAction(_ value: Float) {
        Global.selected_sound_level = value
    }
    
    @IBAction func beephourButtonAction() {
        self.presentController(withName: "ModalInterfaceController", context: "sethour")
    }
    
    @IBAction func beepminutesButtonAction() {
        self.presentController(withName: "ModalInterfaceController", context: "setminute")
    }
    
    @IBAction func beepsecondButtonAction() {
        self.presentController(withName: "ModalInterfaceController", context: "setsecond")
    }
    
    @IBAction func startButtonAction() {
        if Global.selected_set_hour == 0 && Global.selected_set_minute == 0 && Global.selected_set_second == 0 {
            let action = WKAlertAction(title: "OK", style: WKAlertActionStyle.default) {
                print("Ok")
            }
            presentAlert(withTitle: "Beeper App", message: "Please select time to work", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
        } else {
            self.pushController(withName: "WorkingInterfaceController", context: nil)
        }
    }
    
}
