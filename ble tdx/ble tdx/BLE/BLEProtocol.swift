
import UIKit
import CommonCrypto
import CryptoSwift

class BLEProtocol: NSObject {

	let HEADER : UInt8 = 0xCA

	let OPCODE_LOGON : UInt8 = 0x1
    let OPCODE_CMD1 : UInt8 = 0x2
    let OPCODE_CMD2 : UInt8 = 0x3
    let OPCODE_CMD3 : UInt8 = 0x4
    let OPCODE_CMD4 : UInt8 = 0x5
    let OPCODE_VERSION : UInt8 = 0x06
	let OPCODE_CHANGEPIN : UInt8 = 0x7
    let OPCODE_RENAME : UInt8 = 0x8
	let OPCODE_READSTATUS : UInt8 = 0x9
    let OPCODE_READSMK : UInt8 = 0xA
    let OPCODE_WRITESMK : UInt8 = 0xB
    
	let OPCODE_OFFSET : UInt8 = 0x01
    let LENGTH_OFFSET : UInt8 =  0x02
    let RESULT_OFFSET : UInt8 = 0x03
    let DATA_OFFSET : UInt8 = 0x07
    let LOGON_RESULT_OFFSET : UInt8 = 0x03
    
	let STATUS_CODE_SUCCESS : UInt8 = 0x0
	let STATUS_CODE_ERRORPIN : UInt8 = 0x55

	var pin : String = "8888"
    
    override init() {
        super.init()
        pin = "8888"

    }
    
    func logon() -> [UInt8]{
        return generatedCmd(OPCODE_LOGON, pin: pin, bytesData: [0x1])
    }
    
    func sendCMD1(value : UInt8) -> [UInt8]{
	    return generatedCmd(OPCODE_CMD1, pin: pin, bytesData: [value])
    }
    
    func sendCMD2(value : UInt8) -> [UInt8]{
        return generatedCmd(OPCODE_CMD2, pin: pin, bytesData: [value])
    }
    
    func sendCMD3(value : UInt8) -> [UInt8]{
        return generatedCmd(OPCODE_CMD3, pin: pin, bytesData: [value])
    }
    
    func sendCMD4(value : UInt8) -> [UInt8]{
        return generatedCmd(OPCODE_CMD4, pin: pin, bytesData: [value])
    }
    
    func version() -> [UInt8]{
	    return generatedCmd(OPCODE_VERSION, pin: pin, bytesData: [0x1])
    }
    
    func rename(_ newName : String) -> [UInt8]{
        return generatedCmd(OPCODE_RENAME, pin : pin, bytesData: [UInt8](newName.utf8))
    }
    
    func changepass(_ newPass: String, completion: @escaping ([UInt8]) -> Void) {
        self.encrypt(newPass) { bytes in
            completion(self.generatedCmd(self.OPCODE_CHANGEPIN, pin: self.pin, bytesData: bytes))
        }
    }
    
    func readStatus() -> [UInt8]{
        return generatedCmd(OPCODE_READSTATUS, pin: pin, bytesData: [0x1])
    }
    
    func readSMK() -> [UInt8]{
        return generatedCmd(OPCODE_READSMK, pin: pin, bytesData: [0x1])
    }
    
    func writeSMK(_ newSMK : String) -> [UInt8]{
        return generatedCmd(OPCODE_WRITESMK, pin : pin, bytesData: [UInt8](newSMK.utf8))
    }
    
    func encrypt(_ newPass: String, completion: @escaping ([UInt8]) -> Void) {
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

            try cypher.crypt(data: Data(bytes: UnsafePointer<UInt8>(bytesInput), count: 8), key: stringKey, completion: { cypherText in
                var array = [UInt8](repeating: 0, count: 8)
                // copy bytes into array
                (cypherText as NSData).getBytes(&array, length:8 * MemoryLayout<UInt8>.size)
                print(array)
                completion(array)
            })
        }
        catch {
            completion([0])
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
        
        return bytes.md5()
    
    }
    
    func MD5(_ string: String) -> String {

        return string.md5()
    }
    
    

	


}
