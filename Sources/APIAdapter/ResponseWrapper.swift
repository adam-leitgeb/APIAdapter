//
//  ResponseWrapper.swift
//
//  Created by Adam Leitgeb on 22/07/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Foundation

public struct ResponseWrapper<T: Decodable>: Decodable {
    public let data: T
    public let success: Bool
    public let code: Int?
    public let message: String?
}
