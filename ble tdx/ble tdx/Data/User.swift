//
//  User.swift
//  BIKE
//
//  Created by Ann on 3/18/16.
//  Copyright © 2016 Ann. All rights reserved.
//

import UIKit

private let UsePassCodeKey = "UsePassCode"
private let PassCodeKey = "PassCode"
private let UseTouchIDKey = "UseTouchID"

class User {
    var pin : String!
    var address: String!
    var uuid : String!
    var username: String!
    var namedevice: String!
    var modelBike: String!
    var time: String!
    var pinSMK: String!
    var usePassCode: Bool = false
    var passCode: String!
    var useTouchID: Bool = false
    
    static let `shared` = User()
    
    private init() {
    	let userDefaults = UserDefaults.standard
    	pin = userDefaults.string(forKey: "PIN") 
    	address = userDefaults.string(forKey: "ADDRESS") 
    	uuid = userDefaults.string(forKey: "UUID") 
    	username = userDefaults.string(forKey: "USERNAME")
    	namedevice = userDefaults.string(forKey: "NAMEDEVICE")
    	modelBike = userDefaults.string(forKey: "MODELBIKE")
        pinSMK = userDefaults.string(forKey: "PINSMK")
        time = userDefaults.string(forKey: "TIME")
        self.usePassCode = userDefaults.bool(forKey: UsePassCodeKey)
        self.passCode = userDefaults.string(forKey: PassCodeKey) ?? ""
        self.useTouchID = userDefaults.bool(forKey: UseTouchIDKey)
        
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
        if time == nil {
            time = "10"
        }
        if pinSMK == nil {
            pinSMK = "123456789"
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
    	userDefaults.setValue(time, forKey: "TIME" )
        userDefaults.setValue(pinSMK, forKey: "PINSMK" )
        userDefaults.setValue(self.usePassCode, forKey: UsePassCodeKey)
        userDefaults.setValue(self.passCode, forKey: PassCodeKey)
        userDefaults.setValue(self.useTouchID, forKey: UseTouchIDKey)
    	userDefaults.synchronize()
    }

    func hasDevice() -> Bool {
        return self.address != nil
    }
}
