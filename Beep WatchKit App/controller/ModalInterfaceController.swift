//
//  ModalInterfaceController.swift
//  Beep WatchKit Extension
//
//  Created by Water Flower on 6/1/20.
//  Copyright © 2020 Water Flower. All rights reserved.
//

import UIKit
import WatchKit
import AVFoundation
import Foundation

class ModalInterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var pickerView: WKInterfacePicker!
    
    var frequency_picker_array = ["Low", "Medium", "High"]
    var beep_picker_array = ["Digital beep", "Electric beep", "Low high beep", "Phone beep", "Low Digital beep", "Bubbles", "Car beep", "Siren beep", "Quindar low", "Quindar high", "Fuzzy Beep", "Low Chrime", "Low Smooth", "Video game", "Vintage Chim"]
    var picker_type = ""
    var selected_frequency = 0
    var selected_beep = 0
    
    var audio_player: AVAudioPlayer!
    
    var hours_array: [Int] = []
    var minutes_array: [Int] = []
    var seconds_array: [Int] = []
    var selected_set_hour = 0
    var selected_set_minute = 0
    var selected_set_second = 0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let val: String = context as? String {
            var pickerItems: [WKPickerItem] = []
            if val == "frequency" {
                self.picker_type = "frequency"
                for i in 0 ..< self.frequency_picker_array.count {
                    let pickerItem = WKPickerItem()
                    pickerItem.title = self.frequency_picker_array[i]
                    pickerItem.caption = self.frequency_picker_array[i]
                    pickerItems.append(pickerItem)
                }
                self.pickerView.setItems(pickerItems)
                self.pickerView.setSelectedItemIndex(Global.selected_frequency)
            } else if val == "beep" {
                self.picker_type = "beep"
                for i in 0 ..< self.beep_picker_array.count {
                    let pickerItem = WKPickerItem()
                    pickerItem.title = self.beep_picker_array[i]
                    pickerItem.caption = self.beep_picker_array[i]
                    pickerItems.append(pickerItem)
                }
                self.pickerView.setItems(pickerItems)
                self.pickerView.setSelectedItemIndex(Global.selected_beep)
            } else if val == "sethour" {
                self.picker_type = "sethour"
                for i in 0 ..< 24 {
                    let pickerItem = WKPickerItem()
                    pickerItem.title = String(i)
                    pickerItem.caption = String(i)
                    pickerItems.append(pickerItem)
                }
                self.pickerView.setItems(pickerItems)
                
            } else if val == "setminute" {
                self.picker_type = "setminute"
                for i in 0 ..< 60 {
                    let pickerItem = WKPickerItem()
                    pickerItem.title = String(i)
                    pickerItem.caption = String(i)
                    pickerItems.append(pickerItem)
                }
                self.pickerView.setItems(pickerItems)
                
            } else if val == "setsecond" {
                self.picker_type = "setsecond"
                for i in 0 ..< 60 {
                    let pickerItem = WKPickerItem()
                    pickerItem.title = String(i)
                    pickerItem.caption = String(i)
                    pickerItems.append(pickerItem)
                }
                self.pickerView.setItems(pickerItems)
            }
            
        } else {
            
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func pickerChangedAction(_ value: Int) {
        if self.picker_type == "frequency" {
            self.selected_frequency = value
        } else if self.picker_type == "beep" {
            let audio_file = "beeper" + String(value + 1) + ".mp3"
            Global.selected_audio_file = value
            if let audio_path = Bundle.main.path(forResource: audio_file, ofType: nil) {
                try? self.audio_player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio_path))
                self.audio_player.volume = 0.1 * Float(Global.selected_sound_level)
                self.audio_player.play()
            } else {
                print("Unable to find sound file \(audio_file).mp3")
                
            }
            
            self.selected_beep = value
        } else if self.picker_type == "sethour" {
            self.selected_set_hour = value
        } else if self.picker_type == "setminute" {
            self.selected_set_minute = value
        } else if self.picker_type == "setsecond" {
            self.selected_set_second = value
        }
    }
    
    @IBAction func doneButtonAction() {
        if self.picker_type == "frequency" {
            Global.selected_frequency = self.selected_frequency
        } else if self.picker_type == "beep" {
            Global.selected_beep = self.selected_beep
        } else if self.picker_type == "sethour" {
            Global.selected_set_hour = self.selected_set_hour
        } else if self.picker_type == "setminute" {
            Global.selected_set_minute = self.selected_set_minute
        } else if self.picker_type == "setsecond" {
            Global.selected_set_second = self.selected_set_second
        }
        self.dismiss()
    }
}
