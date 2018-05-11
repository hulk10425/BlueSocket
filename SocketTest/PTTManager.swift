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
    
    
    override init() {
        
        do {
            socket = try Socket.create()
            
        } catch {
            
            print(error)
            
        }
        
    }
    
    func connectPtt(successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        var readData = NSMutableData(capacity: 1024 * 10)
        
        //連線成功
        do {
           
            try socket?.connect(to: "ptt.cc", port: 23)
            
        } catch {
            
            failureHandler(PTTError.notConnect)
        }

            let connected = self.socket?.isConnected ?? false
        
                if connected {

                    do {
                        
                        let byteRead = try self.socket?.read(into: readData!) ?? 0
                            print(byteRead)
                            if byteRead > 0 {
                                
                                guard let response = String(data: readData! as Data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) else {
                                    
                                    print("Error decoding response...")
                                    readData?.length = 0
                                    return
                                }
                                
                                print(response)
                               
                                if response.contains("200") && response.contains("OK") {
                                    
                                    successHandler()
                                } else {
                                    
                                    failureHandler(PTTError.notEncoding)
                                }
                                
                            } else {
                                
                                failureHandler(PTTError.notConnect)
                    
                            }
     
                    } catch {
                        failureHandler(PTTError.notConnect)
                    }
        }

    }
    
    func logingPtt() {
        
        do {
            try socket?.write(from: accout)
            try socket?.write(from: "\r\n")
            try socket?.write(from: pwd)
            try socket?.write(from: "\r\n")

        } catch {

            print(PTTError.notLogin)
        }
        
        
        for _ in 0...10 {
            
            var loginReadData = Data(capacity: 1024 * 10)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                    let byteRead = try! self.socket?.read(into: &loginReadData) ?? 0
                    
                    if byteRead > 0 {
                        
                        if let response = String(data: loginReadData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                            
                            print(response)
                        } else {
                            print("Error decoding response...")
                          
                        }
                        
                    }
//            }
    
        }
        
            
        
  
    }

}
