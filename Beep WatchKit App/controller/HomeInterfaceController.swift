//
//  HomeInterfaceController.swift
//  Beep WatchKit Extension
//
//  Created by Water Flower on 5/30/20.
//  Copyright © 2020 Water Flower. All rights reserved.
//

import UIKit
import WatchKit

class HomeInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func homeButtonAction() {
        print("home button")
    }
    
    @IBAction func faqButtonAction() {
        print("faq button")
    }
    
}
