//
//  KeychainItem.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

struct KeychainItem {
    // MARK: Types

    enum KeychainError: Error {
        case noValue
        case unexpectedValueData
        case unexpectedItemData
        case unhandledError
    }

    // MARK: Properties

    let service: String

    private(set) var key: String

    let accessGroup: String?

    // MARK: Intialization

    init(service: String, key: String, accessGroup: String? = nil) {
        self.service = service
        self.key = key
        self.accessGroup = accessGroup
    }

    // MARK: Keychain access

    func readItem() throws -> String {
        /*
         Build a query to find the item that matches the service, key and access group.
         */
        var query = KeychainItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noValue }
        guard status == noErr else { throw KeychainError.unhandledError }

        // Parse the value string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
              let valueData = existingItem[kSecValueData as String] as? Data,
              let value = String(data: valueData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedValueData
        }
        return value
    }

    func saveItem(_ value: String) throws {
        // Encode the value into an Data object.
        let encodedValue = value.data(using: String.Encoding.utf8)!

        do {
            // Check for an existing item in the keychain.
            try _ = readItem()

            // Update the existing item with the new value.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedValue as AnyObject?

            let query = KeychainItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noValue {
            /*
             No value was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedValue as AnyObject?

            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }

    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }

    // MARK: Convenience

    private static func keychainQuery(withService service: String, key: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = key {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }
}
