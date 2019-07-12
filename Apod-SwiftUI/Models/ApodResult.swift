//
//  ApodJson.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation

struct ApodResult: Hashable, Codable {
    var copyright: String?
    var date: Date
    var url: URL?
    var hdurl: URL?
    var mediaType: MediaType
    var explanation: String
    var version: String
    var title: String
    var thumbnailUrl: URL?
    
    struct Error: Codable {
        var code: Int
        var msg: String
    }
    
    struct LimitError: Codable {
        struct Error: Codable {
            var code: String
            var message: String
        }
        var error: Error
    }
    
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
{"copyright":"CISCO","date":"2001-02-20","explanation":"Massive star IRS4 is beginning to spread its wings.  Born only about 100,000 years ago, material streaming out from this newborn star has formed the nebula dubbed Sharpless 106 Nebula (S106), pictured above.  A large disk of dust and gas orbiting Infrared Source 4 (IRS4), visible in dark red near the image center, gives the nebula an hourglass shape.  S106 gas near IRS4 acts as an emission nebula as it emits light after being ionized, while dust far from IRS4 reflects light from the central star and so acts as a reflection nebula.  Detailed inspection of this representative color infrared image has revealed hundreds of low-mass brown dwarf stars lurking in the nebula's gas.  S106 spans about 2 light-years and lies about 2000 light-years away toward the constellation of Cygnus.","hdurl":"https://apod.nasa.gov/apod/image/0102/s106_subaru_big.jpg","media_type":"image","service_version":"v1","title":"Star Forming Region S106","url":"https://apod.nasa.gov/apod/image/0102/s106_subaru.jpg"}
"""

let testApodArray = """
[{"date":"2004-07-27","explanation":"Over one year after its launch, robot geologist Opportunity has been spending recent sols on Mars inching its way down the slopes of Endurance crater. Littered with martian blueberries, some flat rocks within the crater also seem to have surprising razorbacks -- narrow slabs sticking up along their edges. Like the blueberries, it's possible that the sharp, narrow features are related to water. They could be formed by minerals deposited by water in cracks, with the surrounding softer material subsequently eroded away. How narrow are they? The ones pictured here in an enhanced color image from Opportunity's panoramic camera are actually only a few centimeters high and about half a centimeter wide. Impressive 3D views have been constructed by stereo experimenter P. Vantuyne based on the camera's left and right eye images of the region.","hdurl":"https://apod.nasa.gov/apod/image/0407/razorback_merOpportunity_full.jpg","media_type":"image","service_version":"v1","title":"Razorbacks in Endurance Crater","url":"https://apod.nasa.gov/apod/image/0407/razorback_merOpportunity_c1.jpg"},{"copyright":"Daniele Boffelli","date":"2015-11-24","explanation":"Auroras usually occur high above the clouds.  The auroral glow is created when fast-moving particles ejected from the Sun impact the Earth's magnetosphere, from which charged particles spiral along the Earth's magnetic field to strike atoms and molecules high in the Earth's atmosphere.  An oxygen atom, for example, will glow in the green light commonly emitted by an aurora after being energized by such a collision.  The lowest part of an aurora will typically occur at 100 kilometers up, while most clouds usually exist only below about 10 kilometers.  The relative heights of clouds and auroras are shown clearly in the featured picture from Dyrholaey, Iceland. There, a determined astrophotographer withstood high winds and initially overcast skies in an attempt to capture aurora over a picturesque lighthouse, only to take, by chance, the featured picture along the way.","hdurl":"https://apod.nasa.gov/apod/image/1511/AuroraClouds_Boffelli_2048.jpg","media_type":"image","service_version":"v1","title":"Aurora over Clouds","url":"https://apod.nasa.gov/apod/image/1511/AuroraClouds_Boffelli_1080.jpg"},{"copyright":"CISCO","date":"2001-02-20","explanation":"Massive star IRS4 is beginning to spread its wings.  Born only about 100,000 years ago, material streaming out from this newborn star has formed the nebula dubbed Sharpless 106 Nebula (S106), pictured above.  A large disk of dust and gas orbiting Infrared Source 4 (IRS4), visible in dark red near the image center, gives the nebula an hourglass shape.  S106 gas near IRS4 acts as an emission nebula as it emits light after being ionized, while dust far from IRS4 reflects light from the central star and so acts as a reflection nebula.  Detailed inspection of this representative color infrared image has revealed hundreds of low-mass brown dwarf stars lurking in the nebula's gas.  S106 spans about 2 light-years and lies about 2000 light-years away toward the constellation of Cygnus.","hdurl":"https://apod.nasa.gov/apod/image/0102/s106_subaru_big.jpg","media_type":"image","service_version":"v1","title":"Star Forming Region S106","url":"https://apod.nasa.gov/apod/image/0102/s106_subaru.jpg"},{"date":"1995-08-20","explanation":"August 20, 1995    Announcing Comet Hale-Bopp  Credit: Erich Meyer and Herbert Raab, Austria  Explanation:  The pictured fuzzy patch  may become one of the most spectacular comets this century. Although it is very hard to predict how bright a comet will become, Comet Hale-Bopp, named for its discoverers, was spotted farther from the Sun than any previous comet - a good sign that it could become very bright, easily visible to the naked eye. This picture was taken on July 25th 1995, only two days after its discovery. A comet bright enough to see without a telescope occurs only about once a decade. The large coma and long tail of bright comets are so unusual and impressive that they have been considered omens of change by many cultures. A comet does not streak by in few seconds - but it may change its position and structure noticeably from night to night.","hdurl":"https://apod.nasa.gov/apod/image/comet_hb1.gif","media_type":"image","service_version":"v1","title":"Announcing Comet Hale-Bopp","url":"https://apod.nasa.gov/apod/image/comet_hb1.gif"},{"date":"2018-08-05","explanation":"Near the center of this sharp cosmic portrait, at the heart of the Orion Nebula, are four hot, massive stars known as the Trapezium. Gathered within a region about 1.5 light-years in radius, they dominate the core of the dense Orion Nebula Star Cluster. Ultraviolet ionizing radiation from the Trapezium stars, mostly from the brightest star Theta-1 Orionis C powers the complex star forming region's entire visible glow. About three million years old, the Orion Nebula Cluster was even more compact in its younger years and a recent dynamical study indicates that runaway stellar collisions at an earlier age may have formed a black hole with more than 100 times the mass of the Sun. The presence of a black hole within the cluster could explain the observed high velocities of the Trapezium stars. The Orion Nebula's distance of some 1,500 light-years would make it the closest known black hole to planet Earth.   APOD Event: APOD Editor to speak at Fermilab on August 8","hdurl":"https://apod.nasa.gov/apod/image/1808/OrionTrapezium_HubbleGendler_4000.jpg","media_type":"image","service_version":"v1","title":"Trapezium: At the Heart of Orion","url":"https://apod.nasa.gov/apod/image/1808/OrionTrapezium_HubbleGendler_960.jpg"},{"date":"1995-09-06","explanation":"Callisto is a dirty battered world, showing the most beaten surface of Jupiter's major moons. Made of a rocky core covered by fractured ice, Callisto's past collisions with large meteors are evident as large craters surrounded by concentric rings. The four largest moons of Jupiter: Io, Europa, Ganymede, and Callisto were all discovered by Galileo and Marius in 1610 with early telescopes and are now known as the Galilean satellites. The NASA spacecraft Galileo is scheduled to arrive at Jupiter is December of 1995.","hdurl":"https://apod.nasa.gov/apod/image/callisto_vg.gif","media_type":"image","service_version":"v1","title":"Callisto: Dark Smashed Iceball","url":"https://apod.nasa.gov/apod/image/callisto_vg.gif"},{"date":"2000-12-23","explanation":"The December solstice brings the beginning of Winter to Earth's Northern Hemisphere and Summer time to the South! This view of Earth's Southern Hemisphere near the beginning of Summer was created using images from the Galileo spacecraft taken during its  December 1990 flyby of our fair planet. Dramatically centered on the South Pole, this mosaic was constructed by piecing together images made over a 24 hour period so that the entire hemisphere appears to be in sunlight. South America (middle left), Africa (upper right), and Australia (lower right), are visible as dark masses while Antarctica gleams brightly in the center. Swirling clouds marking regularly spaced major weather systems are also prominent.","hdurl":"https://apod.nasa.gov/apod/image/0012/earthsp_gal_big.jpg","media_type":"image","service_version":"v1","title":"Summer at the South Pole","url":"https://apod.nasa.gov/apod/image/0012/earthsp_gal.jpg"},{"date":"2000-08-03","explanation":"Last month the NEAR Shoemaker spacecraft swooped closer to Eros, orbiting only 22 miles (36 kilometers) from the center of the asteroid. These two images taken on July 19 (left) and July 24 (right) reveal the diminutive world's pocked and mottled surface in amazing detail, showing features as small as 19 feet (6 meters) across. Eros is thought to be a primordial, undifferentiated asteroid based on X-ray and gamma-ray studies of its surface composition. In the left picture, its surface layer or regolith is seen to be laced with bright and dark regions while in the right hand image dark regolith appears to have filled in some crater floors. The left and right images span an area about 2,600 feet (800 meters) and 3,000 ft (900 meters) wide respectively. On July 31, NEAR Shoemaker returned to its familiar 31 mile (50 kilometer) orbit, circling Eros serenely at about 6 miles per hour.","hdurl":"https://apod.nasa.gov/apod/image/0008/eros22_000719_near.jpg","media_type":"image","service_version":"v1","title":"22 Miles From Eros","url":"https://apod.nasa.gov/apod/image/0008/eros22_000719_near.jpg"},{"date":"1998-05-08","explanation":"Did a gamma-ray burst precede this supernova? This intriguing suggestion came to light yesterday with the discovery of an evolving supernova that is potentially coincident with the position of gamma-ray burst GRB 980425, which occurred just two weeks ago.  If true, this would tie together the two most violent phenomena known in the universe. The supernova, indicated by the arrow, appears to be somewhat unusual, for one reason because of its extremely bright radio emission. The host galaxy has a redshift of 0.0085, placing it at the relatively close distance of about 125 million light years away.  Today it remains undetermined whether the two events are related - perhaps the evolution of the supernova over the next few weeks will provide some clues.","hdurl":"https://apod.nasa.gov/apod/image/9805/snorgrb_ntt_big.jpg","media_type":"image","service_version":"v1","title":"A Gamma-Ray Burst Supernova?","url":"https://apod.nasa.gov/apod/image/9805/snorgrb_ntt.jpg"},{"date":"2009-05-17","explanation":"Whatever hit Mimas nearly destroyed it.  What remains is one of the largest impact craters on one of Saturn's smallest moons.  The crater, named Herschel after the 1789 discoverer of Mimas, Sir William Herschel, spans about 130 kilometers and is pictured above. Mimas' low mass produces a surface gravity just strong enough to create a spherical body but weak enough to allow such relatively large surface features. Mimas is made of mostly water ice with a smattering of rock - so it is accurately described as a big dirty snowball. The above image was taken during the 2005 August flyby of the robot spacecraft Cassini now in orbit around Saturn.   digg_url = 'http://apod.nasa.gov/apod/ap090517.html'; digg_skin = 'compact';","hdurl":"https://apod.nasa.gov/apod/image/0905/mimas_cassini_big.jpg","media_type":"image","service_version":"v1","title":"Mimas: Small Moon with a Big Crater","url":"https://apod.nasa.gov/apod/image/0905/mimas_cassini.jpg"}]
"""

var decoder = JSONDecoder();

let testData = try! decoder.decode(ApodResult.self, from: testApodStr.data(using: .utf8)!)

let testArray = try! decoder.decode(Array<ApodResult>.self, from: testApodArray.data(using: .utf8)!)

var testUserData = UserData()
#endif
