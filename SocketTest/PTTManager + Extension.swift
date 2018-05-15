//
//  PTTManager + Extension.swift
//  SocketTest
//
//  Created by 陳遵丞 on 2018/5/15.
//  Copyright © 2018年 陳遵丞. All rights reserved.
//

import Foundation
import Socket

extension PTTManager {
    
    func enterUserName(user: String, successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
        do {
            _ = try socket?.write(from: user)
            _ = try socket?.write(from: "\r\n")
            
        } catch {
            
            failureHandler(PTTError.writeError)
            
        }
        
        for _ in 0...2 {
            
            var messageMenuData = Data(capacity: 1024 * 10)
            
            var byteRead = 0
            
            do {
                byteRead = try self.socket?.read(into: &messageMenuData) ?? 0
            } catch {
                failureHandler(PTTError.readError)
            }
            
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    if response.contains("主題"){
                        print("****userName輸入完畢")
                        
                        successHandler()
                        
                    }
                    
                }
            }
            
        }
        
        failureHandler(PTTError.writeError)
 
    }
    
    
    func enterMailContent(mailContent: String, successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        //
       
        do {
            //標題
            _ = try socket?.write(from: mailContent)
            _ = try socket?.write(from: "\r\n")
            _ = try socket?.write(from: "\r\n")
            //內文
            _ = try socket?.write(from: mailContent)
            _ = try socket?.write(from: "\r\n")
            
        } catch {
            
            failureHandler(PTTError.writeError)
        }
        
        print("*****,輸入完信件標題及內文")
        successHandler()
        
    }
    
    func sendMail(successHandler:@escaping(() -> Void), failureHandler:@escaping ((_ error: PTTError) -> Void)) {
        
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
            
            var byteRead = 0
            
            do {
                byteRead = try self.socket?.read(into: &messageMenuData) ?? 0
            } catch {
                failureHandler(PTTError.readError)
            }
    
            if byteRead > 0 {
                
                if let response = String(data: messageMenuData , encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue)))) {
                    
                    print(response)
                    //MARK: 檢查有無按 Ctrl + p
                    if response.contains("案處"){
                        print("****已經按了 ctrl + p ")
                        successHandler()
                        
                    }
                    
                }
            }
            
        }
        
        failureHandler(PTTError.writeError)
     
    }
 
}
