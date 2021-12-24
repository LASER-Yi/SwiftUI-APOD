//
//  ApodJson.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation
import SwiftUI

struct ApodData: Hashable, Codable,  Identifiable {
    var id: UUID = UUID()
    
    
    var copyright: String?
    var date: Date
    var url: URL?
    var hdurl: URL?
    var mediaType: MediaType
    var explanation: String
    var version: String
    var title: String
    var thumbnailUrl: URL?
    
    struct ApodError: Decodable {
        var code: Int
        var msg: String
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.code = try values.decode(Int.self, forKey: CodingKeys.code)
            
            do {
                self.msg = try values.decode(String.self, forKey: CodingKeys.msg)
            } catch {
                self.msg = try values.decode(String.self, forKey: CodingKeys.message)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case code
            case msg
            case message
        }
    }
    
    enum MediaType: String, Codable {
        case image = "image"
        case video = "video"
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
    
    private static var dateFormatter: DateFormatter {
        let fm = DateFormatter()
        fm.dateFormat = "YYYY-MM-dd"
        return fm
    }
    
    
    var formattedDate: String {
        get {
            return Self.dateFormatter.string(from: date)
        }
    }
    
    var imageUrl: URL? {
        get {
            if UserSetting.shared.loadHdImage {
                if self.hdurl != nil {
                    return self.hdurl
                } else {
                    return self.url
                }
            } else {
                return self.url
            }
        }
    }
    
}
