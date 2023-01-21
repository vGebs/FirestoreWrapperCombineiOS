//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserService {
    private let firestore = FirestoreWrapper.shared
    
    static let shared = UserService()
    
    private let collection = "Users"
    
    private init() {}
    
    func createUser(_ user: User) -> AnyPublisher<Void, Error> {
        return firestore.create(collection: collection, data: user)
    }
    
    func fetchUser(_ docID: String) -> AnyPublisher<User, Error> {
        return firestore.read(collection: collection, documentId: docID)
    }
    
    func fetchUsers(_ query: Query) -> AnyPublisher<[User], Error> {
        return firestore.read(query: query)
    }
    
    func updateUser(_ docID: String, _ user: User) -> AnyPublisher<Void, Error> {
        return firestore.update(collection: collection, documentId: docID, data: user)
    }
    
    func deleteUser(_ docID: String) -> AnyPublisher<Void, Error> {
        return firestore.delete(collection: collection, documentId: docID)
    }
    
    func listenOnUser(_ docID: String) -> AnyPublisher<(User, DocumentChangeType), Error> {
        return firestore.listenByDocument(collection: collection, documentId: docID)
    }
    
    func listenOnUsers(_ query: Query) -> AnyPublisher<[(User, DocumentChangeType)], Error> {
        return firestore.listenByQuery(query: query)
    }
}
