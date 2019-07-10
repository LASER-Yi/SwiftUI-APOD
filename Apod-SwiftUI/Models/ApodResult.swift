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

let testApodArray = """
[{"date":"2008-06-24","explanation":"What created the Great Rift on Saturn's moon Tethys? No one is sure.  More formally named Ithaca Chasma, the long canyon running across the right of the above image extends about 2,000 kilometers long and spreads as much as 100 kilometers wide. The above image was captured by the Saturn-orbiting robotic Cassini spacecraft as it zoomed by the icy moon last month.  Hypotheses for the formation of Ithaca Chasma include cracking of Tethy's outer crust as the moon cooled long ago, and that somehow the rift is related to the huge Great Basin impact crater named Odysseus, visible elsewhere on the unusual moon.  Cassini has now been orbiting Saturn for about four years and is scheduled to continue to probe and photograph Saturn for at least two more years.   digg_url = 'http://apod.nasa.gov/apod/ap080624.html'; digg_skin = 'compact';","hdurl":"https://apod.nasa.gov/apod/image/0806/tethys3_cassini_big.jpg","media_type":"image","service_version":"v1","title":"Ithaca Chasma: The Great Rift on Saturn's Tethys","url":"https://apod.nasa.gov/apod/image/0806/tethys3_cassini.jpg"},{"copyright":"Philippe Haake","date":"2005-10-14","explanation":"Of course, everyone is concerned about what to wear to a solar eclipse. No need to worry though, nature often conspires to project images of the eclipse so that stylish and appropriate patterns adorn many visible surfaces - including clothing - at just the right time. Most commonly, small gaps between leaves on trees can act as pinhole cameras and generate multiple recognizable images of the eclipse. But while in Madrid to view the October 3rd annular eclipse of the Sun, astronomer Philippe Haake met a friend who had another inspiration. The result, a grid of small holes in a kitchen strainer produced this pattern of images on an 'eclipse shirt'.","hdurl":"https://apod.nasa.gov/apod/image/0510/eclipseshirt_haake_f.jpg","media_type":"image","service_version":"v1","title":"Eclipse Shirt","url":"https://apod.nasa.gov/apod/image/0510/eclipseshirt_haake_f67.jpg"},{"date":"2004-12-19","explanation":"Where did all the stars go?  What used to be considered a hole in the sky is now known to astronomers as a dark molecular cloud.  Here, a high concentration of dust and molecular gas absorb practically all the visible light emitted from background stars.  The eerily dark surroundings help make the interiors of molecular clouds some of the coldest and most isolated places in the universe.  One of the most notable of these dark absorption nebulae is a cloud toward the constellation Ophiuchus known as Barnard 68, pictured above.  That no stars are visible in the center indicates that Barnard 68 is relatively nearby, with measurements placing it about 500 light-years away and half a light-year across.  It is not known exactly how molecular clouds like Barnard 68 form, but it is known that these clouds are themselves likely places for new stars to form. It is possible to look right through the cloud in infrared light.","hdurl":"https://apod.nasa.gov/apod/image/0109/barnard68_vlt_big.jpg","media_type":"image","service_version":"v1","title":"Molecular Cloud Barnard 68","url":"https://apod.nasa.gov/apod/image/0109/barnard68_vlt.jpg"},{"date":"2013-03-15","explanation":"After appearing in a popular photo opportunity with a young crescent Moon near sunset, naked-eye Comet PanSTARRS continues to rise in northern hemisphere skies. But this remarkable interplanetary perspective from March 13, finds the comet posing with our fair planet itself - as seen from the STEREO Behind spacecraft. Following in Earth's orbit, the spacecraft is nearly opposite the Sun and looks back toward the comet and Earth, with the Sun just off the left side of the frame. At the left an enormous coronal mass ejection (CME) is erupting from a solar active region. Of course, CME, comet, and planet Earth are all at different distances from the spacecraft. (The comet is closest.) The processed digital image is the difference between two consecutive frames from the spacecraft's SECCHI Heliospheric Imager, causing the strong shadowing effect for objects that move between frames. Objects that are too bright create the sharp vertical lines. The processing reveals complicated feather-like structures in Comet PanSTARRS's extensive dust tail.   Growing Gallery:  Comet PanSTARRS at Sunset","hdurl":"https://apod.nasa.gov/apod/image/1303/panstarrs_mar13_cmeV0.jpg","media_type":"image","service_version":"v1","title":"CME, Comet and Planet Earth","url":"https://apod.nasa.gov/apod/image/1303/panstarrs_mar13_cmeV0.jpg"},{"date":"2015-12-20","explanation":"There is something very unusual in this picture of the Earth -- can you find it? A fleeting phenomenon once thought to be only a legend has been newly caught if you know just where to look. The featured image was taken from the orbiting International Space Station (ISS) in late April and shows familiar ISS solar panels on the far left and part of a robotic arm to the far right. The rarely imaged phenomenon is known as a red sprite and it can be seen, albeit faintly, just over the bright area on the image right. This bright area and the red sprite are different types of lightning, with the white flash the more typical type. Although sprites have been reported anecdotally for as long as 300 years, they were first caught on film in 1989 -- by accident. Much remains unknown about sprites including how they occur, their effect on the atmospheric global electric circuit, and if they are somehow related to other upper atmospheric lightning phenomena such as blue jets or terrestrial gamma flashes.   Free APOD Lectures: Editor to Speak in January in Philadelphia and New York City","hdurl":"https://apod.nasa.gov/apod/image/1512/spritenight_iss_4256.jpg","media_type":"image","service_version":"v1","title":"A Dark Earth with a Red Sprite","url":"https://apod.nasa.gov/apod/image/1512/spritenight_iss_960.jpg"},{"copyright":"Dave Lane Rollover Annotation: Judy Schmidt","date":"2016-01-27","explanation":"Why would the sky look like a giant fan? Airglow. The featured intermittent green glow appeared to rise from a lake through the arch of our Milky Way Galaxy, as captured last summer next to Bryce Canyon in Utah, USA.  The unusual pattern was created by atmospheric gravity waves, ripples of alternating air pressure that can grow with height as the air thins, in this case about 90 kilometers up.  Unlike auroras powered by collisions with energetic charged particles and seen at high latitudes, airglow is due to chemiluminescence, the production of light in a chemical reaction.  More typically seen near the horizon, airglow keeps the night sky from ever being completely dark.   Follow APOD on: Facebook,  Google Plus, or Twitter","hdurl":"https://apod.nasa.gov/apod/image/1601/AirglowFan_Lane_2400.jpg","media_type":"image","service_version":"v1","title":"An Airglow Fan from Lake to Sky","url":"https://apod.nasa.gov/apod/image/1601/AirglowFan_Lane_960.jpg"},{"copyright":"Nigel Sharp","date":"2006-04-23","explanation":"It is still not known why the Sun's light is missing some colors.  Shown above are all the visible colors of the  Sun, produced by passing the Sun's light through a prism-like device.  The above spectrum was created at the McMath-Pierce Solar Observatory and shows, first off, that although our yellow-appearing Sun emits light of nearly every color, it does indeed appear brightest in yellow-green light.  The dark patches in the above spectrum arise from gas at or above the Sun's surface absorbing sunlight emitted below.  Since different types of gas absorb different colors of light, it is possible to determine what gasses compose the Sun.  Helium, for example, was first discovered in 1870 on a solar spectrum and only later found here on Earth.  Today, the majority of spectral absorption lines have been identified - but not all.","hdurl":"https://apod.nasa.gov/apod/image/0604/solarspectrum_noao.jpg","media_type":"image","service_version":"v1","title":"The Solar Spectrum","url":"https://apod.nasa.gov/apod/image/0604/solarspectrum_noao_big.jpg"},{"copyright":"Christoph Kaltseis","date":"2019-02-22","explanation":"Magnificent spiral galaxy NGC 4565 is viewed edge-on from planet Earth. Also known as the Needle Galaxy for its narrow profile, bright NGC 4565 is a stop on many telescopic tours of the northern sky, in the faint but well-groomed constellation Coma Berenices. This sharp, colorful image reveals the galaxy's boxy, bulging central core cut by obscuring dust lanes that lace NGC 4565's thin galactic plane. An assortment of other background galaxies is included in the pretty field of view, with neighboring galaxy NGC 4562 at the upper right. NGC 4565 itself lies about 40 million light-years distant and spans some 100,000 light-years.  Easily spotted with small telescopes, sky enthusiasts consider NGC 4565 to be a prominent celestial masterpiece Messier missed.","hdurl":"https://apod.nasa.gov/apod/image/1902/N4565ps06d_35tp_Kaltseis2019.jpg","media_type":"image","service_version":"v1","title":"NGC 4565: Galaxy on Edge","url":"https://apod.nasa.gov/apod/image/1902/N4565ps06d_35tp_Kaltseis2019_1024.jpg"},{"date":"2003-04-26","explanation":"This reconstructed digital portrait of our planet is reminiscent of the Apollo-era pictures of the \"big blue marble\" Earth from space. To create it, researchers at Goddard Space Flight Center's Laboratory for Atmospheres combined data from a Geostationary Operational Environmental Satellite (GOES), the Sea-viewing Wide Field-of-view Sensor (SeaWiFS), and the Polar Orbiting Environmental Satellites (POES) with a USGS elevation model of Earth's topography. Stunningly detailed, the planet's western hemisphere is cast so that heavy vegetation is green and sparse vegetation is yellow, while the heights of mountains and depths of valleys have been exaggerated by 50 times to make vertical relief visible.  Hurricane Linda is the dramatic storm off North America's west coast. And what about the Moon? The lunar image was reconstructed from GOES data and artistically rescaled for this visualization.","hdurl":"https://apod.nasa.gov/apod/image/0304/bluemarble2k_big.jpg","media_type":"image","service_version":"v1","title":"Big Blue Marble Earth","url":"https://apod.nasa.gov/apod/image/0304/bluemarble2k.jpg"},{"copyright":"VegaStar Carpentier","date":"2012-07-04","explanation":"What stands between you and the Sun? Apparently, as viewed from Paris last week, one visible thing after another. First, in the foreground, is the Basilica of the Sacred Heart, built in the late 1800s and located on the highest hill in Paris, France.  Next, well behind the basilica's towers in the above image, are thin clouds forward scattering sunlight. Finally, far in the distance and slightly buried into the Sun's surface, are sunspots, the most prominent of which is sunspot region AR 1512 visible near the disk center. Since the time that this sunset image was taken, the sunspot region on the far left, AR 1515, has unleashed a powerful solar flare. Although most particles from that flare are expected to miss the Earth, sky enthusiasts are on watch for Sun events that might cause bright auroras in an invisible thing that stands between you and the Sun: the Earth's atmosphere.   Slide Set (ASOW): Dark Energy by Prof. George Djorgovski","hdurl":"https://apod.nasa.gov/apod/image/1207/sunspotsilhouette_carpentier_1000.jpg","media_type":"image","service_version":"v1","title":"Sunspots and Silhouettes","url":"https://apod.nasa.gov/apod/image/1207/sunspotsilhouette_carpentier_960.jpg"}]
"""

var decoder = JSONDecoder();

let testData = try! decoder.decode(ApodResult.self, from: testApodStr.data(using: .utf8)!)

let testArray = try! decoder.decode(Array<ApodResult>.self, from: testApodArray.data(using: .utf8)!)
#endif
