//
//  PTTManager.swift
//  SocketTest
//
//  Created by 陳遵丞 on 2018/5/11.
//  Copyright © 2018年 陳遵丞. All rights reserved.
//

import Foundation
import Socket

enum PTTError: Error {
    case notConnect
    case notEncoding
    case notLogin
}

class PTTManager: NSObject {
    
    var socket: Socket?
    let accout = "MUNUZEL"
    let pwd = "qwe123"
    var readData = NSMutableData(capacity: 1024 * 10)
    
    override init() {
        
        do {
            socket = try Socket.create()
            
        } catch {
            
            print(error)
            
        }
        
    }
    
    func connectPtt(successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
        var shouldKeepRunning = true
        //連線成功
        do {
            
            try socket?.connect(to: "ptt.cc", port: 23)
            
        } catch {
            
            failureHandler(PTTError.notConnect)
        }
        
        
        
        
            let connected = self.socket?.isConnected ?? false
        
                if connected {

                    do {
                        
                        let byteRead = try self.socket?.read(into: self.readData!) ?? 0
                            print(byteRead)
                            if byteRead > 0 {
                                
                                guard let response = String(data: self.readData! as Data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) else {
                                    
                                    print("Error decoding response...")
                                    self.readData?.length = 0
                                    return
                                }
                                print(response)
                                if response.contains("200") && response.contains("OK") {
                                    successHandler()
                                } else {
                                    shouldKeepRunning = false
                                    failureHandler(PTTError.notEncoding)
                                }
                                
                            } else {
                                shouldKeepRunning = false
                                failureHandler(PTTError.notConnect)
                    
                            }
     
                    } catch {
                        failureHandler(PTTError.notConnect)
                    }
        }

    }
    
//    func logingPtt() {
//        
//        let accountBig5 = accout.big5Data ?? NSData()
//        
//        do {
//            try socket?.write(from: accountBig5)
//            
//            try socket?.write(from: "\r\n")
//            
//        } catch {
//            
//            print(PTTError.notLogin)
//        }
//  
//        do {
//            
//            let byteRead = try socket?.read(into: &readData) ?? 0
//            
//            if byteRead > 0 {
//                
//                guard let response = String(bytes: readData, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) else {
//                    
//                    print("Error decoding response...")
//                    readData.count = 0
//                    return
//                }
//                
//                print(response)
//            }
//            
//        } catch {
//            
//            
//            print(PTTError.notLogin)
//        }
//     
//        
//    }

}
