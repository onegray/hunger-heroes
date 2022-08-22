//
//  Created by sergeyn on 10.09.20.
//

import Foundation

class Keychain {

    static var shared = Keychain()

    func setStringValue(_ value: String?, forKey key: String) {

        let query = NSMutableDictionary()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrService] = key

        if SecItemCopyMatching(query, nil) == noErr {
            if let data = value?.data(using: .utf8) {
                SecItemUpdate(query, [kSecValueData: data] as CFDictionary)
            } else {
                SecItemDelete(query)
            }
        } else {
            if let data = value?.data(using: .utf8) {
                query[kSecValueData] = data
                query[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                SecItemAdd(query, nil)
            }
        }
    }

    func string(forKey key: String) -> String? {

        let query = NSMutableDictionary()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecAttrService] = key

        var queryResult: AnyObject? = nil
        if SecItemCopyMatching(query, &queryResult) == noErr,
           let resultDict = queryResult as? NSDictionary,
           let resultData = resultDict[kSecValueData] as? Data
        {
            return String(data: resultData, encoding: .utf8)
        }

        return nil
    }
}

