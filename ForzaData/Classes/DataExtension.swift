//
//  DataExtension.swift
//  ForzaData
//
//  Created by Quentin Zervaas on 29/11/18.
//

import Foundation

extension Data {
    
    /// Decodes the receiver into the given struct type
    func decode<T>() -> T? {
        guard self.count == MemoryLayout<T>.size.self else {
            return nil
        }
        
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        (self as NSData).getBytes(pointer, length: self.count)
        
        return pointer.move()
    }
    
    static func encode<T>(_ object: T) -> Data {
        
        var object = object
        
        return Data(bytes: &object, count: MemoryLayout<T>.size.self)
    }
}


