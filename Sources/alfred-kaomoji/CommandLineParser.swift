struct CommandLineParser {
    enum QueryType: String {
        case emoji
        case kaomoji
    }

    enum ParseError: Error {
        case noQuery
        case wrongQueryType

        func description() -> String {
            switch self {
            case .noQuery:
                fallthrough
            case .wrongQueryType:
                return "Specify query type as a first parameter, either '\(QueryType.emoji.rawValue)' or '\(QueryType.kaomoji.rawValue)'"
            }
        }
    }

    static func parse() throws -> (queryType: QueryType, query: String) {
        var arguments = CommandLine.arguments

        // First element is script name
        arguments.removeFirst()

        guard arguments.count > 0 else { throw ParseError.noQuery }

        guard let queryType = QueryType(rawValue: arguments.removeFirst()) else { throw ParseError.wrongQueryType }

        let query = arguments.joined(separator: " ")

        return (queryType, query)
    }
}
