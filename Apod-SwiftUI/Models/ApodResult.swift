//
//  ApodJson.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation

struct ApodResult: Codable {
    var copyright: String?
    var date: Date
    var url: URL?
    var hdurl: URL?
    var mediaType: MediaType
    var explanation: String
    var version: String
    var title: String
    var thumbnailUrl: URL?
    
    static var dateFormatter: DateFormatter {
        let fm = DateFormatter()
        fm.dateFormat = "YYYY-MM-dd"
        return fm
    }
    
    func getFormatterDate() -> String {
        return Self.dateFormatter.string(from: date)
    }
    
    enum MediaType: String, Codable {
        case Image = "image"
        case Video = "video"
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case copyright
        case date
        case explanation
        case hdurl
        case version = "service_version"
        case title
        case url
        case thumbnailUrl = "thumbnail_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try values.decode(String.self, forKey: CodingKeys.title)
        self.copyright = try? values.decode(String.self, forKey: CodingKeys.copyright)
        
        let strDate = try values.decode(String.self, forKey: CodingKeys.date)
        let formatter = Self.dateFormatter
        self.date = formatter.date(from: strDate) ?? Date()
        
        self.explanation = try values.decode(String.self, forKey: CodingKeys.explanation)
        
        self.hdurl = try? values.decode(URL.self, forKey: CodingKeys.hdurl)
        self.url = try? values.decode(URL.self, forKey: CodingKeys.url)
        
        self.version = try values.decode(String.self, forKey: CodingKeys.version)
        self.mediaType = try values.decode(MediaType.self, forKey: CodingKeys.mediaType)
        
        self.thumbnailUrl = try values.decode(URL.self, forKey: CodingKeys.mediaType)
    }
}



#if DEBUG

let testApodStr: String = """
{"date":"2019-07-08","explanation":"What's happening at the center of our galaxy? It's hard to tell with optical telescopes since visible light is blocked by intervening interstellar dust. In other bands of light, though, such as radio, the galactic center can be imaged and shows itself to be quite an interesting and active place.  The featured picture shows the inaugural image of the MeerKAT array of 64 radio dishes just completed in South Africa. Spanning four times the angular size of the Moon (2 degrees), the image is impressively vast, deep, and detailed.  Many known sources are shown in clear detail, including many with a prefix of Sgr, since the Galactic Center is in the direction of the constellation Sagittarius.  In our Galaxy's Center lies Sgr A, found here just to the right of the image center, which houses the Milky Way's central supermassive black hole.  Other sources in the image are not as well understood, including the Arc, just to the left of  Sgr A, and numerous filamentary threads. Goals for MeerKAT include searching for radio emission from neutral hydrogen emitted in a much younger universe and brief but distant radio flashes.","hdurl":"https://apod.nasa.gov/apod/image/1907/GCenter_MeerKAT_5000.jpg","media_type":"image","service_version":"v1","title":"The Galactic Center in Radio from MeerKAT","url":"https://apod.nasa.gov/apod/image/1808/GCenter_MeerKAT_1080.jpg"}
"""

var decoder = JSONDecoder();

let testData = try! decoder.decode(ApodResult.self, from: testApodStr.data(using: .utf8)!)
#endif
