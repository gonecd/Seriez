//
//  Serie.swift
//  Seriez
//
//  Created by Cyril Delamare on 02/01/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation



class Serie : NSObject, NSCoding
{
    // Source Trakt
    var serie : String
    var saisons : [Saison] = [Saison]()
    var idIMdb : String = String()
    var idTrakt : String = String()
    var idTVdb : String = String()
    var idTVRage : String = String()
    var traktUpdate : Date = Date.init(timeIntervalSince1970: 0)
    
    // Source TheTVdb
    var ratingTVdb : Double = 0.0
    var ratersTVdb : Int = 0
    var network : String = String()
    var banner : String = String()
    var status : String = String()
    var resume : String = String()
    var genres : [String] = []
    var tvdbUpdate : Date = Date.init(timeIntervalSince1970: 0)
 
    // computed infos
    var year : Int = 0
    var nbEpisodes : Int = 0
    var loaded : Bool = false
    var collected : Bool = false
    var watched : Bool = false
    var stopped : Bool = false
    var watchlist : Bool = false

    // Source BetaSeries
    var betaSeriesUpdate : Date = Date.init(timeIntervalSince1970: 0)
    
    // Source IMdb
    var imdbUpdate : Date = Date.init(timeIntervalSince1970: 0)
    
    init(serie:String)
    {
        self.serie = serie
    }
    

    required init(coder decoder: NSCoder) {
        self.serie = decoder.decodeObject(forKey: "serie") as? String ?? ""
        self.saisons = decoder.decodeObject(forKey: "saisons") as? [Saison] ?? []
        self.idIMdb = decoder.decodeObject(forKey: "idIMdb") as? String ?? ""
        self.idTrakt = decoder.decodeObject(forKey: "idTrakt") as? String ?? ""
        self.idTVdb = decoder.decodeObject(forKey: "idTVdb") as? String ?? ""
        self.idTVRage = decoder.decodeObject(forKey: "idTVRage") as? String ?? ""
        self.traktUpdate = (decoder.decodeObject(forKey: "traktUpdate") ?? Date.init(timeIntervalSince1970: 0)) as! Date
        
        self.ratingTVdb = decoder.decodeDouble(forKey: "ratingTVdb")
        self.network = decoder.decodeObject(forKey: "network") as? String ?? ""
        self.banner = decoder.decodeObject(forKey: "banner") as? String ?? ""
        self.status = decoder.decodeObject(forKey: "status") as? String ?? ""
        self.resume = decoder.decodeObject(forKey: "resume") as? String ?? ""
        self.genres = decoder.decodeObject(forKey: "genres") as? [String] ?? []
        self.tvdbUpdate = (decoder.decodeObject(forKey: "tvdbUpdate") ?? Date.init(timeIntervalSince1970: 0)) as! Date
        
        self.year = decoder.decodeInteger(forKey: "year")
        self.nbEpisodes = decoder.decodeInteger(forKey: "nbEpisodes")
        self.ratersTVdb = decoder.decodeInteger(forKey: "ratersTVdb")
        self.loaded = decoder.decodeBool(forKey: "loaded")
        self.collected = decoder.decodeBool(forKey: "collected")
        self.watched = decoder.decodeBool(forKey: "watched")
      
        self.betaSeriesUpdate = (decoder.decodeObject(forKey: "betaSeriesUpdate") ?? Date.init(timeIntervalSince1970: 0)) as! Date
        self.imdbUpdate = (decoder.decodeObject(forKey: "imdbUpdate") ?? Date.init(timeIntervalSince1970: 0)) as! Date
        self.stopped = decoder.decodeBool(forKey: "stopped")
        self.watchlist = decoder.decodeBool(forKey: "watchlist")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.serie, forKey: "serie")
        coder.encode(self.saisons, forKey: "saisons")
        coder.encode(self.idIMdb, forKey: "idIMdb")
        coder.encode(self.idTrakt, forKey: "idTrakt")
        coder.encode(self.idTVdb, forKey: "idTVdb")
        coder.encode(self.idTVRage, forKey: "idTVRage")
        coder.encode(self.traktUpdate, forKey: "traktUpdate")

        coder.encode(self.ratingTVdb, forKey: "ratingTVdb")
        coder.encode(self.network, forKey: "network")
        coder.encode(self.banner, forKey: "banner")
        coder.encode(self.status, forKey: "status")
        coder.encode(self.resume, forKey: "resume")
        coder.encode(self.genres, forKey: "genres")
        coder.encode(self.tvdbUpdate, forKey: "tvdbUpdate")
        
        coder.encodeCInt(Int32(self.year), forKey: "year")
        coder.encodeCInt(Int32(self.nbEpisodes), forKey: "nbEpisodes")
        coder.encodeCInt(Int32(self.ratersTVdb), forKey: "ratersTVdb")
        coder.encode(self.loaded, forKey: "loaded")
        coder.encode(self.collected, forKey: "collected")
        coder.encode(self.watched, forKey: "watched")
        
        coder.encode(self.betaSeriesUpdate, forKey: "betaSeriesUpdate")
        coder.encode(self.imdbUpdate, forKey: "imdbUpdate")
        coder.encode(self.stopped, forKey: "stopped")
        coder.encode(self.watchlist, forKey: "watchlist")
  }
    
    func computeSerieInfos() {
        
        self.nbEpisodes = 0
        self.loaded = true
        self.collected = true
        self.watched = true

        for saison in self.saisons{
            self.nbEpisodes = self.nbEpisodes + saison.episodes.count
            saison.computeSaisonInfos()
            if (saison.loaded == false) { self.loaded = false }
            if (saison.collected == false) { self.collected = false }
            if (saison.watched == false) { self.watched = false }
        }
    }
    
    func merge(_ uneSerie : Serie)
    {
        if (uneSerie.ratingTVdb != 0.0)     { self.ratingTVdb = uneSerie.ratingTVdb }
        if (uneSerie.ratersTVdb != 0)       { self.ratersTVdb = uneSerie.ratersTVdb }
        if (uneSerie.network != "")         { self.network = uneSerie.network }
        if (uneSerie.banner != "")          { self.banner = uneSerie.banner }
        if (uneSerie.status != "")          { self.status = uneSerie.status }
        if (uneSerie.resume != "")          { self.resume = uneSerie.resume }
        if (uneSerie.genres != [])          { self.genres = uneSerie.genres }
        if (uneSerie.idIMdb != "")          { self.idIMdb = uneSerie.idIMdb }
        if (uneSerie.idTrakt != "")         { self.idTrakt = uneSerie.idTrakt }
        if (uneSerie.idTVdb != "")          { self.idTVdb = uneSerie.idTVdb }
        if (uneSerie.idTVRage != "")        { self.idTVRage = uneSerie.idTVRage }
        if (uneSerie.tvdbUpdate != Date.init(timeIntervalSince1970: 0))       { self.tvdbUpdate = uneSerie.tvdbUpdate }
        if (uneSerie.traktUpdate != Date.init(timeIntervalSince1970: 0))      { self.traktUpdate = uneSerie.traktUpdate }
        if (uneSerie.betaSeriesUpdate != Date.init(timeIntervalSince1970: 0)) { self.betaSeriesUpdate = uneSerie.betaSeriesUpdate }
        if (uneSerie.imdbUpdate != Date.init(timeIntervalSince1970: 0))       { self.imdbUpdate = uneSerie.imdbUpdate }
        
        self.stopped = uneSerie.stopped
        self.watchlist = uneSerie.watchlist

        for uneSaison in uneSerie.saisons
        {
            if (uneSaison.saison <= self.saisons.count)
            {
                self.saisons[uneSaison.saison - 1].merge(uneSaison)
            }
            else
            {
                self.saisons.append(uneSaison)
            }
        }
        
        self.computeSerieInfos()
    }
    
}
