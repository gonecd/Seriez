//
//  Episode.swift
//  Seriez
//
//  Created by Cyril Delamare on 02/09/2015.
//  Copyright (c) 2015 Home. All rights reserved.
//

import Foundation


class Episode : NSObject, NSCoding
{
    var serie : String
    var fichier : String
    var path : String = "/Users"
    var saison : Int = 0
    var episode : Int = 0
    var titre : String = String()
    var qualite : String = String()
    var source : String = String()
    var codec : String = String()
    var team : String = String()
    var video : String = String()
    var distrib : String = String()
    
    var loaded : Bool = false
    var collected : Bool = false
    var watched : Bool = false
    
    // Source TheTVdb
    var ratingTVdb : Double = 0.0
    var ratersTVdb : Int = 0
    var image : String = String()
    var resume : String = String()
    var date : Date = Date.init(timeIntervalSince1970: 0)
    var idTVdb : Int = 0
    
    // Source Trakt
    var ratingTrakt : Double = 0.0
    var ratersTrakt : Int = 0

    // Source BetaSeries
    var ratingBetaSeries : Double = 0.0
    var ratersBetaSeries : Int = 0
    
    // Source IMdb
    var ratingIMdb : Double = 0.0
    var ratersIMdb : Int = 0
    
    required init(serie:String, fichier:String, saison:Int, episode:Int)
    {
        self.serie = serie
        self.fichier = fichier
        self.saison = saison
        self.episode = episode
    }
    
    required init(coder decoder: NSCoder) {
        self.serie = decoder.decodeObject(forKey: "serie") as? String ?? ""
        self.fichier = decoder.decodeObject(forKey: "fichier") as? String ?? ""
        self.saison = decoder.decodeInteger(forKey: "saison")
        self.episode = decoder.decodeInteger(forKey: "episode")
        self.titre = decoder.decodeObject(forKey: "titre") as? String ?? ""
        self.qualite = decoder.decodeObject(forKey: "qualite") as? String ?? ""
        self.source = decoder.decodeObject(forKey: "source") as? String ?? ""
        self.codec = decoder.decodeObject(forKey: "codec") as? String ?? ""
        self.team = decoder.decodeObject(forKey: "team") as? String ?? ""
        self.video = decoder.decodeObject(forKey: "video") as? String ?? ""
        self.distrib = decoder.decodeObject(forKey: "distrib") as? String ?? ""
        self.ratingTVdb = decoder.decodeDouble(forKey: "ratingTVdb")
        self.image = decoder.decodeObject(forKey: "image") as? String ?? ""
        self.resume = decoder.decodeObject(forKey: "resume") as? String ?? ""
        self.date = (decoder.decodeObject(forKey: "date") ?? 0) as! Date
        self.idTVdb = decoder.decodeInteger(forKey: "idTVdb")
        self.loaded = decoder.decodeBool(forKey: "loaded")
        self.collected = decoder.decodeBool(forKey: "collected")
        self.watched = decoder.decodeBool(forKey: "watched")
        self.ratersTVdb = decoder.decodeInteger(forKey: "ratersTVdb")
        self.ratingTrakt = decoder.decodeDouble(forKey: "ratingTrakt")
        self.ratersTrakt = decoder.decodeInteger(forKey: "ratersTrakt")
        self.ratingBetaSeries = decoder.decodeDouble(forKey: "ratingBetaSeries")
        self.ratersBetaSeries = decoder.decodeInteger(forKey: "ratersBetaSeries")
        self.ratingIMdb = decoder.decodeDouble(forKey: "ratingIMdb")
        self.ratersIMdb = decoder.decodeInteger(forKey: "ratersIMdb")
        self.path = decoder.decodeObject(forKey: "path") as? String ?? "/Users"
   }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.serie, forKey: "serie")
        coder.encode(self.fichier, forKey: "fichier")
        coder.encodeCInt(Int32(self.saison), forKey: "saison")
        coder.encodeCInt(Int32(self.episode), forKey: "episode")
        coder.encode(self.titre, forKey: "titre")
        coder.encode(self.qualite, forKey: "qualite")
        coder.encode(self.source, forKey: "source")
        coder.encode(self.codec, forKey: "codec")
        coder.encode(self.team, forKey: "team")
        coder.encode(self.video, forKey: "video")
        coder.encode(self.distrib, forKey: "distrib")
        coder.encode(self.ratingTVdb, forKey: "ratingTVdb")
        coder.encode(self.image, forKey: "image")
        coder.encode(self.resume, forKey: "resume")
        coder.encode(self.date, forKey: "date")
        coder.encodeCInt(Int32(self.idTVdb), forKey: "idTVdb")
        coder.encode(self.loaded, forKey: "loaded")
        coder.encode(self.collected, forKey: "collected")
        coder.encode(self.watched, forKey: "watched")
        coder.encodeCInt(Int32(self.ratersTVdb), forKey: "ratersTVdb")
        coder.encode(self.ratingTrakt, forKey: "ratingTrakt")
        coder.encodeCInt(Int32(self.ratersTrakt), forKey: "ratersTrakt")
        coder.encode(self.ratingBetaSeries, forKey: "ratingBetaSeries")
        coder.encodeCInt(Int32(self.ratersBetaSeries), forKey: "ratersBetaSeries")
        coder.encode(self.ratingIMdb, forKey: "ratingIMdb")
        coder.encodeCInt(Int32(self.ratersIMdb), forKey: "ratersIMdb")
        coder.encode(self.path, forKey: "path")
   }

    init(fichier:String)
    {
        self.serie = "Error"
        self.fichier = fichier
        self.saison = 0
        self.loaded = true
        
        let regex = try! NSRegularExpression(pattern: "(.*).s([0-9]{1,2})e([0-9]{1,2})(.*?)(?:.(480p|720p|1080p))*(?:.(hdtv|webrip))*(?:.(x264|xvid))*-(.*).(avi|mkv|mp4|m4v)", options: NSRegularExpression.Options.caseInsensitive)
        let nsString = fichier as NSString
        let results = regex.matches(in: fichier, options: [], range: NSMakeRange(0, nsString.length))
        
        if (results.count > 0)
        {
            for i:Int in 0 ..< results.count
            {
                self.serie = (nsString.substring(with: results[i].range(at: 1)) as NSString).replacingOccurrences(of: ".", with: " ")
                self.saison = (nsString.substring(with: results[i].range(at: 2)) as NSString).integerValue
                self.episode = (nsString.substring(with: results[i].range(at: 3)) as NSString).integerValue
                
                //if ( results[i].rangeAtIndex(4).length != 0) { self.titre = nsString.substringWithRange(results[i].rangeAtIndex(4)) }
                //if ( results[i].rangeAtIndex(4).length != 0) { self.titre = (nsString.substringWithRange(results[i].rangeAtIndex(4)) as NSString).stringByReplacingOccurrencesOfString(".", withString: " ") }              // TODO : Virer le point initial
                if ( results[i].range(at: 5).length != 0) { self.qualite = nsString.substring(with: results[i].range(at: 5)) }
                if ( results[i].range(at: 6).length != 0) { self.source = nsString.substring(with: results[i].range(at: 6)) }
                if ( results[i].range(at: 7).length != 0) { self.codec = nsString.substring(with: results[i].range(at: 7)) }
                if ( results[i].range(at: 8).length != 0) { self.team = nsString.substring(with: results[i].range(at: 8)) }                                                                                        // TODO : Gérer le distributeur
                if ( results[i].range(at: 9).length != 0) { self.video = nsString.substring(with: results[i].range(at: 9)) }
            }
        }
    }
    
    
    func merge(_ unEpisode : Episode)
    {
        if (unEpisode.serie != "")         { self.serie = unEpisode.serie }
        if (unEpisode.fichier != "")       { self.fichier = unEpisode.fichier }
        if (unEpisode.path != "")          { self.path = unEpisode.path }
        if (unEpisode.saison != 0)         { self.saison = unEpisode.saison }
        if (unEpisode.episode != 0)        { self.episode = unEpisode.episode }
        if (unEpisode.titre != "")         { self.titre = unEpisode.titre }
        if (unEpisode.qualite != "")       { self.qualite = unEpisode.qualite }
        if (unEpisode.source != "")        { self.source = unEpisode.source }
        if (unEpisode.codec != "")         { self.codec = unEpisode.codec }
        if (unEpisode.team != "")          { self.team = unEpisode.team }
        if (unEpisode.video != "")         { self.video = unEpisode.video }
        if (unEpisode.distrib != "")       { self.distrib = unEpisode.distrib }
        if (unEpisode.image != "")         { self.image = unEpisode.image }
        if (unEpisode.resume != "")        { self.resume = unEpisode.resume }
        if (unEpisode.loaded != false)     { self.loaded = unEpisode.loaded }
        if (unEpisode.collected != false)  { self.collected = unEpisode.collected }
        if (unEpisode.watched != false)    { self.watched = unEpisode.watched }
        if (unEpisode.ratingTVdb != 0.0)   { self.ratingTVdb = unEpisode.ratingTVdb }
        if (unEpisode.ratersTVdb != 0)     { self.ratersTVdb = unEpisode.ratersTVdb }
        if (unEpisode.idTVdb != 0)         { self.idTVdb = unEpisode.idTVdb }
        if (unEpisode.date != Date.init(timeIntervalSince1970: 0))       { self.date = unEpisode.date }
        if (unEpisode.ratingTrakt != 0.0)      { self.ratingTrakt = unEpisode.ratingTrakt }
        if (unEpisode.ratersTrakt != 0)        { self.ratersTrakt = unEpisode.ratersTrakt }
        if (unEpisode.ratingBetaSeries != 0.0) { self.ratingBetaSeries = unEpisode.ratingBetaSeries }
        if (unEpisode.ratersBetaSeries != 0)   { self.ratersBetaSeries = unEpisode.ratersBetaSeries }
        if (unEpisode.ratingIMdb != 0.0)       { self.ratingIMdb = unEpisode.ratingIMdb }
        if (unEpisode.ratersIMdb != 0)         { self.ratersIMdb = unEpisode.ratersIMdb }
    }
}
