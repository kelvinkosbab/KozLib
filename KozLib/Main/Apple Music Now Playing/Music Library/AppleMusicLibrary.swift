//
//  AppleMusicLibrary.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/24/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import Foundation

struct AppleMusicLibrary {
  
  let songs: [AppleMusicSong] = [
    AppleMusicSong(title: "Song 1", duration: 120, artist: "Artist 1", coverArtURL: URL(string: "https://viloria0210.files.wordpress.com/2013/06/art-curioos-digital-art-graphic-design-illustration-favim-com-201027.jpg")),
    AppleMusicSong(title: "Song 2", duration: 120, artist: "Artist 1", coverArtURL: URL(string: "https://static1.squarespace.com/static/53d1f946e4b02f566edf1888/5ae247cd6d2a73a0945a3244/5ae24867575d1f8378b3cac4/1524779117220/RadioVelevet-StarWars3.jpg")),
    AppleMusicSong(title: "Song 3", duration: 120, artist: "Artist 1", coverArtURL: URL(string: "https://www.visuartists.com/images/pics/1920/625_jDsZqz_sd-700.jpg")),
    AppleMusicSong(title: "Song 4", duration: 120, artist: "Artist 1", coverArtURL: URL(string: "https://dspncdn.com/a1/media/originals/76/4a/18/764a188ba435efb48502d3cc62d74ebb.jpg"))
  ]
}
