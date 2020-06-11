//
//  Global.swift
//  Beep WatchKit Extension
//
//  Created by Water Flower on 6/1/20.
//  Copyright © 2020 Water Flower. All rights reserved.
//

import Foundation

class Global {
    static var prompt_type: Int = 0  // 0: random, 1: fixed
    static var selected_frequency: Int = 0 // 0: low  1: medium, 2: high
    static var selected_beep: Int = 0 // 0: low  1: medium, 2: high
    static var fixed_time: Int = 10  //  slider time value
    static var selected_prompt_time: Int = 0  // 0: 4s, 1: 5s, 2: 6s
    static var selected_sound_level: Float = 10  // 0: min, 10: max
    static var selected_set_hour: Int = 0  // 0: min, 23: max
    static var selected_set_minute: Int = 0  // 0: min, 59: max
    static var selected_set_second: Int = 0  // 0: min, 59: max
    
    static var selected_audio_file: Int = 0  // 0: file surfix
}
