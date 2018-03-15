import SwiftyJSON
import Foundation

let service = AlfredService()
let queryType: CommandLineParser.QueryType
let query: String

do {
    (queryType, query) = try CommandLineParser.parse()
}
catch let error as CommandLineParser.ParseError {
    service.output(error: AlfredError(title: "Cannot parse arguments", subtitle: error.description()))
    exit(1)
}


let baseURLString: String
let rootKey: String

switch queryType {
case .emoji:
    baseURLString = "https://emoji.getdango.com/api/emoji"
    rootKey = "results"
case .kaomoji:
    baseURLString = "https://customer.getdango.com/dango/api/query/kaomoji"
    rootKey = "items"
}

var urlComponents = URLComponents(string: baseURLString)!
urlComponents.query = "q=" + query
let url = urlComponents.url!


do {
    guard let data = try? Data(contentsOf: url) else { throw LookupError.cannotLoadData }
    guard let json = try? JSON(data: data) else { throw LookupError.cannotParseData }

    let items = json[rootKey].arrayValue.map {
        AlfredItem(
            uid: url.absoluteString,
            title: $0["text"].stringValue,
            arg: $0["text"].stringValue)
    }

    service.output(items: items)
}
catch let error as LookupError {
    service.output(error: AlfredError(title: "Service is unavailable", subtitle: error.description()))
    exit(1)
}
