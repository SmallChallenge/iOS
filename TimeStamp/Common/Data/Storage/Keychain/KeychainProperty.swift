//
//  KeychainProperty.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

@propertyWrapper
public struct Keychain {
    private let identifier: String = "swyp.stampy"
    private let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public var wrappedValue: String? {
        get {
            read(key: key)
        }
        set {
            if let newValue, newValue.isNotEmpty {
                save(key: key, value: newValue)
            } else {
              delete(key: key)
            }
        }
    }
    
    
}

extension Keychain {
    private func save(key: String, value: String) {
        do {
            try KeychainItem(service: identifier, key: key).saveItem(value)
        } catch {
             print(">>>>> failed to save data in keychain. error: \(error)")
        }
    }

    private func read(key: String) -> String? {
        do {
            let value: String = try KeychainItem(service: identifier, key: key).readItem()
            return value
        } catch {
             print(">>>>> failed to read data in keychain. error: \(error)")
            return nil
        }
    }

    private func delete(key: String) {
        do {
            try KeychainItem(service: identifier, key: key).deleteItem()
        } catch {
             print(">>>>> failed to delete data in keychain. error: \(error)")
        }
    }
}
