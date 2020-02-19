//
//  APIAdapterError.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

public struct APIAdapterError: LocalizedError, Decodable {
    let success: Bool
    let message: String

    public var errorDescription: String? {
        return message
    }
}

// MARK: - Errors

extension APIAdapterError {
    static let unknown = APIAdapterError(
        success: false,
        message: NSLocalizedString("APIAdapterError.unknown", comment: "Unknown error")
    )

    static let invalidData = APIAdapterError(
        success: false,
        message: NSLocalizedString("APIAdapterError.invalidData", comment: "Invalid response data")
    )

    static let authenticationFailed = APIAdapterError(
        success: false,
        message: NSLocalizedString("APIAdapterError.authenticationFailed", comment: "Authentication failed. Please login")
    )
}
