import Vapor
import VaporMustache
import HTTP
import Foundation



let drop = Droplet(providers: [VaporMustache.Provider.self])

drop.serve()
