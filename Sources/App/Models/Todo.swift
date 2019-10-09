import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?
    
    /// A title describing what this `Todo` entails.
    var title: String
    var email: String
    var password: String
    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, email: String, password: String) {
        self.id = id
        self.title = title
        self.email = email
        self.password = password
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }







/// A single entry of a Todo list.
final class User: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?
    
    /// A title describing what this `Todo` entails.
    var title: String
    var email: String
    var password: String
    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, email: String, password: String) {
        self.id = id
        self.title = title
        self.email = email
        self.password = password
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
