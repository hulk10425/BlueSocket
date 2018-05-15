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
    case writeError
    case cantEnterMyMail
}
//todo 在沒有反應的情況下，應該要自動重新登入，要不然會TimeOut 掛掉
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
        let readData = NSMutableData(capacity: 1024 * 10)
        
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
                               
                                if response.contains("200") && response.contains("OK") {
                                    print("***連線成功")
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
    
    func logingPtt(successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
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

            let byteRead = try! self.socket?.read(into: &loginReadData) ?? 0
                    
            if byteRead > 0 {
                        
                if let response = String(data: loginReadData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    try! socket?.write(from: "\r\n")
                    
                    if response.contains("主功能表") || response.contains("請按任意鍵繼續"){
                        print("****登入成功")
                        successHandler()
                        
                    }
                    
                }
            }

        }
        
        failureHandler(PTTError.notLogin)
        
    }
    
    func goToMainMenu(successHandler:@escaping(() -> Void),failureHandler:((_ error: PTTError) -> Void)?) {
        
        
        for _ in 1...10 {
            
            do {
              _ = try socket?.write(from: "q")
            } catch {
                failureHandler!(PTTError.writeError)
            }
    
        }
        
        print("****已到主目錄")
        successHandler()
    }
    
    func goToMyMailMenu(successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
        do {
            _ = try socket?.write(from: "m")
            
            _ = try socket?.write(from: "\r\n")
            
        } catch {
            
            failureHandler(PTTError.writeError)
        }
        
        for _ in 0...10 {
            
            var messageMenuData = Data(capacity: 1024 * 10)
            
            let byteRead = try! self.socket?.read(into: &messageMenuData) ?? 0
            
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    print(response)
                    
                    if response.contains("信箱"){
                        print("****已到我的信箱目錄")
                        successHandler()
                        
                    }
                    
                }
            }
            
        }
        
        failureHandler(PTTError.cantEnterMyMail)
    }
    
    func enterMyMail(successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
        do {
            _ = try socket?.write(from: "s")
            _ = try socket?.write(from: "\r\n")
            
        } catch {
            
            failureHandler(PTTError.writeError)
            
        }
        
        for _ in 0...10 {
            
            var messageMenuData = Data(capacity: 1024 * 10)
            
            let byteRead = try! self.socket?.read(into: &messageMenuData) ?? 0
            
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    if response.contains("請輸入"){
                        print("****已進入信箱內")
                        successHandler()
                        
                    }
                    
                }
            }
            
        }
        
        failureHandler(PTTError.cantEnterMyMail)
    
    }
    
    func sendPrivateMessage(user: String, mailContent: String, successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
        do {
            _ = try socket?.write(from: user)
            _ = try socket?.write(from: "\r\n")
            
        } catch {
            
            failureHandler(PTTError.writeError)
            
        }
        
        for _ in 0...10 {
            
            var messageMenuData = Data(capacity: 1024 * 10)
            
            let byteRead = try! self.socket?.read(into: &messageMenuData) ?? 0
            
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    print(response)
                    
                    if response.contains("主題"){
                        
                        
                        
                    }
                    
                }
            }
            
        }
        
    
        
        
        
        
        
        
        
        
        
        // MARK: 輸入寄信內容
        do {
            _ = try socket?.write(from: mailContent)
            _ = try socket?.write(from: "\r\n")
            _ = try socket?.write(from: "\r\n")
            
        } catch {
            
            failureHandler(PTTError.writeError)
        }
        
        for _ in 0...10 {
            
            var messageMenuData = Data(capacity: 1024 * 10)
            
            let byteRead = try! self.socket?.read(into: &messageMenuData) ?? 0
            
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    print(response)
                    //MARK: 檢查信件內容
                    if !response.contains("意願"){
                        
                        failureHandler(PTTError.writeError)
                        
                    }
                    
                }
            }
            
        }
        
        var myInt = [24]
        let myIntData = Data(bytes: &myInt,
                             count: MemoryLayout.size(ofValue: myInt))
        
        for _ in 0...5 {
            
            do {
                _ = try socket?.write(from: myIntData)
            } catch {
                failureHandler(PTTError.writeError)
            }
        }
        
        for _ in 0...10 {
            
            var messageMenuData = Data(capacity: 1024 * 10)
            
            let byteRead = try! self.socket?.read(into: &messageMenuData) ?? 0
            
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    print(response)
                    //MARK: 檢查有無按 Ctrl + p
                    if !response.contains("案處"){
                        
                        failureHandler(PTTError.writeError)
                        
                    }
                    
                }
            }
            
        }
        
        do {
            
            _ = try socket?.write(from: "s")
            
        } catch {
            
            failureHandler(PTTError.writeError)
            
        }
        
        
        successHandler()
 
 
    }
    
}
