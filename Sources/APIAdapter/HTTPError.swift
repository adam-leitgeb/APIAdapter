//
//  StatusCodeError.swift
//
//  Created by Adam Leitgeb on 16/07/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Foundation

public enum HTTPError: Int {

    // Redirection - 3xx

    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permenantRedirect = 308

    // Client Error - 4xx

    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case URITooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case teapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431

    // Server Error - 5xx

    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
}

// MARK: - Submodels

extension HTTPError {
    enum ResponseType {
        case redirection
        case clientError
        case serverError
        case undefined
    }
}

// MARK: - Utilities

extension HTTPError {
    var responseType: ResponseType {
        switch rawValue {
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .undefined
        }
    }
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch responseType {
        case .redirection:
            return "Error \(rawValue): Further action needs to be taken in order to complete the request"
            //NSLocalizedString("HTTPError.redirection", comment: "Further action needs to be taken in order to complete the request")
        case .clientError:
            return "Error \(rawValue): The request contains bad syntax or cannot be fulfilled"
            //NSLocalizedString("HTTPError.clientError", comment: "The request contains bad syntax or cannot be fulfilled")
        case .serverError:
            return "Error \(rawValue): The server failed to fulfill an apparently valid request"
            //NSLocalizedString("HTTPError.serverError", comment: "The server failed to fulfill an apparently valid request")
        case .undefined:
            return "Error \(rawValue): An error occured in the cloud. We are working on it"
            //NSLocalizedString("HTTPError.undefined", comment: "An error occured in the cloud. We are working on it")
        }
    }
}
