# FirestoreWrapperCombineiOS

`FirestoreWrapperCombineiOS` is a Swift wrapper for Firebase Firestore that provides an easy way to perform CRUD operations on Firestore using the Combine framework.

## Installation 

### Swift Package Manager

You can install `FirestoreWrapperCombineiOS` using the [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, open your project and navigate to File > Swift Packages > Add Package Dependency.
2. Enter the repository URL `https://github.com/vGebs/FirestoreWrapperCombineiOS.git` and click Next.
3. Select the version you want to install, or leave the default version and click Next.
4. In the "Add to Target" section, select the target(s) you want to use `LocalAuthWrapperiOS` in and click Finish.

### Firebase packages

Please note that this package relies on:

1. FirebaseFirestore
2. FirebaseFirestoreSwift

Make sure to have these installed!

Additionally, make sure you also have a GoogleService-info.plist added to your project.

## Usage

Here is an example service class that uses the `FirestoreWrapper` class

```swift
import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirestoreWrapperCombineiOS

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
```

### FirestoreProtocol

Models used with this package need to abide by the `FirestoreProtocol`.
Here is an example model that abides by the `FirestoreProtocol`

```swift
import Foundation
import FirebaseFirestoreSwift
import FirestoreWrapperCombineiOS

struct User: Equatable, FirestoreProtocol, Hashable {
    @DocumentID var documentID: String?
    var name: String
    var height: Int
    var birthdate: Date?
}
```

The protocol states that abiding objects must implement a documentID of type String?

## Examples

For more information on how to use, please reference the SampleUsage folder inside `Sources/FirestoreWrapperCombineiOS/SampleUsage`

## License

`LocalAuthWrapperiOS` is released under the MIT license. See LICENSE for details.

## Contribution

We welcome contributions to `LocalAuthWrapperiOS`. If you have a bug fix or a new feature, please open a pull request.
