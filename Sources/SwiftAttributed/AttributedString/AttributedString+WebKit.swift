//
//  NSMutableAttributedString.swift
//  GREFoundation
//
//  Created by Cao, Jiannan on 7/29/19.
//  Copyright © 2019 Cao, Jiannan. All rights reserved.
//

#if !os(watchOS) && !os(tvOS)
import WebKit

public extension AttributedString {
    typealias CompletionHandler = (AttributedString?, [DocumentAttributeKey : Any]?, Error?) -> Void
    static func loadFromHTML(data: Data, options: [DocumentReadingOptionKey : Any] = [:], completionHandler: @escaping CompletionHandler) {
        NSAttributedString.loadFromHTML(data: data, options: options) { completionHandler($0.map(Self.init), $1, $2) }
    }
    static func loadFromHTML(fileURL: URL, options: [DocumentReadingOptionKey : Any] = [:], completionHandler: @escaping CompletionHandler) {
        NSAttributedString.loadFromHTML(fileURL: fileURL, options: options) { completionHandler($0.map(Self.init), $1, $2) }
    }
    static func loadFromHTML(request: URLRequest, options: [DocumentReadingOptionKey : Any] = [:], completionHandler: @escaping CompletionHandler) {
        NSAttributedString.loadFromHTML(request: request, options: options) { completionHandler($0.map(Self.init), $1, $2) }
    }
    static func loadFromHTML(string: String, options: [DocumentReadingOptionKey : Any] = [:], completionHandler: @escaping CompletionHandler) {
        NSAttributedString.loadFromHTML(string: string, options: options) { completionHandler($0.map(Self.init), $1, $2) }
    }
}
#endif
