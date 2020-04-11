//
//  Volume.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import Foundation

struct Volume: Codable {
    let kind, id, etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo?
}

struct AccessInfo: Codable {
    let country, viewability: String
    let embeddable, publicDomain: Bool
    let textToSpeechPermission: String
    let epub, pdf: Epub
    let webReaderLink: String
    let accessViewStatus: String
    let quoteSharingAllowed: Bool
}

struct Epub: Codable {
    let isAvailable: Bool
}

struct SaleInfo: Codable {
    let country, saleability: String
    let isEbook: Bool
}

struct SearchInfo: Codable {
    let textSnippet: String
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher, publishedDate, description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingModes
    let pageCount: Int?
    let printType, maturityRating: String
    let allowAnonLogging: Bool
    let contentVersion: String
    let panelizationSummary: PanelizationSummary?
    let imageLinks: ImageLinks?
    let language: String
    let previewLink, infoLink: String
    let canonicalVolumeLink: String
    let subtitle: String?
    let categories: [String]?
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}

struct IndustryIdentifier: Codable {
    let type, identifier: String
}

struct PanelizationSummary: Codable {
    let containsEpubBubbles, containsImageBubbles: Bool
}

struct ReadingModes: Codable {
    let text, image: Bool
}
