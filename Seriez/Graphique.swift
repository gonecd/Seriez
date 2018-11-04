//
//  Graphique.swift
//  Seriez
//
//  Created by Cyril Delamare on 11/03/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Cocoa

class Graphique: NSView {
    
    var notesTVdb: [Double] = [Double]()
    var notesTrakt: [Double] = [Double]()
    var notesBetaSeries: [Double] = [Double]()
    var notesIMdb: [Double] = [Double]()
    
    var selectTrakt: Int = 0
    var selectTVdb:  Int = 0
    var selectRottenTomatoes:  Int = 0
    var selectIMDB: Int = 0
    var selectAlloCine: Int = 0
    var selectBetaSeries: Int = 0
    var selectTVShowTimes: Int = 0
    
    var grapheType : Int = 0

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
        self.background()
        self.traceGraphe()
    }
    
    
    func change()
    {
        if (grapheType == 0) { grapheType = 1 }
        else if (grapheType == 1) { grapheType = 2 }
        else if (grapheType == 2) { grapheType = 0 }
        
        self.display()
    }
    
    
    func sendSerie(_ uneSerie: Serie, uneSaison: Int)
    {
        var uneNote : Double = 0.0
        notesTVdb = [Double]()
        notesTrakt = [Double]()
        notesBetaSeries = [Double]()
        notesIMdb = [Double]()

        for i:Int in 0 ..< uneSerie.saisons[uneSaison].episodes.count
        {
            uneNote = uneSerie.saisons[uneSaison].episodes[i].ratingTVdb
            notesTVdb.append(uneNote)
            
            uneNote = uneSerie.saisons[uneSaison].episodes[i].ratingTrakt
            notesTrakt.append(uneNote)
            
            uneNote = uneSerie.saisons[uneSaison].episodes[i].ratingBetaSeries
            notesBetaSeries.append(uneNote)
            
            uneNote = uneSerie.saisons[uneSaison].episodes[i].ratingIMdb
            notesIMdb.append(uneNote)
        }
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
        let textAttributes = [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: NSColor.white]
        let nbEpisodes : Int = notesTVdb.count
        
        // Fond
        NSColor.gray.setFill()
        bounds.fill()
        
        // Cadre
        let path : NSBezierPath = NSBezierPath()
        path.appendRect(NSRect(x: origineX, y: origineY, width: largeur, height: hauteur))
        NSColor.white.setStroke()
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
        NSColor.white.setStroke()
        for i:Int in 0 ..< nbEpisodes
        {
            let pathLine : NSBezierPath = NSBezierPath()
            pathLine.move(to: CGPoint(x: origineX + (largeur * (CGFloat(i)+0.5) / CGFloat(nbEpisodes)), y: origineY - 3))
            pathLine.line(to: CGPoint(x: origineX + (largeur * (CGFloat(i)+0.5) / CGFloat(nbEpisodes)), y:  origineY + 3))
            
            pathLine.setLineDash([10.0,10.0], count: 2, phase: 5.0)
            pathLine.stroke()
            
            let episode : NSString = String(i+1) as NSString
            episode.draw(in: NSRect(x: origineX - 5.0 + (largeur * (CGFloat(i)+0.5) / CGFloat(nbEpisodes)), y: 12, width: 20, height: 10), withAttributes: textAttributes)
        }
        
    }
    
    
    func traceGraphe()
    {
        
        let nbEpisodes : Int = notesTVdb.count
        let origineX : CGFloat = 30.0
        let largeur : CGFloat = (self.frame.width - origineX - 10.0)
        
        if ( ( grapheType == 0) || ( grapheType == 1 ) )
        {
            for i:Int in 0 ..< nbEpisodes
            {
                let offset : CGFloat = (largeur * (CGFloat(i)+0.5) / CGFloat(nbEpisodes))
                
                if (selectTVdb == 1) { traceUnPoint(notesTVdb[i], uneCouleur: NSColor.green, offsetEpisode: offset, offsetSource: 0) }
                if (selectTrakt == 1) { traceUnPoint(notesTrakt[i], uneCouleur: NSColor.red, offsetEpisode: offset, offsetSource: 5) }
                if (selectBetaSeries == 1) { traceUnPoint(notesBetaSeries[i], uneCouleur: NSColor.blue, offsetEpisode: offset, offsetSource: 10) }
                if (selectIMDB == 1) { traceUnPoint(notesIMdb[i], uneCouleur: NSColor.yellow, offsetEpisode: offset, offsetSource: 15) }
            }
        }
        
        if ( ( grapheType == 2) || ( grapheType == 1 ) )
        {
            if (selectTVdb == 1) { traceLigne(notesTVdb, uneCouleur: NSColor.green) }
            if (selectTrakt == 1) { traceLigne(notesTrakt, uneCouleur: NSColor.red) }
            if (selectBetaSeries == 1) { traceLigne(notesBetaSeries, uneCouleur: NSColor.blue) }
            if (selectIMDB == 1) { traceLigne(notesIMdb, uneCouleur: NSColor.yellow) }
        }
        
    }
    
    
    func traceUnPoint(_ uneNote: Double, uneCouleur: NSColor, offsetEpisode: CGFloat, offsetSource: CGFloat)
    {
        let diametre : CGFloat = 10.0
        let origineX : CGFloat = 30.0
        let origineY :CGFloat = 30.0
        let hauteur : CGFloat = (self.frame.height - origineY - 10.0)
        let rect = CGRect(x: (origineX - (diametre/2) - 5 + offsetEpisode + offsetSource),
                          y:  (origineY - (diametre/2) + (hauteur * CGFloat(uneNote - 6))/4),
                          width: diametre,
                          height: diametre)
        
        if (uneNote < 6.0) { return }
        
        uneCouleur.setStroke()
        
        let path : NSBezierPath = NSBezierPath()
        path.appendOval(in: rect)
        path.stroke()
        
    }
    
    
    func traceLigne(_ desNotes: [Double], uneCouleur: NSColor)
    {
        let nbEpisodes : Int = notesTVdb.count
        let origineX : CGFloat = 30.0
        let origineY :CGFloat = 30.0
        let hauteur : CGFloat = (self.frame.height - origineY - 10.0)
        let largeur : CGFloat = (self.frame.width - origineX - 10.0)
        
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
