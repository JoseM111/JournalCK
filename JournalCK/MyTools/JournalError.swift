import Foundation

enum JournalError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    // Give the user whatever information you think they should know.
    var errorDescription: String {
        switch self {
            case .ckError(let error):
                return error.localizedDescription
            case .couldNotUnwrap:
            return "Unable to get this type..which is not very hype..."
        }
    }
}

