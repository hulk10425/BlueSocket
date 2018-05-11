//
//  Extension.swift
//  SocketTest
//
//  Created by 陳遵丞 on 2018/5/11.
//  Copyright © 2018年 陳遵丞. All rights reserved.
//

import Foundation

//MARK: Big5 Data -> String
extension NSData {
    
    var big5String: String? {
        let big5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue))
        
        return NSString(data: self as Data, encoding: big5) as String?;
        
    }
    
}
//MARK: String -> Big5
extension String {
    
    var big5Data: NSData? {
        let big5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue))
        return self.data(using: String.Encoding(rawValue: big5), allowLossyConversion: false) as NSData?;
    }
    
}
