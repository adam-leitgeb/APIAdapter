//
//  ErrorDecodable.swift
//  
//
//  Created by Adam Leitgeb on 22/03/2020.
//

import Foundation

public protocol ErrorDecodable: Error, Decodable {
    init(from decoder: Decoder) throws
}
