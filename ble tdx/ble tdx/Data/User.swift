//
//  User.swift
//  BIKE
//
//  Created by Ann on 3/18/16.
//  Copyright © 2016 Ann. All rights reserved.
//

import UIKit

class User: NSObject {
    var pin : String!
    var address: String!
    var uuid : String!
    var username: String!
    var namedevice: String!
    var modelBike: String!
    var numberBike: String!
    override init() {
    	let userDefaults = UserDefaults.standard
    	pin = userDefaults.string(forKey: "PIN") 
    	address = userDefaults.string(forKey: "ADDRESS") 
    	uuid = userDefaults.string(forKey: "UUID") 
    	username = userDefaults.string(forKey: "USERNAME")
    	namedevice = userDefaults.string(forKey: "NAMEDEVICE")
    	modelBike = userDefaults.string(forKey: "MODELBIKE") 
    	numberBike = userDefaults.string(forKey: "NUMBERBIKE")
        
        if(pin == nil){
            pin = "8888"
        }
        if(username == nil){
            username = "Nguyễn Văn A"
        }
        if namedevice == nil {
            namedevice = "IKY_PLUS"
        }
        if modelBike == nil {
            modelBike = "Honda Airblade 2016"
        }
        if numberBike == nil {
            numberBike = "53H - 89289"
        }
    }
    
    func clearDevice(){
        self.namedevice = nil
        self.uuid = nil
        saveValue()
    }
    
    func saveValue(){
    	let userDefaults = UserDefaults.standard
    	userDefaults.setValue(pin, forKey: "PIN" )
    	userDefaults.setValue(address, forKey: "ADDRESS" )
    	userDefaults.setValue(uuid, forKey: "UUID" )
    	userDefaults.setValue(username, forKey: "USERNAME" )
    	userDefaults.setValue(namedevice, forKey: "NAMEDEVICE" )
    	userDefaults.setValue(modelBike, forKey: "MODELBIKE" )
    	userDefaults.setValue(numberBike, forKey: "NUMBERBIKE" )
    	userDefaults.synchronize()
    }

    func hasDevice() -> Bool {

    	if (address != nil) {
    		return true
    	} else {
    		return false
    	}
        
    }



}
