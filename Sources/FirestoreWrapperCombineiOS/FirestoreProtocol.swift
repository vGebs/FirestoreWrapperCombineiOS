//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-21.
//

import Foundation

public protocol FirestoreProtocol: Codable {
    var documentID: String? { get set }
}
