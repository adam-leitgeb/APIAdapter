//
//  ResponseWrapper.swift
//
//  Created by Adam Leitgeb on 22/07/2019.
//  Copyright © 2019 Adam Leitgeb. All rights reserved.
//

import Foundation

struct ResponseWrapper<T: Decodable>: Decodable {
    let data: T
    let success: Bool
    let message: String
}
