//
//  RequestData.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

public enum RequestData {
    case jsonBody(Parameters, query: Parameters?)
    case query(Parameters)
    case rawData(Data)
    case none
}
