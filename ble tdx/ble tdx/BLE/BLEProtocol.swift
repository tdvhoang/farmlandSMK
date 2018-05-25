//
//  Protocol.swift
//  BIKE
//
//  Created by Ann on 3/16/16.
//  Copyright © 2016 Ann. All rights reserved.
//

import UIKit
//import CryptoSwift

class BLEProtocol: NSObject {

	let HEADER : UInt8 = 0xCA
	
	let OPCODE_FINDBYTE : UInt8 = 0x7
	let OPCODE_SETLOCK : UInt8 = 0x2
	let OPCODE_SETVIBRATE : UInt8 = 0x3
	let OPCODE_READSTATUS : UInt8 = 0x4
	let OPCODE_LOGON : UInt8 = 0x1
	let OPCODE_RENAME : UInt8 = 0x6
	let OPCODE_CHANGEPIN : UInt8 = 0x5
	let OPCODE_OPENTRUNK : UInt8 = 0x9
	let OPCODE_CONFIGURE_RSSI : UInt8 = 0x0B
	let OPCODE_READ_RSSI : UInt8 = 0x0C
	let OPCODE_VERSION : UInt8 = 0x0F

	let APP_OPCODE_FINDBYTE : UInt8 = 0x87
	let APP_OPCODE_SETLOCK : UInt8 = 0x82
	let APP_OPCODE_SETVIBRATE : UInt8 = 0x83
	let APP_OPCODE_READSTATUS : UInt8 = 0x84
	let APP_OPCODE_LOGON : UInt8 = 0x81
	let APP_OPCODE_RENAME : UInt8 = 0x86
	let APP_OPCODE_CHANGEPIN : UInt8 = 0x85
	let APP_OPCODE_OPENTRUNK : UInt8 = 0x89
    let APP_OPCODE_CONFIGURE_RSSI : UInt8 =  0x8B
    let APP_OPCODE_READ_RSSI : UInt8 = 0x8C
    let APP_OPCODE_RSSI : UInt8 =  0x8D

	let APP_OPCODE_ALARM : UInt8 = 0x88

	let STATUS_CODE_SUCCESS : UInt8 = 0x0
	let STATUS_CODE_ERRORPIN : UInt8 = 0x55

	var pin : String = "8888"
    
    override init() {
        super.init()
        pin = "8888"

    }
    
    func readRSSI(value : UInt8) -> [UInt8]{
	    return generatedCmd(OPCODE_READ_RSSI, pin: pin, bytesData: [value])
    }
    
    func configureRSSI(valueTurnOn : UInt8, valueTurnOff : UInt8) -> [UInt8]{
	    return generatedCmd(OPCODE_CONFIGURE_RSSI, pin: pin, bytesData: [valueTurnOn, valueTurnOff])
    }
    
    func openTrunk() -> [UInt8]{
	    return generatedCmd(OPCODE_OPENTRUNK, pin: pin, bytesData: [0x1])
    }
    
    func version() -> [UInt8]{
	    return generatedCmd(OPCODE_VERSION, pin: pin, bytesData: [0x1])
    }
    func findbyte() -> [UInt8]{
	    return generatedCmd(OPCODE_FINDBYTE, pin: pin, bytesData: [0x1])
    }

    func setLockOn() -> [UInt8]{
        
	    return generatedCmd(OPCODE_SETLOCK, pin: pin, bytesData: [0x1])
    }
    
    func setLockOff() -> [UInt8]{
	    return generatedCmd(OPCODE_SETLOCK, pin: pin, bytesData: [0x0])
    }

    func setVibeOn() -> [UInt8]{
	    return generatedCmd(OPCODE_SETVIBRATE, pin: pin, bytesData: [0x1])
    }
    
    func setVibeOff() -> [UInt8]{
	    return generatedCmd(OPCODE_SETVIBRATE, pin: pin, bytesData: [0x0])
    }

    func readStatus() -> [UInt8]{
	    return generatedCmd(OPCODE_READSTATUS, pin: pin, bytesData: [0x1])
    }

    func logon() -> [UInt8]{
	    return generatedCmd(OPCODE_LOGON, pin: pin, bytesData: [0x1])
    }

    func rename(_ newName : String) -> [UInt8]{
        return generatedCmd(OPCODE_RENAME, pin : pin, bytesData: [UInt8](newName.utf8))
    }
    func changepass(_ newPass: String) -> [UInt8] {
        let bytes = encrypt(newPass)
        return generatedCmd(OPCODE_CHANGEPIN, pin : pin, bytesData: bytes)

    }
    
    func encrypt(_ newPass: String) -> [UInt8]{
        do{
            let selectedAlgorithm : SymmetricCryptorAlgorithm = .tripledes
            var options = 0
            options |= kCCOptionPKCS7Padding 
            options |= kCCOptionECBMode 
            let cypher = SymmetricCryptor(algorithm: selectedAlgorithm, options: options)

            var bytesInput = [UInt8]()
            let bytesPass = [UInt8](newPass.utf8)
            for byte in bytesPass{
                bytesInput.append(byte)
            }
            bytesInput.append(0)
            bytesInput.append(0)
            bytesInput.append(0)
            bytesInput.append(0)
            
            let stringKey = pin + pin + pin + pin + pin + pin

            let cypherText : Data = try cypher.crypt(data: Data(bytes: UnsafePointer<UInt8>(bytesInput), count: 8), key: stringKey)

            _ = cypherText.count / MemoryLayout<UInt8>.size
            // create array of appropriate length:
            var array = [UInt8](repeating: 0, count: 8)
            // copy bytes into array
            (cypherText as NSData).getBytes(&array, length:8 * MemoryLayout<UInt8>.size)
            print(array)
            return array
        }catch{
            return [0]
        }
        

    }




    
    func generatedCmd(_ opcode : UInt8, pin : String, bytesData : [UInt8]) -> [UInt8]{
	    var bytesPinData : [UInt8] = [UInt8]()
	    let bytesPin = [UInt8](pin.utf8)
	    for byte in bytesPin {
		    bytesPinData.append(byte)
	    }

	    for byte in bytesData {
		    bytesPinData.append(byte)
	    }
	    
	    let bytesEncrypted = encryptePin( bytesPinData )
	    // calculate crc
	    let crc = calcCrc( bytesEncrypted, bytesData: bytesData )

	    // add to result
	    var result : [UInt8] = [UInt8]()
	    result.append(HEADER)
	    result.append(opcode)
	    result.append((UInt8)(bytesEncrypted.count + bytesData.count))
	    result.append(bytesEncrypted[3])
	    result.append(bytesEncrypted[2])
	    result.append(bytesEncrypted[1])
	    result.append(bytesEncrypted[0])

	    for byte in bytesData {
		    result.append(byte)
	    }
	    result.append(crc)
        print(result)
	    return result
     }

     func calcCrc( _ bytesEnrypted : [UInt8], bytesData : [UInt8]) -> UInt8 {
	     var result = 0

	     for byte in bytesEnrypted {
		     result = result + (Int)(byte)
	     }

	     for byte in bytesData {
		     result = result +  (Int)(byte)
	     }
	     return (UInt8)(result & 0xFF)
     } 
    
    func encryptePin(_ bytes : [UInt8]) -> [UInt8]{
        var results : [UInt8] = [UInt8](repeating: 0, count: 4)
        var md5Generated = md5(bytes)
        results[0] = (md5Generated[0] ^ md5Generated[1] ^ md5Generated[2] ^ md5Generated[3])
        results[1] = (md5Generated[4] ^ md5Generated[5] ^ md5Generated[6] ^ md5Generated[7])
        results[2] = (md5Generated[8] ^ md5Generated[9] ^ md5Generated[10] ^ md5Generated[11])
        results[3] = (md5Generated[12] ^ md5Generated[13] ^ md5Generated[14] ^ md5Generated[15])
        return results
    }

    func md5( _ bytes : [UInt8] )  -> [UInt8]{
        
//        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))
//        let resultBytes = UnsafePointer<UInt8>(result!.bytes)
//        
//        CC_MD5(bytes, CC_LONG(bytes.count), resultBytes)
//        
//        let a = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: result!.length)
//        
//        var bytes : [UInt8] = []
//        let hash = NSMutableString()
//        for ii in 0..<a.count {
//            bytes.append(a[ii])
//        }
        
//        do {
//            bytes.md5()
//            var digest = MD5()
//            let partial1 : [UInt8] = try digest.update(withBytes: bytes)
//            //Test
//            for i in partial1 {
//                hash.appendFormat("%02x", i)
//            }
//            print(hash)
//        
//            return pa
//        } catch {
//            return -1
//            
//        }
        return bytes
        //return bytes.md5()
    
    }
    
    func MD5(_ string: String) -> String {
        
        return string//.md5()
        
//        let length = Int(CC_MD5_DIGEST_LENGTH)
//        var digest = [UInt8](repeating: 0, count: length)
//        if let d = string.data(using: String.Encoding.utf8) {
//            d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
//                CC_MD5(body, CC_LONG(d.count), &digest)
//            }
//        }
//        return (0..<length).reduce("") {
//            $0 + String(format: "%02x", digest[$1])
//        }
        
//        let data = (string as NSString).data(using: String.Encoding.utf8.rawValue)
//        
//        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))
//        let resultBytes = UnsafeMutablePointer<CUnsignedChar>(result!.bytes)
//        
//        CC_MD5(data!.bytes, CC_LONG(data!.length), resultBytes)
//        let a = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: result!.length)
//        let hash = NSMutableString()
//        
//        for i in a {
//            hash.appendFormat("%02x", i)
//        }
//        
//        return hash as String
    }
    
    

	


}
