//
//  ScannedPeripheral.swift
//  BIKE
//
//  Created by Ann on 3/19/16.
//  Copyright © 2016 Ann. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScannedPeripheral: NSObject {

	var peripheral : CBPeripheral!
	var rssi : Int = 0
	var isConnected : Bool = false
    var date: Date

	init(peripheral : CBPeripheral, rssi: Int, isConnected: Bool) {
		self.peripheral = peripheral
		self.rssi = rssi
		self.isConnected = isConnected
        self.date = Date()
	}

	func name() -> String {
        if let name = peripheral?.name {
            return name
        }
        return "No name"
	}
    
    func uuid() -> String {
        return peripheral.identifier.uuidString
    }

    func updateData(_ peripheral: CBPeripheral, rssi: NSNumber?) {
        self.peripheral = peripheral
        self.date = Date()
        if let rssi = rssi {
            self.rssi = rssi.intValue
        }
    }
}

extension Array where Element: ScannedPeripheral {
    func getAlivePeripherals() -> [ScannedPeripheral] {
        return self.filter({ Date().timeIntervalSince($0.date) < 10 })
    }
}
