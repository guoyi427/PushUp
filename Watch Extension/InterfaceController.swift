//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by kokozu on 2017/6/15.
//  Copyright © 2017年 guoyi. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var rollLabel: WKInterfaceLabel!
    
    @IBOutlet var pitchLabel: WKInterfaceLabel!
    
    @IBOutlet var yawLabel: WKInterfaceLabel!
    
    @IBOutlet var pushUpCountLabel: WKInterfaceLabel!
    
    fileprivate let _motionManager = CMMotionManager()
    fileprivate let _device = WKInterfaceDevice.current()

    fileprivate var _isUp = false
    fileprivate var _isDown = false
    fileprivate var _pushUpCount:Int = 0
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        _motionManager.deviceMotionUpdateInterval = 0.1
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

    }

    deinit {
        _motionManager.stopDeviceMotionUpdates()
    }
    
    @IBAction func startButtonAction() {
        _motionManager.stopDeviceMotionUpdates()
        _pushUpCount = 0
        _motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [unowned self] (deviceMotion, error) in
            if error != nil {
                self._motionManager.stopDeviceMotionUpdates()
            }
            self.rollLabel.setText("\((deviceMotion?.attitude.roll)! * 100.0)")
            self.pitchLabel.setText("\((deviceMotion?.attitude.pitch)! * 100.0)")
            self.yawLabel.setText("\((deviceMotion?.attitude.yaw)! * 100.0)")
            
            let pitchValue = (deviceMotion?.attitude.pitch)! * 100
            if pitchValue < -50 {
                self._isDown = true
                self._isUp = false
            }
            
            if pitchValue > -20 {
                self._isUp = true
            }
            
            if self._isDown && self._isUp {
                self._pushUpCount += 1
                self._isUp = false
                self._isDown = false
                self.pushUpCountLabel.setText("\(self._pushUpCount)")
                self._device.play(.success)
            }
        }
    }
}
