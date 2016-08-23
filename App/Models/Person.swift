//
//  Person.swift
//  namegame
//
//  Created by Phil Cole on 8/22/16.
//
//

import Foundation
import Vapor
import Fluent

struct Person: Model {
    var id: Node?
    let name:String
    
    init(name:String, url:String) {
        self.name = name
        self.id = Node(url)
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }
    
    func makeNode() throws -> Node {
        return try Node(node: [
            "id":id,
            "name":name
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("person", closure: { person in
            person.id("url", optional: false)
            person.string("name")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("person")
    }
}
