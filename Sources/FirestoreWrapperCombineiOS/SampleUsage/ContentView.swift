//
//  File.swift
//  
//
//  Created by Vaughn on 2023-01-21.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            Button(action: {
                viewModel.pushUser()
            }) {
                Text("Push User")
            }.padding()
            
            Button(action: {
                viewModel.fetchUsers()
            }) {
                Text("Fetch user")
            }.padding()
            
            Button(action: {
                viewModel.deleteUser()
            }) {
                Text("Delete user")
            }.padding()
            
            Button(action: {
                viewModel.updateUser()
            }) {
                Text("update user")
            }.padding()
            
            VStack {
                ForEach(viewModel.users, id: \.self) { user in
                    Text("DocID: \(user.documentID ?? "Empty")").padding()
                }
            }
            .padding()
        }
    }
}
