//
//  UserDefaultsProperty.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

/// for 복잡한 객체 (User, Settings)
@propertyWrapper
public struct UserDefaultsWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?

    public init(key: String, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            if let newValue = newValue {
                let encoded = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}

/// for Bool, Int, String 등 기본 값 타입용
@propertyWrapper
public struct UserDefaultsValue<T> {
    private let key: String
    private let defaultValue: T

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
