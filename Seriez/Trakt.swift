//
//  Trakt.swift
//  Seriez
//
//  Created by Cyril Delamare on 18/09/2016.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

class Trakt : NSObject
{
    var TokenPath : String = String()
    let TraktURL : String = "https://api.trakt.tv/oauth/token"
    let TraktClientID : String = "44e9b9a92278adc49099f599d6b2a5be19b63e4812dbb7b335b459f8d0eb195c"
    let TraktClientSecret : String = "b085eac8d1ada5758f4edaa36290c06e131d33f0ce5c8aeb1f81e802b3818bd2"
    var Token : String = ""
    var RefreshToken : String = ""
    var TokenCreation : Date!
    var TokenExpiration : Date!
    
    override init()
    {
        super.init()
    }
    
    func start(_ path: String) -> Bool
    {
        let fileManager:FileManager = FileManager.default
        
        TokenPath = path+"/Trakt.token"
        
        if fileManager.fileExists(atPath: TokenPath)
        {
            let inputJSON = InputStream(fileAtPath: TokenPath)
            inputJSON?.open()
            do {
                let jsonToken : NSDictionary = try JSONSerialization.jsonObject(with: inputJSON!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                self.Token = jsonToken.object(forKey: "access_token") as! String!
                self.RefreshToken = jsonToken.object(forKey: "refresh_token") as! String!
                let create: Double = jsonToken.object(forKey: "created_at") as! Double
                let expire: Double = jsonToken.object(forKey: "expires_in") as! Double
                self.TokenCreation = Date.init(timeIntervalSince1970: create)
                self.TokenExpiration = Date.init(timeIntervalSince1970: (create+expire))
                
                if self.TokenExpiration.compare(Date.init(timeIntervalSinceNow: 0)) == ComparisonResult.orderedAscending
                {
                    return false
                }
                else
                {
                    self.refreshToken(self.RefreshToken)
                    return true
                }

                
            } catch let error as NSError { print("Trakt::init failed: \(error.localizedDescription)") }
        }
        
        return false
    }
    
    
    func renegotiateToken(_ key: String) -> Bool
    {
        // Première connection pour récupérer un token valable ??? temps ( = 7776000 ??? ) et le dumper dans un fichier /tmp/TraktToken
        // Pour le regénérer, aller sur la page de l'appli Seriez dans Trakt (https://trakt.tv/oauth/applications/1836), cliquer sur Authorize et copier le code dans le HTTPBody
        
        var succes : Bool = false
        let url = URL(string: self.TraktURL)!
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\n  \"code\": \"\(key)\",\n  \"client_id\": \"\(self.TraktClientID)\",\n  \"client_secret\": \"\(self.TraktClientSecret)\",\n  \"redirect_uri\": \"urn:ietf:wg:oauth:2.0:oob\",\n  \"grant_type\": \"authorization_code\"\n}".data(using: String.Encoding.utf8);
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse  {
                
                if (response.statusCode != 200) { print("Trakt::renegotiateToken error \(response.statusCode) received "); return; }
                
                self.saveToken(data)
                do {
                    let jsonToken : NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.Token = jsonToken.object(forKey: "access_token") as! String!
                    self.RefreshToken = jsonToken.object(forKey: "refresh_token") as! String!
                    let create: Double = jsonToken.object(forKey: "created_at") as! Double
                    let expire: Double = jsonToken.object(forKey: "expires_in") as! Double
                    self.TokenCreation = Date.init(timeIntervalSince1970: create)
                    self.TokenExpiration = Date.init(timeIntervalSince1970: (create+expire))
                    succes = true
                } catch let error as NSError { print("Trakt::renegotiateToken failed: \(error.localizedDescription)") }

            } else {
                print("Trakt::getToken failed: \(error!.localizedDescription)")
            }
        }) 
        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
        
        if (succes) { return true }
        else { return false }
    }

    
    
    func saveToken(_ data: Data)
    {
        let jsonResults : Any
        do {
            jsonResults = try JSONSerialization.jsonObject(with: data, options: [])
            if let outputJSON = OutputStream(toFileAtPath: self.TokenPath, append: false)
            {
                var err: NSError?
                outputJSON.open()
                JSONSerialization.writeJSONObject(jsonResults, to: outputJSON, options: JSONSerialization.WritingOptions(), error: &err)
                outputJSON.close()
            }
        } catch let error as NSError {
            print("Trakt::saveToken failed: \(error.localizedDescription)")
        }
    }
    
    
    func refreshToken (_ refresher: String)
    {
        let url = URL(string: self.TraktURL)!
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\n  \"refresh_token\": \"\(refresher)\",\n  \"client_id\": \"\(self.TraktClientID)\",\n  \"client_secret\": \"\(self.TraktClientSecret)\",\n  \"redirect_uri\": \"urn:ietf:wg:oauth:2.0:oob\",\n  \"grant_type\": \"refresh_token\"\n}".data(using: String.Encoding.utf8);
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {

                if (response.statusCode != 200) { print("Trakt::getToken error \(response.statusCode) received "); return; }

                self.saveToken(data)
                do {
                    let jsonToken : NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.Token = jsonToken.object(forKey: "access_token") as! String!
                    self.RefreshToken = jsonToken.object(forKey: "refresh_token") as! String!
                    let create: Double = jsonToken.object(forKey: "created_at") as! Double
                    let expire: Double = jsonToken.object(forKey: "expires_in") as! Double
                    self.TokenCreation = Date.init(timeIntervalSince1970: create)
                    self.TokenExpiration = Date.init(timeIntervalSince1970: (create+expire))
                } catch let error as NSError { print("Trakt::refreshToken failed: \(error.localizedDescription)") }

            } else {
                print("Trakt::refreshToken failed: \(error!.localizedDescription)")
            }
        }) 
        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
    }
    
    

    func getWatched() -> [Serie]
    {
        let url = URL(string: "https://api.trakt.tv/sync/watched/shows")!
        var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(self.Token)", forHTTPHeaderField: "Authorization")
            request.addValue("2", forHTTPHeaderField: "trakt-api-version")
            request.addValue("\(self.TraktClientID)", forHTTPHeaderField: "trakt-api-key")
        
//        let session = URLSession.shared
        var returnSeries: [Serie] = [Serie]()
        var serie: Serie = Serie(serie: "")
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                do {
                    let jsonResponse : NSArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for fiche in jsonResponse {
                        
                        serie = Serie.init(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String)
                        serie.idIMdb = (((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "imdb") as! String
                        serie.idTVdb = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "tvdb") as! Int)
                        serie.idTrakt = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "trakt") as! Int)
                        //serie.idTVRage = String(fiche.objectForKey("show")!.objectForKey("ids")!.objectForKey("tvrage") as! Int)
                        
                        for fichesaisons in (fiche as AnyObject).object(forKey: "seasons") as! NSArray
                        {
                            let uneSaison : Saison = Saison(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String,
                                                            saison: (fichesaisons as AnyObject).object(forKey: "number") as! Int)
                            
                            for ficheepisodes in (fichesaisons as AnyObject).object(forKey: "episodes") as! NSArray
                            {
                                let unEpisode : Episode = Episode(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String,
                                                                  fichier: "",
                                                                  saison: (fichesaisons as AnyObject).object(forKey: "number") as! Int,
                                                                  episode: (ficheepisodes as AnyObject).object(forKey: "number") as! Int)
                                unEpisode.watched = true
                                uneSaison.episodes.append(unEpisode)
                            }
                            
                            serie.saisons.append(uneSaison)
                        }
                        
                        returnSeries.append(serie)
                    }
                } catch let error as NSError { print("Trakt::getWatched failed: \(error.localizedDescription)") }
            } else { print(error as Any) }
        }
        
        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
        return returnSeries
    }
    

    
    
    func getCollection() -> [Serie]
    {
        let url = URL(string: "https://api.trakt.tv/sync/collection/shows")!
        var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(self.Token)", forHTTPHeaderField: "Authorization")
            request.addValue("2", forHTTPHeaderField: "trakt-api-version")
            request.addValue("\(self.TraktClientID)", forHTTPHeaderField: "trakt-api-key")
        
        let session = URLSession.shared
        var returnSeries: [Serie] = [Serie]()
        var serie: Serie = Serie(serie: "")

        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    
                    if (response.statusCode != 200) { print("Trakt::getCollection error \(response.statusCode) received "); return; }

                    let jsonResponse : NSArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for fiche in jsonResponse {
                        
                        serie = Serie.init(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String)
                        serie.idIMdb = (((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "imdb") as! String
                        serie.idTVdb = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "tvdb") as! Int)
                        serie.idTrakt = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "trakt") as! Int)
                        //serie.idTVRage = String(fiche.objectForKey("show")!.objectForKey("ids")!.objectForKey("tvrage") as! Int)
                        
                        for fichesaisons in (fiche as AnyObject).object(forKey: "seasons") as! NSArray
                        {
                            let uneSaison : Saison = Saison(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String,
                                                            saison: (fichesaisons as AnyObject).object(forKey: "number") as! Int)
                            
                            for ficheepisodes in (fichesaisons as AnyObject).object(forKey: "episodes") as! NSArray
                            {
                                let unEpisode : Episode = Episode(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String,
                                                            fichier: "",
                                                            saison: (fichesaisons as AnyObject).object(forKey: "number") as! Int,
                                                            episode: (ficheepisodes as AnyObject).object(forKey: "number") as! Int)
                                unEpisode.collected = true
                                uneSaison.episodes.append(unEpisode)
                            }

                            serie.saisons.append(uneSaison)
                        }
                        
                        returnSeries.append(serie)
                    }
                } catch let error as NSError { print("Trakt::getCollection failed: \(error.localizedDescription)") }
            } else { print(error as Any) }
        })

        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
        return returnSeries
    }
    
    func getStopped() -> [Serie]
    {
        var request = URLRequest(url: URL(string: "https://api.trakt.tv/users/gonecd/lists/Abandon/items/shows")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.Token)", forHTTPHeaderField: "Authorization")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue("\(self.TraktClientID)", forHTTPHeaderField: "trakt-api-key")
        
        var returnSeries: [Serie] = [Serie]()
        var serie: Serie = Serie(serie: "")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    
                    if (response.statusCode != 200) { print("Trakt::getWatchlist error \(response.statusCode) received "); return; }
                    
                    let jsonResponse : NSArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for fiche in jsonResponse {
                        serie = Serie.init(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String)
                        serie.idIMdb = (((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "imdb") as! String
                        serie.idTVdb = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "tvdb") as! Int)
                        serie.idTrakt = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "trakt") as! Int)
                        
                        serie.stopped = true
                        
                        returnSeries.append(serie)
                    }
                } catch let error as NSError { print("Trakt::getWatchlist failed: \(error.localizedDescription)") }
            } else { print(error as Any) }
        })
        
        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
        return returnSeries
    }

    func getWatchlist() -> [Serie]
    {
        var request = URLRequest(url: URL(string: "https://api.trakt.tv/users/gonecd/watchlist/shows")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.Token)", forHTTPHeaderField: "Authorization")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue("\(self.TraktClientID)", forHTTPHeaderField: "trakt-api-key")
        
        var returnSeries: [Serie] = [Serie]()
        var serie: Serie = Serie(serie: "")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    
                    if (response.statusCode != 200) { print("Trakt::getWatchlist error \(response.statusCode) received "); return; }
                    
                    let jsonResponse : NSArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for fiche in jsonResponse {
                        serie = Serie.init(serie: ((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String)
                        serie.idIMdb = (((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "imdb") as! String
                        serie.idTVdb = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "tvdb") as! Int)
                        serie.idTrakt = String((((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "ids")! as AnyObject).object(forKey: "trakt") as! Int)
                        
                        serie.watchlist = true
                        
                        returnSeries.append(serie)
                    }
                } catch let error as NSError { print("Trakt::getWatchlist failed: \(error.localizedDescription)") }
            } else { print(error as Any) }
        })
        
        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
        return returnSeries
    }
    
    func getSerieInfos(_ uneSerie: Serie)
    {
        for uneSaison in uneSerie.saisons
        {
            var tableauDeTaches: [URLSessionTask] = []
            var globalStatus: URLSessionTask.State = URLSessionTask.State.running
       
            for unEpisode in uneSaison.episodes
            {
                var request = URLRequest(url: URL(string: "https://api.trakt.tv/shows/\(uneSerie.idTrakt)/seasons/\(uneSaison.saison)/episodes/\(unEpisode.episode)/ratings")!)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Bearer \(self.Token)", forHTTPHeaderField: "Authorization")
                    request.addValue("2", forHTTPHeaderField: "trakt-api-version")
                    request.addValue("\(self.TraktClientID)", forHTTPHeaderField: "trakt-api-key")
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                    if let data = data, let response = response as? HTTPURLResponse {
                        
                        if (response.statusCode != 200) { print("Trakt::getSerieInfos error \(response.statusCode) received for \(uneSerie.serie) s\(uneSaison.saison) e\(unEpisode.episode)"); return; }
                        
                        do {
                            let jsonResponse : NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            
                            var totRating : Int = 0
                            var totRaters : Int = 0
                            
                            for i:Int in 1..<11
                            {
                                totRating = totRating + ( ((jsonResponse.object(forKey: "distribution")! as AnyObject).object(forKey: String(i)) as? Int ?? 0) * i )
                                totRaters = totRaters + ((jsonResponse.object(forKey: "distribution")! as AnyObject).object(forKey: String(i)) as? Int ?? 0)
                            }
                            
                            unEpisode.ratersTrakt = totRaters
                            unEpisode.ratingTrakt = Double(totRating) / Double(totRaters)
                            
                        } catch let error as NSError { print("Trakt::getSerieInfos failed for \(uneSerie.serie) s\(uneSaison.saison) e\(unEpisode.episode): \(error.localizedDescription)") }
                    } else {
                        print(error as Any)
                    }
                })
                
                tableauDeTaches.append(task)
                
                task.resume()
            }
            
            while (globalStatus == URLSessionTask.State.running)
            {
                for uneTache in tableauDeTaches
                {
                    globalStatus = URLSessionTask.State.completed
                    
                    if (uneTache.state == URLSessionTask.State.running) {
                        globalStatus = URLSessionTask.State.running
                    }
                }
                usleep(1000)
            }
        }
        uneSerie.traktUpdate = Date()
    }
        
    
    func getSeasonPremieres()
    {
        let url = URL(string: "https://api.trakt.tv/calendars/my/shows/premieres/2016-09-01/31")!
        var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(self.Token)", forHTTPHeaderField: "Authorization")
            request.addValue("2", forHTTPHeaderField: "trakt-api-version")
            request.addValue("\(self.TraktClientID)", forHTTPHeaderField: "trakt-api-key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                do {
                    let jsonResponse : NSArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    for fiche in jsonResponse {
                        print("Titre : \(((fiche as AnyObject).object(forKey: "show")! as AnyObject).object(forKey: "title") as! String)")
                    }
                    
                } catch let error as NSError { print("Trakt::getSeasonPremieres failed: \(error.localizedDescription)") }
            } else {
                print(error as Any)
            }
        })
        
        task.resume()
        while (task.state != URLSessionTask.State.completed) { sleep(1) }
    }
}





