//
//  YakError.swift
//  YikyYak
//
//  Created by Devin Flora on 2/4/21.
//

import Foundation

enum YakError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return "There was an error with CloudKit: \(error)"
        case .couldNotUnwrap:
            return "Could not unwrap the Yak."
        }
    }
}//End of Enum
