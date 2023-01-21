//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-21.
//

import Foundation
import Combine
import FirebaseFirestore

class ViewModel: ObservableObject {
    
    private let userService = UserService.shared
    
    private var singleEmitters: [AnyCancellable] = []
    private var listeners: [AnyCancellable] = []
    
    private let db = Firestore.firestore()
    
    @Published var users: [User] = []
    
    init() {
        listenForUsers()
    }
    
    func pushUser() {
        
        let user = User(name: "new new", height: 69, birthdate: Date())
        
        userService.createUser(user)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let e):
                    print(e)
                case .finished:
                    print("Finished creating user")
                }
            } receiveValue: { _ in
                
            }.store(in: &singleEmitters)
    }
    
    func fetchUser() {
        if users.count > 0 {
            let docID = users[0].documentID
            userService.fetchUser(docID!)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let e):
                        print(e)
                    case .finished:
                        print("Finished fetching user w/ docID: \(docID!)")
                    }
                } receiveValue: { [weak self] user in
                    self?.users.append(user)
                }.store(in: &singleEmitters)
        }
    }
    
    func fetchUsers() {
        let query: Query = db.collection("Users")
        userService.fetchUsers(query)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let e):
                    print(e)
                case .finished:
                    print("Finished fetching users")
                }
            } receiveValue: { [weak self] users in
                self?.users += users
            }.store(in: &singleEmitters)
    }
    
    func updateUser() {
        if users.count > 0 {
            let docID = users[0].documentID!
            let newUser = User(name: "UpdatedName", height: 6969, birthdate: Date())
            
            userService.updateUser(docID, newUser)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let e):
                        print(e)
                    case .finished:
                        print("Finished updating user")
                    }
                } receiveValue: { _ in }
                .store(in: &singleEmitters)
        }
    }
    
    func deleteUser() {
        if users.count > 0 {
            let docID = users[0].documentID!
            userService.deleteUser(docID)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let e):
                        print(e)
                    case .finished:
                        print("Finished deleting user w/ docID: \(docID)")
                    }
                } receiveValue: { _ in }
                .store(in: &singleEmitters)
        }
    }
    
    private func listenForUser() {
        if self.users.count > 0 {
            let docID = self.users[0].documentID!
            userService.listenOnUser(docID)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let e):
                        print(e)
                    case .finished:
                        print("Received new user")
                    }
                } receiveValue: { [weak self] userTuple in
                    let user = userTuple.0
                    let changeType = userTuple.1
                    
                    switch changeType {
                    case .added:
                        print("")
                        //this function will never return .added
                    case .modified:
                        print("Modified")
                        //Handle modified
                        var changed = false
                        for i in 0..<self!.users.count {
                            if self!.users[i].documentID == user.documentID {
                                self!.users[i] = user
                                print("Changed")
                                changed = true
                            }
                        }
                        
                        if !changed {
                            self!.users.append(user)
                        }
                    case .removed:
                        print("removed")
                        //handle removed
                        self?.findAndRemove(element: user)
                    }
                }.store(in: &listeners)
        }
    }
    
    private func listenForUsers() {
        
        let query = db.collection("Users")
        userService.listenOnUsers(query)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let e):
                    print(e)
                case .finished:
                    print("Finished fetching users")
                }
            } receiveValue: { [weak self] users in
                print(users.count)
                for user in users {
                    let changeType = user.1
                    let currentUser = user.0
                    
                    switch changeType {
                    case .added:
                        print("")
                        // when a new document is added, it is also modified,
                    case .modified:
                        print("modified")
                        //handle modified user
                        var changed = false
                        for i in 0..<self!.users.count {
                            if self!.users[i].documentID == currentUser.documentID {
                                self!.users[i] = currentUser
                                print("Changed")
                                changed = true
                            }
                        }
                        
                        if !changed {
                            self!.users.append(currentUser)
                        }
                        
                    case .removed:
                        print("removed")
                        //handle removed user
                        self?.findAndRemove(element: currentUser)
                    }
                }
            }.store(in: &listeners)
    }
    
    func cancelListeners() {
        for listener in listeners {
            listener.cancel()
        }
    }
    
    func cancelSingleEmitters() {
        for singleEmitter in singleEmitters {
            singleEmitter.cancel()
        }
    }
}

extension ViewModel {
    func findAndRemove(element: User) {
        if let index = self.users.firstIndex(of: element) {
            self.users.remove(at: index)
        }
    }
}
