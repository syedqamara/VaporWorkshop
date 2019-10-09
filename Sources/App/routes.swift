import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "the ENTERTAINER"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("new", use: todoController.create)
    router.post("register", use: todoController.signUp)
    router.post("search", use: todoController.search)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
