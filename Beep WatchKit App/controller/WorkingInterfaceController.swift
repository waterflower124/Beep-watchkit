//
//  WorkingInterfaceController.swift
//  Beep WatchKit Extension
//
//  Created by Water Flower on 6/1/20.
//  Copyright © 2020 Water Flower. All rights reserved.
//

import UIKit
import WatchKit
import AVFoundation
import UserNotifications

class WorkingInterfaceController: WKInterfaceController, AVAudioPlayerDelegate {

    @IBOutlet weak var sethourLabel: WKInterfaceLabel!
    @IBOutlet weak var setminuteLabel: WKInterfaceLabel!
    @IBOutlet weak var setsecondLabel: WKInterfaceLabel!
    
    @IBOutlet weak var frequncyGroup: WKInterfaceGroup!
    @IBOutlet weak var fixedGroup: WKInterfaceGroup!
    
    @IBOutlet weak var frequencyButton: WKInterfaceButton!
    
    @IBOutlet weak var fixedTimeLabel: WKInterfaceLabel!
    @IBOutlet weak var fixedTimeSlider: WKInterfaceSlider!
    
    @IBOutlet weak var goingImageView: WKInterfaceImage!
    @IBOutlet weak var goingLabel: WKInterfaceLabel!
    @IBOutlet weak var goingButton: WKInterfaceButton!
    
    @IBOutlet weak var animateGroup: WKInterfaceGroup!
    
//    @IBOutlet var interfaceTimerCountDown: WKInterfaceTimer!
    
    var timer = Timer()
    var total_time_duration = 0
    var global_total_time_duration = 0
    var beep_time_interval = 0
    var beep_start_time = 0
    var beep_timer = Timer()
    var beep_period = 0
    
    var total_beep_count = 0
    var react_beep_count = 0
    
    var sethour = 0
    var setminute = 0
    var setsecond = 0
    
    var frequency_picker_array = ["Low", "Medium", "High"]
    
    var audio_player: AVAudioPlayer!
   
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        print("awake function... ... ...")
        
        Global.deactivate_time = 0
        
        self.sethourLabel.setText(String(Global.selected_set_hour))
        self.setminuteLabel.setText(String(Global.selected_set_minute))
        self.setsecondLabel.setText(String(Global.selected_set_second))
        
        if Global.prompt_type == 0 {
            self.frequncyGroup.setHidden(false)
            self.fixedGroup.setHidden(true)
        } else {
            self.frequncyGroup.setHidden(true)
            self.fixedGroup.setHidden(false)
        }
        
        if Global.selected_prompt_time == 0 {
            self.beep_period = 4
        } else if Global.selected_prompt_time == 1 {
            self.beep_period = 5
        } else if Global.selected_prompt_time == 2 {
            self.beep_period = 6
        }
        
        if Global.prompt_type == 0 {
            if Global.selected_frequency == 0 {
                self.beep_time_interval = self.calc_duration(duration: 90, start: 0)
            } else if Global.selected_frequency == 1 {
                self.beep_time_interval = self.calc_duration(duration: 60, start: 0)
            } else if Global.selected_frequency == 2 {
                self.beep_time_interval = self.calc_duration(duration: 30, start: 0)
            }
        } else {
            self.beep_time_interval = Global.fixed_time
        }
        
        self.total_time_duration = Global.selected_set_hour * 3600 + Global.selected_set_minute * 60 + Global.selected_set_second
        self.global_total_time_duration = self.total_time_duration
        
        self.beep_start_time = self.total_time_duration - self.beep_time_interval
        
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//
//            self.timer_function()
//
//        })
        
        self.fixedTimeLabel.setText(String(Global.fixed_time) + "s")
        self.fixedTimeSlider.setValue(Float(Global.fixed_time))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: Notification.Name(rawValue: "UIApplicationDidEnterBackgroundNotification"), object: nil)
        
        self.frequencyButton.setTitle(self.frequency_picker_array[Global.selected_frequency])
        
        let activate_time = Int(Date().timeIntervalSince1970)
        if(Global.deactivate_time != 0) {
            self.total_time_duration -= activate_time - Global.deactivate_time
            if Global.prompt_type == 0 {
                self.beep_start_time = self.total_time_duration - self.calc_duration(duration: self.beep_time_interval, start: 0)
            } else {
                let deactivation_duration = activate_time - Global.deactivate_time
                self.beep_start_time = self.total_time_duration - deactivation_duration % self.beep_time_interval
            }
        }
        
        let hour = Int(self.total_time_duration / 3600)
        let minute = Int((self.total_time_duration - hour * 3600) / 60)
        let second = Int(self.total_time_duration - hour * 3600 - minute * 60)
        self.sethourLabel.setText(String(hour))
        self.setminuteLabel.setText(String(minute))
        self.setsecondLabel.setText(String(second))
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            self.timer_function()
            
        })
        
       print("activate function")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        Global.deactivate_time = Int(Date().timeIntervalSince1970)
        
        self.timer.invalidate()
        self.beep_timer.invalidate()
        self.animateGroup.setWidth(100)
        self.animateGroup.setHeight(100)
        WKInterfaceDevice.current().play(.failure)
                
//        self.audio_player.stop()
        self.goingImageView.setImageNamed("going_circle.png")
        self.goingLabel.setText("Keep going!")
        self.goingLabel.setTextColor(UIColor(red: 36.0 / 255, green: 91.0 / 255, blue: 138.0 / 255, alpha: 1))
        self.goingButton.setHidden(true)
        WKInterfaceDevice.current().play(.failure)
        
    }
    
    override func willDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        print("Device is locked")
        self.displayLocalNotification()
    }
    
    func timer_function() {
        self.total_time_duration -= 1
        let hour = Int(self.total_time_duration / 3600)
        let minute = Int((self.total_time_duration - hour * 3600) / 60)
        let second = Int(self.total_time_duration - hour * 3600 - minute * 60)
        self.sethourLabel.setText(String(hour))
        self.setminuteLabel.setText(String(minute))
        self.setsecondLabel.setText(String(second))

        if self.beep_start_time == self.total_time_duration {
            if Global.prompt_type == 0 {
                if Global.selected_frequency == 0 {
                    self.beep_time_interval = self.calc_duration(duration: 90, start: 90 - (self.global_total_time_duration - self.total_time_duration) % 90)
                } else if Global.selected_frequency == 1 {
                    self.beep_time_interval = self.calc_duration(duration: 60, start: 60 - (self.global_total_time_duration - self.total_time_duration) % 60)
                } else if Global.selected_frequency == 2 {
                    self.beep_time_interval = self.calc_duration(duration: 30, start: 30 - (self.global_total_time_duration - self.total_time_duration) % 30)
                }
            } else {
                self.beep_time_interval = Global.fixed_time
            }
            
            self.beep_start_time = self.beep_start_time - self.beep_time_interval
            self.total_beep_count += 1
            if self.audio_player == nil || !self.audio_player.isPlaying {
                let audio_file = "beeper" + String(Global.selected_audio_file + 1) + ".mp3"
                if let audio_path = Bundle.main.path(forResource: audio_file, ofType: nil) {
                    try? self.audio_player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio_path))
                    self.audio_player.numberOfLoops = self.beep_period - 1
                    self.audio_player.volume = 0.1 * Float(Global.selected_sound_level)
                    self.audio_player.play()
                    self.audio_player.delegate = self
                                           
                    self.goingImageView.setImageNamed("color_circle_view.png")
                    self.goingLabel.setText("I am still on task!")
                    self.goingLabel.setTextColor(UIColor.white)
                    self.goingButton.setHidden(false)
                    WKInterfaceDevice.current().play(.success)
                    
//                        self.animationCircle()
                    self.beep_timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { _ in
                        self.animationCircle()
                    })
                    
                } else {
                    print("Unable to find sound file \(audio_file).mp3")
                }
            }
        }
        
        if self.total_time_duration == 0 {
            self.beep_timer.invalidate()
            self.animateGroup.setWidth(100)
            self.animateGroup.setHeight(100)
            WKInterfaceDevice.current().play(.failure)
            
            self.timer.invalidate()
            
            self.audio_player.stop()
            self.record_result()
            self.pushController(withName: "ResultInterfaceController", context: "working_result")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        self.beep_timer.invalidate()
        self.animateGroup.setWidth(100)
        self.animateGroup.setHeight(100)
        WKInterfaceDevice.current().play(.failure)
                
        print("playing is done")
        self.audio_player.stop()
        self.goingImageView.setImageNamed("going_circle.png")
        self.goingLabel.setText("Keep going!")
        self.goingLabel.setTextColor(UIColor(red: 36.0 / 255, green: 91.0 / 255, blue: 138.0 / 255, alpha: 1))
        self.goingButton.setHidden(true)
        
    }
    
    func animationCircle() {
        self.animate(withDuration: 0.2, animations: {
            self.animateGroup.setWidth(90)
            self.animateGroup.setHeight(90)
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animate(withDuration: 0.2, animations: {
                self.animateGroup.setWidth(100)
                self.animateGroup.setHeight(100)
                
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.animate(withDuration: 0.2, animations: {
                self.animateGroup.setWidth(90)
                self.animateGroup.setHeight(90)
                
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animate(withDuration: 0.2, animations: {
                self.animateGroup.setWidth(100)
                self.animateGroup.setHeight(100)
                
            })
        }
            
        
    }
    
    func stringUUID() -> String {
         let uuid = UUID()
         let str: String = uuid.uuidString
         return str
    }
    
    func displayLocalNotification() {
        print("-------------------")
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Beeper App"
        content.body = "Are you still working!"
        content.sound = UNNotificationSound.default
        // Time
        var trigger: UNTimeIntervalNotificationTrigger?
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Actions
        let snoozeAction = UNNotificationAction(identifier: "Track", title: "Track", options: .foreground)

        let category = UNNotificationCategory(identifier: "UYLReminderCategory", actions: [snoozeAction], intentIdentifiers: [] as? [String] ?? [String](), options: .customDismissAction)
        let categories = Set<AnyHashable>([category])

        center.setNotificationCategories(categories as? Set<UNNotificationCategory> ?? Set<UNNotificationCategory>())

        content.categoryIdentifier = "UYLReminderCategory"

        let identifier: String = stringUUID()

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: {(_ error: Error?) -> Void in
            if error != nil {
                print("Something went wrong: \(String(describing: error))")
            } else {
                print("notification success")
            }
        })
    }
    
    func calc_duration(duration: Int, start: Int) -> Int {
        var period = 0
        period = Int.random(in: start + 5..<start + duration - 5)
        return period
    }
    
    @IBAction func frequencyButtonAction() {
        self.presentController(withName: "ModalInterfaceController", context: "frequency")
    }
    
    @IBAction func fixedTimeSliderAction(_ value: Float) {
        Global.fixed_time = Int(value)
        self.beep_time_interval = Int(value)
        self.fixedTimeLabel.setText(String(Int(value)) + "s")
    }
    
    @IBAction func goingButtonAction() {
        
        self.beep_timer.invalidate()
        self.animateGroup.setWidth(100)
        self.animateGroup.setHeight(100)
        WKInterfaceDevice.current().play(.failure)
                
        self.audio_player.stop()
        self.goingImageView.setImageNamed("going_circle.png")
        self.goingLabel.setText("Keep going!")
        self.goingLabel.setTextColor(UIColor(red: 36.0 / 255, green: 91.0 / 255, blue: 138.0 / 255, alpha: 1))
        self.goingButton.setHidden(true)
        WKInterfaceDevice.current().play(.failure)
        self.react_beep_count += 1
        
    }
    
    @IBAction func doneButtonAction() {
        
        
        self.timer.invalidate()
        
        if self.audio_player != nil {
            self.audio_player.stop()
        }
        self.record_result()
        self.pushController(withName: "ResultInterfaceController", context: "working_result")
        
        
    }
    
    @IBAction func homeButtonAction() {
        
        self.displayLocalNotification()
        
        self.beep_timer.invalidate()
        self.animateGroup.setWidth(100)
        self.animateGroup.setHeight(100)
        WKInterfaceDevice.current().play(.failure)

        self.timer.invalidate()

        if self.audio_player != nil {
            self.audio_player.stop()
        }
        self.pushController(withName: "HomeInterfaceController", context: nil)
    }
    
    @IBAction func resultButtonAction() {
        self.beep_timer.invalidate()
        self.animateGroup.setWidth(100)
        self.animateGroup.setHeight(100)
        WKInterfaceDevice.current().play(.failure)
                
        self.timer.invalidate()
        
        if self.audio_player != nil {
            self.audio_player.stop()
        }
        self.pushController(withName: "ResultInterfaceController", context: nil)
    }
    
    func record_result() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        var date_array: [String] = []
        
        if (UserDefaults.standard.stringArray(forKey: "date") != nil) {
            date_array = UserDefaults.standard.stringArray(forKey: "date")!
            date_array.insert(dateString, at: 0)
        } else {
            date_array = [dateString]
        }
        var date_array_temp: [String] = []
        if date_array.count > 5 {
            for i in 0 ..< 5 {
                date_array_temp.append(date_array[i])
            }
        } else {
            date_array_temp = date_array
        }
        UserDefaults.standard.set(date_array_temp, forKey: "date")
        
        let duration = Global.selected_set_hour * 3600 + Global.selected_set_minute * 60 + Global.selected_set_second - self.total_time_duration
        
        var duration_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "duration") != nil) {
            duration_array = UserDefaults.standard.stringArray(forKey: "duration")!
            duration_array.insert(String(duration), at: 0)
        } else {
            duration_array = [String(duration)]
        }
        var duration_array_temp: [String] = []
        if duration_array.count > 5 {
            for i in 0 ..< 5 {
                duration_array_temp.append(duration_array[i])
            }
        } else {
            duration_array_temp = duration_array
        }
        UserDefaults.standard.set(duration_array_temp, forKey: "duration")
        
        var total_prompt_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "total_prompt") != nil) {
            total_prompt_array = UserDefaults.standard.stringArray(forKey: "total_prompt")!
            total_prompt_array.insert(String(self.total_beep_count), at: 0)
        } else {
            total_prompt_array = [String(self.total_beep_count)]
        }
        var total_prompt_array_temp: [String] = []
        if total_prompt_array.count > 5 {
            for i in 0 ..< 5 {
                total_prompt_array_temp.append(total_prompt_array[i])
            }
        } else {
            total_prompt_array_temp = total_prompt_array
        }
        UserDefaults.standard.set(total_prompt_array_temp, forKey: "total_prompt")
        
        var clicked_prompt_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "clicked_prompt") != nil) {
            clicked_prompt_array = UserDefaults.standard.stringArray(forKey: "clicked_prompt")!
            clicked_prompt_array.insert(String(self.react_beep_count), at: 0)
        } else {
            clicked_prompt_array = [String(self.react_beep_count)]
        }
        var clicked_prompt_array_temp: [String] = []
        if clicked_prompt_array.count > 5 {
            for i in 0 ..< 5 {
                clicked_prompt_array_temp.append(clicked_prompt_array[i])
            }
        } else {
            clicked_prompt_array_temp = clicked_prompt_array
        }
        UserDefaults.standard.set(clicked_prompt_array_temp, forKey: "clicked_prompt")
    }
}
