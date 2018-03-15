import SwiftyJSON
import Foundation

let query = CommandLine.arguments.dropFirst().joined(separator: " ")

var urlComponents = URLComponents(string: "https://customer.getdango.com/dango/api/query/kaomoji")!
urlComponents.query = "q=" + query
let url = urlComponents.url!

let service = AlfredService()

do {
    guard let data = try? Data(contentsOf: url) else {
        throw LookupError("Cannot download kaomoji data")
    }
    guard let json = try? JSON(data: data) else {
        throw LookupError("Cannot parse downloaded data")
    }
    let items = json["items"].arrayValue.map {
        AlfredItem(
            uid: url.absoluteString,
            title: $0["text"].stringValue,
            arg: $0["text"].stringValue)
    }

    service.output(items: items)
}
catch {
    service.output(error: AlfredError(title: "Kaomoji service is unavailable", subtitle: error.localizedDescription))
}
