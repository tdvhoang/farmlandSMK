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

	init(peripheral : CBPeripheral, rssi: Int, isConnected: Bool) {
		self.peripheral = peripheral
		self.rssi = rssi
		self.isConnected = isConnected
	}

	func name() -> String {
		if(peripheral!.name == nil){
			return "No name"
		}else{
			return peripheral!.name!
		}
	}
    func uuid() -> String {
        return peripheral.identifier.uuidString
    }

    

}
