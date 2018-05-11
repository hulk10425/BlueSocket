//
//  ViewController.swift
//  SocketTest
//
//  Created by 陳遵丞 on 2018/5/10.
//  Copyright © 2018年 陳遵丞. All rights reserved.
//

import UIKit
import Socket


class ViewController: UIViewController {
    
    
    var socket: Socket?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = PTTManager()
     
        manager.connectPtt(successHandler: {
            
            manager.logingPtt()
            
        }, failureHandler: { error in
            
        })
        
        
        
    }
    
    func initSocket() {
        do {
            socket = try Socket.create()
            
        } catch {
            
            print(error)
            
        }
    }
    
    func connectPtt() {
        
        var readData = NSMutableData(capacity: 4096)
        
        do {
            
            try socket?.connect(to: "ptt.cc", port: 23)
            
            let connected = socket?.isConnected ?? false
            
            if connected{
                
                let byteRead = try socket?.read(into: readData!) ?? 0
                
                if byteRead > 0 {
                    
                    guard let response = NSString(bytes: readData!.bytes, length: readData!.length, encoding: String.Encoding.utf8.rawValue) else {
                        //無法解析。 請查家裡的code 看怎麼解析
                        print("Error decoding response...")
                        readData!.length = 0
                        return
                    }
                    
                    print(response)
                    
                }
                
                
                
            } else {
                
            }
            
        } catch {
            
            print(error)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
    
    func loginPtt() {
        
//        let accountBig5 = account.big5Data
//        let pwdBig5 = pwd.big5Data
//
//        client.send(data: Data(referencing: accountBig5!))
//        client.send(string: "\r\n")
//
//        client.send(data: Data(referencing: pwdBig5!))
//        let result = client.send(string: "\r\n")
//
//        //String(data: , encoding: .utf8)
//        client.read(10)
        
        
        
    }


}

