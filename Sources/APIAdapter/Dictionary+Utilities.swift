//
//  Dictionary+Utilities.swift
//
//  Created by Adam Leitgeb on 04/12/2018.
//  Copyright © 2018 Adam Leitgeb. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value: Any {
    var urlEncodedString: String? {
        guard let urlEncoded = queryString?.dropFirst() else {
            return nil
        }
        return String(urlEncoded)
    }

    var queryItems: [URLQueryItem] {
        map {
            let value = String(describing: $1)

            return value.isEmpty
                ? URLQueryItem(name: $0, value: nil)
                : URLQueryItem(name: $0, value: value)
        }
    }

    func url(from baseUrl: URL) -> URL? {
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems

        return components?.url
    }

    // MARK: - Utilities

    private var queryString: String? {
        var components = URLComponents()
        components.queryItems = queryItems

        return components.url?.absoluteString
    }
}
