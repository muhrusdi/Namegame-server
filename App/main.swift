import Vapor
import VaporMustache
import HTTP
import VaporMySQL
import Foundation


/**
    Droplets are service containers that make accessing
    all of Vapor's features easy. Just call
    `drop.serve()` to serve your application
    or `drop.client()` to create a client for
    request data from other servers.
*/
let droplet = Droplet(preparations:[User.self, Person.self], providers: [VaporMustache.Provider.self, VaporMySQL.Provider.self])


/**
    This first route will return the welcome.html
    view to any request to the root directory of the website.

    Views referenced with `app.view` are by default assumed
    to live in <workDir>/Resources/Views/ 

    You can override the working directory by passing
    --workDir to the application upon execution.
*/
droplet.get("/") { request in
    return try droplet.view("welcome.html")
}

droplet.group("api/v1") {api in
    
    api.get("people", handler: { (request:Request) -> ResponseRepresentable in
        let response = try droplet.client.get("http://api.namegame.willowtreemobile.com/")
        guard let bytes = response.body.bytes else { throw Abort.custom(status: Status.failedDependency, message: "Could not covert willowtree api for persons to data") }
        let json = try JSON(bytes: bytes)
        for object in json.array! {
            
            let name = object.object!["name"].string!
            let url = object.object!["url"].string!
            print("name: \(name), url: \(url)")
        }
        return response
    })
    
    api.get("game-modes", handler: { (request:Request) -> ResponseRepresentable in
        return try JSON([
            "Match Name",
            "Match Picture",
            "Matt Mode",
            "Hint Mode"
        ])
    })
}


droplet.middleware.append(SampleMiddleware())


droplet.serve()
