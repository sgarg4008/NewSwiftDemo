//
//  SongsListModel.swift
//  SwiftDemo
//
//  Created by Shivam on 26/01/21.
//

import Foundation
struct SongsListModel {
    
    var artistName:String = ""
    var collectionName:String = ""
    var artworkUrl100:String = ""
    var trackName:String = ""
    var country:String = ""
    var collectionPrice:Double = 0.0
    
    //Initialization
    init(dic: [String:Any]){
            if let artistName = dic["artistName"] as? String{
                self.artistName = artistName
            }
            if let collectionName = dic["collectionName"] as? String{
                self.collectionName = collectionName
            }
            if let artworkUrl100 = dic["artworkUrl100"] as? String{
                self.artworkUrl100 = artworkUrl100
            }
            if let trackName = dic["trackName"] as? String{
                self.trackName = trackName
            }
            if let country = dic["country"] as? String{
                self.country = country
            }
            if let collectionPrice = dic["collectionPrice"] as? Double{
                self.collectionPrice = collectionPrice
            }
    }
    
}
