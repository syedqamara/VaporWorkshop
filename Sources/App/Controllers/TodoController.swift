import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }
    //func abc(completion:(Any)->Any) -> Any {
    //    return 0
    //}
    //
    //func map(completion:(Any)->Any) -> Future<Any> {
    //    return 0
    //}
    //
    //func flatMap(completion:(Any)->Future<Any>) -> Future<Any> {
    //    return 0
    //}

    func signUp(_ req: Request) throws -> Future<ApiResponse> {
        return try req.content.decode(User.self).flatMap({ (decodedObject) -> Future<ApiResponse> in
            let response = ApiResponse()
            return User.query(on: req).all().flatMap { (allUsers) -> (Future<ApiResponse>) in
                
                let alreadyExistUser = allUsers.reduce(nil) { (previousSaved, user) -> User? in
                    if user.email == decodedObject.email {
                        return user
                    }
                    return previousSaved
                }
                if alreadyExistUser == nil {
                    return decodedObject.save(on: req).map { (savedObject) -> (ApiResponse) in
                        response.data.user = savedObject
                        return response
                    }
                }else {
                    response.code = 303
                    response.message = "Already Saved user"
                    return req.eventLoop.newSucceededFuture(result: response)
                }
            }
        }).catchMap({ (error) -> (ApiResponse) in
            let response = ApiResponse()
            response.code = 303
            response.message = error.localizedDescription
            return response
        })
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        
        return try req.content.decode(Todo.self).flatMap { (pureTodoObject) -> (Future<Todo>) in
            return pureTodoObject.save(on: req)
        }
//        return try req.content.decode(Todo.self).flatMap { todo in
//            return todo.save(on: req)
//        }
        
    }
    func search(_ req: Request) throws -> Future<SearchResponseM> {
        
        return try req.content.decode(SearchRequestM.self).flatMap({ (searchM) -> EventLoopFuture<SearchResponseM> in
            let response = SearchResponseM()
            let result = Todo.query(on: req).all().map { (allTodos) -> (SearchResponseM) in
                var filteredTodos: [Todo] = allTodos
                response.data = filteredTodos
                response.status_code = 200
                response.message = ""
                if let search_text = searchM.search_text {
                    filteredTodos = allTodos.filter({$0.title.contains(search_text)})
                    response.data = filteredTodos
                    if filteredTodos.count == 0 {
                        response.status_code = 400
                        response.message = "No Data Found"
                    }
                }
                
                
                return response
            }
            return result
        }).catchMap({ (error) -> (SearchResponseM) in
            let response = SearchResponseM()
            response.status_code = 300
            response.message = error.localizedDescription
            return response
        })
        
        
        
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}
