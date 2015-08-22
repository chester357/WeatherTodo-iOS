import Foundation

public enum Weather: Int {
    case Bad = 0
    case Fair = 1
    case Good = 2
    case Great = 3
    
    func toString() -> String {
        switch self {
        case .Bad:
            return "Bad Weather"
        case .Fair:
            return "Fair Weather"
        case .Good:
            return "Good Weather"
        case .Great:
            return "Great Weather!"
        default:
            return ""
        }
    }
}
