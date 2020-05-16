//
//  ResponseWrapper.swift
//
//  Created by Adam Leitgeb on 22/07/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Foundation

public struct ResponseWrapper<T: Decodable>: Decodable {
    let data: T
    let success: Bool
    let code: Int?
    let message: String?
}
