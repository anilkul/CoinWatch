//
//  PersistencyManager.swift
//  CoinWatch
//
//  Created by Anıl Kul on 20.04.2023.
//

import Foundation

protocol PersistencyManagerProtocol {
    func set<Value>(newValue: Value, for key: Keys)
    func value<Value>(for key: Keys, defaultValue: Value) -> Value
    func remove(_ key: Keys)
    func encode<Value: Encodable>(newValue: Value, for key: Keys)
    func decode<Value: Decodable>(for key: Keys, defaultValue: Value) -> Value
}

final class PersistencyManager: PersistencyManagerProtocol {
    private let storage: UserDefaults

    init(storage: UserDefaults = .standard) {
        self.storage = storage
    }

    func remove(_ key: Keys) {
        storage.removeObject(forKey: key.rawValue)
    }

    func value<Value>(for key: Keys, defaultValue: Value) -> Value {
        let value = storage.value(forKey: key.rawValue) as? Value
        return value ?? defaultValue
    }

    func set<Value>(newValue: Value, for key: Keys) {
        
        if let optional = newValue as? AnyOptional, optional.isNil {
            storage.removeObject(forKey: key.rawValue)
        } else {
            storage.setValue(newValue, forKey: key.rawValue)
        }
    }
    
    func encode<Value: Encodable>(newValue: Value, for key: Keys) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newValue) {
            storage.set(encoded, forKey: key.rawValue)
        }
    }
    
    func decode<Value: Decodable>(for key: Keys, defaultValue: Value) -> Value {
        if let object = storage.object(forKey: key.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let decodedObject = try? decoder.decode(Value.self, from: object) {
                return decodedObject
            }
        }
        return defaultValue
    }

    func hasKey(_ key: Keys) -> Bool {
        return storage.object(forKey: key.rawValue) != nil
    }
}

enum Keys: String {
    case favorites
}

protocol AnyOptional {
    var isNil: Bool { get }
}
