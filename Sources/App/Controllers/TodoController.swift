import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        let result = try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
        return result
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
