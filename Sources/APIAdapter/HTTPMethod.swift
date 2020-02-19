//
//  HTTPMethod.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete  = "DELETE"
    case get     = "GET"
    case head    = "HEAD"
    case options = "OPTIONS"
    case post    = "POST"
    case patch   = "PATCH"
    case put     = "PUT"
    case trace   = "TRACE"
}
