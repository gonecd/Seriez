//
//  Graphique2.swift
//  Seriez
//
//  Created by Cyril Delamare on 30/04/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Cocoa

class Graphique2: NSView {
    
    
    var selectTrakt: Int = 0
    var selectTVdb:  Int = 0
    var selectRottenTomatoes:  Int = 0
    var selectIMDB: Int = 0
    var selectAlloCine: Int = 0
    var selectBetaSeries: Int = 0
    var selectTVShowTimes: Int = 0
    
    var grapheType : Int = 0
    var theSerie : Serie = Serie(serie: "")
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        self.background()
        if (grapheType == 0) { self.traceGraphePoints() }
        if (grapheType == 1) { self.traceGrapheLignes() }
        if (grapheType == 2) { self.traceGrapheImages() }

    }

    
    func change()
    {
        if (grapheType == 0) { grapheType = 1 }
        else if (grapheType == 1) { grapheType = 2 }
        else if (grapheType == 2) { grapheType = 0 }
        
        self.display()
    }
    

    func sendSerie(_ uneSerie: Serie)
    {
        theSerie = uneSerie
    }
    
    
    func sendSelects(_ selTVDB : Int, selTrakt : Int, selBetaSeries : Int, selIMdb : Int)
    {
        selectTVdb = selTVDB
        selectTrakt = selTrakt
        selectBetaSeries = selBetaSeries
        selectIMDB = selIMdb
    }
    
    
    func background()
    {
        let origineX : CGFloat = 30.0
        let origineY :CGFloat = 30.0
        let hauteur : CGFloat = (self.frame.height - origineY - 10.0)
        let largeur : CGFloat = (self.frame.width - origineX - 10.0)
        let textAttributes = [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: NSColor.gray]
        let nbSaisons : Int = theSerie.saisons.count

       // Fond
        if (grapheType == 0) { NSColor.black.setFill() }
        if (grapheType == 1) { NSColor.gray.setFill() }
        if (grapheType == 2) { NSColor.white.setFill() }
        bounds.fill()
        
        // Lignes
        if (grapheType == 0) { NSColor.white.setStroke() }
        if (grapheType == 1) { NSColor.black.setStroke() }
        if (grapheType == 2) { NSColor.gray.setStroke() }
        
        // Cadre
        let path : NSBezierPath = NSBezierPath()
        path.appendRect(NSRect(x: origineX, y: origineY, width: largeur, height: hauteur))
        path.stroke()
        
        // Lignes achurées horizontales
        for i:Int in 1 ..< 4
        {
            let pathLine : NSBezierPath = NSBezierPath()
            pathLine.move(to: CGPoint(x: origineX, y: origineY + (hauteur * CGFloat(i)/4)))
            pathLine.line(to: CGPoint(x: origineX + largeur, y:  origineY + (hauteur * CGFloat(i)/4)))
            
            pathLine.setLineDash([10.0,10.0], count: 2, phase: 5.0)
            pathLine.stroke()
        }
        
        // Légende en Y
        for i:Int in 0 ..< 5
        {
            let episode : NSString = String(6+i) as NSString
            episode.draw(in: NSRect(x: 15, y:  origineY + (hauteur * CGFloat(i)/4), width: 20, height: 10), withAttributes: textAttributes)
        }
        
        // Coches verticales
        for i:Int in 0 ..< nbSaisons
        {
            let saison : NSString = String(i+1) as NSString
            saison.draw(in: NSRect(x: origineX - 5.0 + (largeur * (CGFloat(i)+0.5) / CGFloat(nbSaisons)), y: 12, width: 15, height: 12), withAttributes: textAttributes)
        }
        
        if (nbSaisons < 1) { return }
        
        // Lignes hachurées verticale
        for i:Int in 1 ..< nbSaisons
        {
            let pathLine : NSBezierPath = NSBezierPath()
            pathLine.move(to: CGPoint(x: origineX + (largeur * CGFloat(i) / CGFloat(nbSaisons)), y: origineY))
            pathLine.line(to: CGPoint(x: origineX + (largeur * CGFloat(i) / CGFloat(nbSaisons)), y: origineY + hauteur))
            
            pathLine.setLineDash([10.0,10.0], count: 2, phase: 5.0)
            pathLine.stroke()
        }
        

    }
    
    
    func traceGraphePoints()
    {
        
        let nbSaisons : Int = theSerie.saisons.count
        let origineX : CGFloat = 30.0
        let largeur : CGFloat = (self.frame.width - origineX - 10.0)
        
        for i:Int in 0 ..< nbSaisons
        {
            let offset : CGFloat = (largeur * (CGFloat(i)+0.5) / CGFloat(nbSaisons))
            
            if (selectTVdb == 1) { traceUnPoint(theSerie.saisons[i].ratingTVdb, uneCouleur: NSColor.green, offsetSaison: offset, offsetSource: 0) }
            if (selectTrakt == 1) { traceUnPoint(theSerie.saisons[i].ratingTrakt, uneCouleur: NSColor.red, offsetSaison: offset, offsetSource: 5) }
            if (selectBetaSeries == 1) { traceUnPoint(theSerie.saisons[i].ratingBetaSeries, uneCouleur: NSColor.blue, offsetSaison: offset, offsetSource: 10) }
            if (selectIMDB == 1) { traceUnPoint(theSerie.saisons[i].ratingIMdb, uneCouleur: NSColor.yellow, offsetSaison: offset, offsetSource: 15) }
        }
    }
    
    
    func traceUnPoint(_ uneNote: Double, uneCouleur: NSColor, offsetSaison: CGFloat, offsetSource: CGFloat)
    {
        let diametre : CGFloat = 5.0
        let origineX : CGFloat = 30.0
        let origineY :CGFloat = 30.0
        let hauteur : CGFloat = (self.frame.height - origineY - 10.0)
        let rect = CGRect(x: (origineX - (diametre/2) - 5 + offsetSaison + offsetSource),
                          y:  (origineY - (diametre/2) + (hauteur * CGFloat(uneNote - 6))/4),
                          width: diametre,
                          height: diametre)

        if (uneNote < 6.0) { return }
        
        uneCouleur.setStroke()
        uneCouleur.setFill()
        
        let path : NSBezierPath = NSBezierPath()
        path.appendOval(in: rect)
        path.stroke()
        path.fill()
    }
    
    
    func traceGrapheImages()
    {
        
        let nbSaisons : Int = theSerie.saisons.count
        let origineX : CGFloat = 30.0
        let largeur : CGFloat = (self.frame.width - origineX - 10.0)
        
        for i:Int in 0 ..< nbSaisons
        {
            let offset : CGFloat = (largeur * (CGFloat(i)+0.5) / CGFloat(nbSaisons))
            
            if (selectTVdb == 1) { traceUneImage(theSerie.saisons[i].ratingTVdb, uneImage: #imageLiteral(resourceName: "thetvdb.jpg"), offsetSaison: offset, offsetSource: 0) }
            if (selectTrakt == 1) { traceUneImage(theSerie.saisons[i].ratingTrakt, uneImage: #imageLiteral(resourceName: "trakt.ico"), offsetSaison: offset, offsetSource: 5) }
            if (selectBetaSeries == 1) { traceUneImage(theSerie.saisons[i].ratingBetaSeries, uneImage: #imageLiteral(resourceName: "betaseries.png"), offsetSaison: offset, offsetSource: 10) }
            if (selectIMDB == 1) { traceUneImage(theSerie.saisons[i].ratingIMdb, uneImage: #imageLiteral(resourceName: "imdb.ico"), offsetSaison: offset, offsetSource: 15) }
        }
    }
    
    
    func traceUneImage(_ uneNote: Double, uneImage: NSImage, offsetSaison: CGFloat, offsetSource: CGFloat)
    {
        let diametre : CGFloat = 16.0
        let origineX : CGFloat = 30.0
        let origineY :CGFloat = 30.0
        let hauteur : CGFloat = (self.frame.height - origineY - 10.0)
        let rect = CGRect(x: (origineX - (diametre/2) - 7 + offsetSaison + offsetSource),
                          y:  (origineY - (diametre/2) + (hauteur * CGFloat(uneNote - 6))/4),
                          width: diametre,
                          height: diametre)
        
        if (uneNote < 6.0) { return }

        uneImage.draw(in: rect)
    }

    
    func traceGrapheLignes()
    {
        let uneCase : CGFloat = (self.frame.width - 30.0 - 10.0) / CGFloat(theSerie.saisons.count)
        
        for uneSaison in theSerie.saisons
        {
            let nbEps: Int = uneSaison.episodes.count
            var locNotesTVdb: [Double] = [Double]()
            var locNotesTrakt: [Double] = [Double]()
            var locNotesBetaSeries: [Double] = [Double]()
            var locNotesIMdb: [Double] = [Double]()
            
            for i:Int in 0 ..< nbEps
            {
                locNotesTVdb.append(uneSaison.episodes[i].ratingTVdb)
                locNotesTrakt.append(uneSaison.episodes[i].ratingTrakt)
                locNotesBetaSeries.append(uneSaison.episodes[i].ratingBetaSeries)
                locNotesIMdb.append(uneSaison.episodes[i].ratingIMdb)
            }

            if (selectTVdb == 1) { traceLigne(locNotesTVdb, nbEpisodes: nbEps, uneCouleur: NSColor.green, offsetSaison: uneSaison.saison, largeur: uneCase) }
            if (selectTrakt == 1) { traceLigne(locNotesTrakt, nbEpisodes: nbEps, uneCouleur: NSColor.red, offsetSaison: uneSaison.saison, largeur: uneCase) }
            if (selectBetaSeries == 1) { traceLigne(locNotesBetaSeries, nbEpisodes: nbEps, uneCouleur: NSColor.blue, offsetSaison: uneSaison.saison, largeur: uneCase) }
            if (selectIMDB == 1) { traceLigne(locNotesIMdb, nbEpisodes: nbEps, uneCouleur: NSColor.yellow, offsetSaison: uneSaison.saison, largeur: uneCase) }
        }
    }
    
    
    func traceLigne(_ desNotes: [Double], nbEpisodes: Int, uneCouleur: NSColor, offsetSaison: Int, largeur: CGFloat)
    {
        let origineX : CGFloat = 30.0 + (CGFloat(offsetSaison - 1) * largeur)
        let origineY :CGFloat = 30.0
        let hauteur : CGFloat = (self.frame.height - origineY - 10.0)
        
        // Regression linéaire
        var sigmaX : Double = 0.0
        var sigmaX2 : Double = 0.0
        var sigmaY : Double = 0.0
        var sigmaXY : Double = 0.0
        var n : Double = 0.0
        
        for i:Int in 0 ..< nbEpisodes
        {
            if desNotes[i] != 0.0
            {
                let X : Double = Double(i+1)
                sigmaX = sigmaX + X
                sigmaY = sigmaY + desNotes[i]
                sigmaX2 = sigmaX2 + (X * X)
                sigmaXY = sigmaXY + (X * desNotes[i])
                n = n + 1.0
            }
        }
        
        // Tracé de la droite
        if (n > 3.0)
        {
            let B : Double = ((n * sigmaXY) - (sigmaX * sigmaY)) / ((n * sigmaX2) - (sigmaX * sigmaX))
            let A : Double = (sigmaY / n) - B * (sigmaX / n)
            
            let path : NSBezierPath = NSBezierPath()
            path.move(to: NSPoint(x: origineX + (largeur * 0.5 / CGFloat(nbEpisodes)), y: (origineY + (hauteur * CGFloat(A + B - 6))/4)))
            path.line(to: NSPoint(x: origineX + (largeur * (CGFloat(nbEpisodes-1)+0.5) / CGFloat(nbEpisodes)), y: (origineY + (hauteur * CGFloat(A + (B * Double(nbEpisodes)) - 6))/4)))
            uneCouleur.setStroke()
            path.lineWidth = 2.0
            
            path.stroke()
        }
    }

}
