//
//  ResultInterfaceController.swift
//  Beep WatchKit Extension
//
//  Created by Water Flower on 6/2/20.
//  Copyright © 2020 Water Flower. All rights reserved.
//

import UIKit
import WatchKit
import AVFoundation

class ResultInterfaceController: WKInterfaceController {

    @IBOutlet weak var resultTableView: WKInterfaceTable!
    @IBOutlet weak var percentageLabel: WKInterfaceLabel!
    @IBOutlet weak var messageLabel: WKInterfaceLabel!
    
    @IBOutlet weak var resultpercentageGroup: WKInterfaceGroup!
    @IBOutlet weak var resultmessageGroup: WKInterfaceGroup!
    
    var audio_player: AVAudioPlayer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let result: String = context as? String {
            if result == "working_result" {
                self.resultpercentageGroup.setHidden(false)
                self.resultmessageGroup.setHidden(false)
            } else {
                self.resultpercentageGroup.setHidden(true)
                self.resultmessageGroup.setHidden(true)
            }
        } else {
            self.resultpercentageGroup.setHidden(true)
            self.resultmessageGroup.setHidden(true)
        }
           
        if let audio_path = Bundle.main.path(forResource: "end_audio.mp3", ofType: nil) {
            try? self.audio_player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio_path))
            self.audio_player.volume = 0.1 * Float(Global.selected_sound_level)
            self.audio_player.play()
        }
        
        var date_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "date") != nil) {
            date_array = UserDefaults.standard.stringArray(forKey: "date")!
        }
        
        var duration_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "duration") != nil) {
            duration_array = UserDefaults.standard.stringArray(forKey: "duration")!
        }
        
        var total_prompt_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "total_prompt") != nil) {
            total_prompt_array = UserDefaults.standard.stringArray(forKey: "total_prompt")!
        }
        
        var clicked_prompt_array: [String] = []
        if (UserDefaults.standard.stringArray(forKey: "clicked_prompt") != nil) {
            clicked_prompt_array = UserDefaults.standard.stringArray(forKey: "clicked_prompt")!
        }
        
        var tabledata_array: [[String]] = []
        for i in 0 ..< date_array.count {
            tabledata_array.append([date_array[i], duration_array[i], total_prompt_array[i], clicked_prompt_array[i]])
        }
        
        let latest_total_prompt = Float(total_prompt_array[0])!
        let latest_clicked_prompt = Float(clicked_prompt_array[0])!
        let latest_duration = Int(duration_array[0])!
        let latest_duration_str = self.convertSecodsToformattedTime(seconds: latest_duration)
        if latest_total_prompt == 0 {
            self.percentageLabel.setText("0%")
        } else {
            self.percentageLabel.setText(String(Int(latest_clicked_prompt / latest_total_prompt * 100)) + "%")
        }
        self.messageLabel.setText("for my " + latest_duration_str + " session on " + date_array[0])
        
        self.resultTableView.setNumberOfRows(tabledata_array.count, withRowType: "ResultTableCell")
        for (index, row) in tabledata_array.enumerated() {
            print(row)
            if let rowController = self.resultTableView.rowController(at: index) as? ResultTableCell {
                
                rowController.dateLabel.setText(row[0])
                rowController.durationLabel.setText(self.convertSecodsToformattedTime(seconds: Int(row[1])!))
                rowController.totalpromptLabel.setText(row[2])
                rowController.clickedLabel.setText(row[3])
            }
        }
 
    }
    
    @IBAction func homeButtonAction() {
        self.audio_player.stop()
        self.pushController(withName: "HomeInterfaceController", context: nil)
    }
    
    @IBAction func beginButtonAction() {
        self.audio_player.stop()
//        Global.prompt_type = 0  // 0: random, 1: fixed
//        Global.selected_frequency = 0 // 0: low  1: medium, 2: high
//        Global.selected_beep = 0 // 0: low  1: medium, 2: high
//        Global.fixed_time = 10  //  slider time value
//        Global.selected_prompt_time = 0  // 0: 4s, 1: 5s, 2: 6s
//        Global.selected_sound_level = 10  // 0: min, 10: max
//        Global.selected_set_hour = 0  // 0: min, 23: max
//        Global.selected_set_minute = 0  // 0: min, 59: max
//        Global.selected_set_second = 0  // 0: min, 59: max
//        Global.selected_audio_file = 0  // 0: file surfix
        
        self.pushController(withName: "HomeInterfaceController", context: nil)
    }
    
    
    func convertSecodsToformattedTime(seconds: Int) -> String {
        var seconds_str = ""
        let second_hour = seconds / 3600
        let second_min = (seconds % 3600) / 60
        let second_sec = (seconds % 3600) % 60
        if second_hour > 0 {
            seconds_str = String(second_hour) + "hr "
        }
        if second_min > 0 {
            seconds_str = seconds_str + String(second_min) + "min "
        }
        if second_sec > 0 {
            seconds_str = seconds_str + String(second_sec) + "sec"
        }
        return seconds_str
    }
    
}
