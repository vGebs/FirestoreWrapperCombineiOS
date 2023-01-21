//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Equatable, FirestoreProtocol, Hashable {
    @DocumentID var documentID: String?
    var name: String
    var height: Int
    var birthdate: Date?
}
