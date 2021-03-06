//
//  Authentication.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

public enum Authentication: String {
    case basic = "Basic "
    case bearer = "Bearer "
    case none = ""
}
