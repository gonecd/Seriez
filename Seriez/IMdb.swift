//
//  IMdb.swift
//  Seriez
//
//  Created by Cyril Delamare on 04/06/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation


class IMdb : NSObject
{
    //let ftpServer : String = "ftp://ftp.fu-berlin.de/pub/misc/movies/database/temporaryaccess/"
    let ftpServer : String = "ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/temporaryaccess/"
    let ratingsSource : String = "ratings.list.gz"
    var ratingsFile : String = ""
    
    override init()
    {
        super.init()
        ratingsFile = "/Users/Cd/Library/Application Support/Seriez/ratings.list"
    }
    
    func loadRatings(_ path : String)
    {
        let ratings : Data = try! Data.init(contentsOf: URL(string: ftpServer+ratingsSource)!)
        try? ratings.write(to: URL(fileURLWithPath: "/tmp/"+ratingsSource), options: [.atomic])
        
        let task = Process()
        
        print("Download successfull")

        // Unzipping the file in tmp
        // system("gunzip '/tmp/"+ratingsSource+"'")
        task.launchPath = "/usr/bin/gunzip"
        task.arguments = ["/tmp/"+ratingsSource]
        task.launch()
        task.waitUntilExit()
        sleep(15)
        print("Unzip successfull")
        
        let task2 = Process()
        // Filtering and copying to destination folder
        // system("grep '(#' '/tmp/ratings.list' > '"+path+"/"+"ratings.list'")
        task2.launchPath = "/usr/bin/grep"
        task2.arguments = ["'(#'", "'/tmp/ratings.list'", ">", path+"/ratings.list"]
        task2.launch()
        task2.waitUntilExit()

        print("Filtrage successfull")

        ratingsFile = path+"/"+"ratings.list"
    }
    
    
    func getSerieInfos(_ uneSerie: Serie)
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy"
        let annee : String = dateFormatter.string(from: uneSerie.saisons[0].episodes[0].date as Date)
        uneSerie.year = Int(annee)!
        
        let (imdbExtract, error, status) = runCommand("/usr/bin/grep", args: "-i", "\"\(uneSerie.serie)\".(\(uneSerie.year)).*", "\(ratingsFile)")

        // Récupération des ratings
        if (imdbExtract.count > 0)
        {
          uneSerie.imdbUpdate = Date()
          for saison in uneSerie.saisons
            {
                for episode in saison.episodes
                {
                    for oneLine in imdbExtract {
                        if (oneLine.contains("#\(episode.saison).\(episode.episode)"))
                        {
                            let nsString = oneLine as NSString
                            let regex = try! NSRegularExpression(pattern: "[\\s]*[0-9\\.]*[\\s]*([0-9]*)[\\s]*([0-9].[0-9]).*[0-9][0-9][0-9][0-9]. \\{.*\\}", options: NSRegularExpression.Options.caseInsensitive)
                            let results = regex.matches(in: oneLine, options: [], range: NSMakeRange(0, nsString.length))
                            
                            if (results.count == 1)
                            {
                                episode.ratingIMdb = Double(nsString.substring(with: results[0].range(at: 2)))!
                                episode.ratersIMdb = Int(nsString.substring(with: results[0].range(at: 1)))!
                            }
                        }
                    }
                }
            }
        }
        else
        {
            print("IMdb::getSerieInfos failed for \(uneSerie.serie) : status(\(status)), error(\(error))")
        }
        
    }
    

    func runCommand(_ cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        
        var output : [String] = []
        var error : [String] = []
        
        let task = Process()
        task.launchPath = cmd
        task.arguments = args
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: String.Encoding.utf8) {
            string = string.trimmingCharacters(in: CharacterSet.newlines)
            output = string.components(separatedBy: "\n")
        }
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: String.Encoding.utf8) {
            string = string.trimmingCharacters(in: CharacterSet.newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
}

