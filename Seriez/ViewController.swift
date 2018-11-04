//
//  ViewController.swift
//  Seriez
//
//  Created by Cyril Delamare on 06/12/2014.
//  Copyright (c) 2014 Home. All rights reserved.
//

import Cocoa
import Foundation


class ViewController: NSViewController {
    
    //
    // UI Objects
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var traktKey: NSTextField!
    
    @IBOutlet weak var seriesTable: NSTableView!
    @IBOutlet weak var saisonsTable: NSTableView!
    @IBOutlet weak var episodesTable: NSTableView!
    @IBOutlet weak var frameSeries: NSScrollView!
    @IBOutlet weak var frameSaisons: NSScrollView!
    @IBOutlet weak var frameEpisodes: NSScrollView!
    
    @IBOutlet weak var serieLogo: NSImageView!
    @IBOutlet weak var graphUneSaison: Graphique!
    @IBOutlet weak var graphAllSaisons: Graphique2!
    
    // Boutons du coté
    @IBOutlet weak var boutonTVdb: NSButton!
    @IBOutlet weak var boutonTrakt: NSButton!
    @IBOutlet weak var boutonIMDB: NSButton!
    @IBOutlet weak var boutonAlloCine: NSButton!
    @IBOutlet weak var boutonRottenTomatoes: NSButton!
    @IBOutlet weak var boutonTVShowTime: NSButton!
    @IBOutlet weak var boutonBetaSeries: NSButton!
    @IBOutlet weak var noteTrakt: NSButton!
    @IBOutlet weak var noteTVdb: NSButton!
    @IBOutlet weak var noteRotten: NSButton!
    @IBOutlet weak var noteAlloCine: NSButton!
    @IBOutlet weak var noteIMDB: NSButton!
    @IBOutlet weak var noteTVShowTime: NSButton!
    @IBOutlet weak var noteBetaSeries: NSButton!
    
    @IBOutlet weak var selectTrakt: NSButton!
    @IBOutlet weak var selectTVdb: NSButton!
    @IBOutlet weak var selectRottenTomatoes: NSButton!
    @IBOutlet weak var selectIMDB: NSButton!
    @IBOutlet weak var selectAlloCine: NSButton!
    @IBOutlet weak var selectBetaSeries: NSButton!
    @IBOutlet weak var selectTVShowTimes: NSButton!
    
    // View détail des séries
    @IBOutlet weak var viewSerie: NSView!
    @IBOutlet weak var resume: NSTextField!
    @IBOutlet weak var genres: NSTokenField!
    @IBOutlet weak var network: NSTokenField!
    
    
    //View détail des saisons
    @IBOutlet weak var labelSaison: NSTextField!
    @IBOutlet weak var labelEpisode: NSTextField!
    @IBOutlet weak var labelTitre: NSTextField!
    
    //View détail des épisodes
    @IBOutlet weak var viewEpisode: NSView!
    @IBOutlet weak var epResume: NSTextField!
    @IBOutlet weak var epFichier: NSTextField!
    @IBOutlet weak var epQualite: NSTextField!
    @IBOutlet weak var epSource: NSTextField!
    @IBOutlet weak var epCodec: NSTextField!
    @IBOutlet weak var epTeam: NSTextField!
    @IBOutlet weak var epVideo: NSTextField!
    @IBOutlet weak var epDistributeur: NSTextField!
    @IBOutlet weak var epRepertoire: NSPathControl!
    
    // Menu Bar
    @IBOutlet var logger: NSTextView!
    
    
    
    
    
    // http://www.iconarchive.com/show/play-stop-pause-icons-by-icons-land.html
    
    
    //    Clé API : aa6120d2cf7e
    //    https://www.betaseries.com/compte/api/aa6120d2cf7e
    //    Clé secrète (pour OAuth 2.0) : 3fe6b09b6516aca01a7989bdbbb29076
    
    
    
    
    //
    // Appli variables
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Bibliothèque affichée et totale
    var allSeries: [Serie] = [Serie]()
    var dispSeries: [Serie] = [Serie]()
    
    // Mode d'affichage
    let modeSerie: Int = 0
    let modeSaison: Int = 1
    let modeEpisode: Int = 2
    var currentMode: Int = 0
    
    // Items affichés / sélectionnés
    var laSerie : Int =  0
    var laSaison : Int =  0
    var lEpisode : Int =  0
    
    // Data providers
    var trakt : Trakt = Trakt.init()
    var theTVdb : TheTVdb = TheTVdb.init()
    var betaSeries : BetaSeries = BetaSeries.init()
    var imdb : IMdb = IMdb.init()
    
    // Filtres de Series
    var filtreDiffusion : Int = 0
    var filtreVisonnage : Int = 0
    var filtreNetwork : Int = 0
    var filtreGenre : Int = 0
    
    // Divers
    var image : NSImage = NSImage()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var initcomplete : Bool = false
    let fileManager:FileManager = FileManager.default
    var dataPath :String = String()
    var bannerPath :String = String()
    var dataFile :String = String()
    
    // Correctiond es notes pour homogénéisation
    var correctionTVdb : Double = 0.0;
    var correctionIMdb : Double = 0.0;
    var correctionBetaSeries : Double = 0.0;
    var correctionTrakt : Double = 0.0;
    
    // Constantes
    let messageError :Int = 0
    let messageWarning :Int = 1
    let messageInfo :Int = 2
    
    let filtreAucun : Int = 0
    
    let filtreEnCours : Int = 1
    let filtreAJour : Int = 2
    let filtreWatchlist : Int = 3
    let filtreAbandonnee : Int = 4
    
    let filtreSerieAVenir : Int = 1
    let filtreSerieEnCours : Int = 2
    let filtreSerieTerminee : Int = 3
    
    let filtreABC : Int = 1
    let filtreAMC : Int = 2
    let filtreArte : Int = 3
    let filtreBBC : Int = 4
    let filtreCBS : Int = 5
    let filtreCanal : Int = 6
    let filtreChannel4 : Int = 7
    let filtreCinemax : Int = 8
    let filtreFOX : Int = 9
    let filtreFX : Int = 10
    let filtreHBO : Int = 11
    let filtreHistory : Int = 12
    let filtreLifetime : Int = 13
    let filtreM6 : Int = 14
    let filtreMTV : Int = 15
    let filtreNBC : Int = 16
    let filtreNetflix : Int = 17
    let filtreSVT : Int = 18
    let filtreSciFi : Int = 19
    let filtreShowcase : Int = 20
    let filtreShowtime : Int = 21
    let filtreSky : Int = 22
    let filtreSpace : Int = 23
    let filtreStarz : Int = 24
    let filtreSyfy : Int = 25
    let filtreTBS : Int = 26
    let filtreTNT : Int = 27
    let filtreTheCW : Int = 28
    let filtreUSANetwork : Int = 29
    let filtreWGNAmerica : Int = 30
    let filtreYahooScreen : Int = 31
    
    let filtreAction : Int = 1
    let filtreAdventure : Int = 2
    let filtreAnimation : Int = 3
    let filtreComedy : Int = 4
    let filtreCrime : Int = 5
    let filtreDrama : Int = 6
    let filtreFantasy : Int = 7
    let filtreHorror : Int = 8
    let filtreMiniSeries : Int = 9
    let filtreMystery : Int = 10
    let filtreRomance : Int = 11
    let filtreScienceFiction : Int = 12
    let filtreSoap : Int = 13
    let filtreSuspense : Int = 14
    let filtreThriller : Int = 15
    let filtreWestern : Int = 16
    
    
    
    //
    // Initialisation
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seriesTable.tableColumns[0].sortDescriptorPrototype = NSSortDescriptor(key: "serie", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        seriesTable.tableColumns[1].sortDescriptorPrototype = NSSortDescriptor(key: "saisons", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        seriesTable.tableColumns[2].sortDescriptorPrototype = NSSortDescriptor(key: "episodes", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        seriesTable.tableColumns[3].sortDescriptorPrototype = NSSortDescriptor(key: "diffusion", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        seriesTable.tableColumns[4].sortDescriptorPrototype = NSSortDescriptor(key: "status", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        
        // Accessing data directory
        dataPath = NSHomeDirectory()+"/Library/Application Support/Seriez"
        bannerPath  = dataPath+"/banners"
        dataFile = dataPath+"/SeriezBD.dat"
        
        if (fileManager.fileExists(atPath: dataPath))
        {
            // Initialisation à partir de la DB sauvée sur disque
            if (fileManager.fileExists(atPath: dataFile))
            {
                allSeries = (NSKeyedUnarchiver.unarchiveObject(withFile: dataFile) as? [Serie])!
            }
        }
        else
        {
            // Création du répertoire de data
            try! fileManager.createDirectory(atPath: bannerPath+"/graphical", withIntermediateDirectories: true, attributes: nil)
        }
        
        // Connection to data providers
        if (trakt.start(dataPath))
        {
            traktKey.isHidden = true
        }
        else
        {
            traktKey.isHidden = false
        }
        
        theTVdb.start(dataPath)
        //betaSeries.start(dataPath)
        
        
        // Do any additional setup after loading the view.
        frameSeries.isHidden = false
        frameSaisons.isHidden = true
        frameEpisodes.isHidden = true
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd MMM yy"
        timeFormatter.dateFormat = "HH:mm:ss"
        
        if (traktKey.isHidden){
            // Mise à jour des séries collectées (Trakt)
            self.syncCollected(traktKey)
            
            // Mise à jour des séries vues (Trakt)
            self.syncWatched(traktKey)
            
            initcomplete = true
        }
        
        // Et exploration du disque
        self.syncLoaded(traktKey)
        
        allSeries = allSeries.sorted(by:  { $0.serie < $1.serie })
        
        dispSeries = allSeries
        computeCorrections()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    
    @IBAction func refreshAll(_ sender: AnyObject) {
        
        if (currentMode == modeSerie)
        {
            // Affichage de la bonne liste
            frameSeries.isHidden = false
            frameSaisons.isHidden = true
            frameEpisodes.isHidden = true
            seriesTable.reloadData()
            
            // Affichage de la bonne fenêtre à droite
            viewSerie.isHidden = false
            viewEpisode.isHidden = true
            graphAllSaisons.isHidden = false
            graphUneSaison.isHidden = true
            labelSaison.isHidden = true
            labelEpisode.isHidden = true
            labelTitre.isHidden = true
            
            // et on raffraichit les champs
            laSerie = seriesTable.selectedRow
            if (laSerie == -1) { laSerie = 0 }
            
            serieLogo.image = getImage(dispSeries[laSerie].banner)
            resume.stringValue = dispSeries[laSerie].resume
            network.stringValue = dispSeries[laSerie].network
            genres.objectValue = dispSeries[laSerie].genres
            
            // On raffraichit le graphe
            self.graphAllSaisons.sendSerie(dispSeries[laSerie])
            self.graphAllSaisons.sendSelects(selectTVdb.state.rawValue,
                                             selTrakt: selectTrakt.state.rawValue,
                                             selBetaSeries: selectBetaSeries.state.rawValue,
                                             selIMdb: selectIMDB.state.rawValue)
            self.graphAllSaisons.display()
            
            // et on raffraichit les boutons de source
            boutonTVdb.toolTip = dateFormatter.string(from: dispSeries[laSerie].tvdbUpdate as Date)
            boutonTVdb.title = dateFormatter.string(from: dispSeries[laSerie].tvdbUpdate as Date)
            boutonTrakt.title = dateFormatter.string(from: dispSeries[laSerie].traktUpdate as Date)
            boutonBetaSeries.title = dateFormatter.string(from: dispSeries[laSerie].betaSeriesUpdate as Date)
            boutonIMDB.title = dateFormatter.string(from: dispSeries[laSerie].imdbUpdate as Date)
            
            // et on raffraichit les notes des sources
            noteTVdb.title = String(format: "%.1f", dispSeries[laSerie].ratingTVdb)
            noteTrakt.title = String(format: "%.1f", 0.0)
            noteIMDB.title = String(format: "%.1f", 0.0)
            noteBetaSeries.title = String(format: "%.1f", 0.0)
        }
        
        if (currentMode == modeSaison)
        {
            // Affichage de la bonne liste
            frameSeries.isHidden = true
            frameSaisons.isHidden = false
            frameEpisodes.isHidden = true
            saisonsTable.reloadData()
            
            // Affichage de la bonne fenêtre à droite
            viewSerie.isHidden = true
            viewEpisode.isHidden = true
            graphAllSaisons.isHidden = true
            graphUneSaison.isHidden = false
            labelSaison.isHidden = false
            labelEpisode.isHidden = true
            labelTitre.isHidden = true
            
            // et on raffraichit les champs
            laSaison = saisonsTable.selectedRow
            labelSaison.stringValue = "Saison " + String(laSaison+1)
            
            // On raffraichit le graphe
            self.graphUneSaison.sendSerie(dispSeries[laSerie], uneSaison: laSaison)
            self.graphUneSaison.sendSelects(selectTVdb.state.rawValue,
                                            selTrakt: selectTrakt.state.rawValue,
                                            selBetaSeries: selectBetaSeries.state.rawValue,
                                            selIMdb: selectIMDB.state.rawValue)
            self.graphUneSaison.display()
            
            // et on raffraichit les notes des sources
            noteTVdb.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].ratingTVdb)
            noteTrakt.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].ratingTrakt)
            noteIMDB.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].ratingIMdb)
            noteBetaSeries.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].ratingBetaSeries)
        }
        
        if (currentMode == modeEpisode)
        {
            // Affichage de la bonne liste
            frameSeries.isHidden = true
            frameSaisons.isHidden = true
            frameEpisodes.isHidden = false
            episodesTable.reloadData()
            
            // Affichage de la bonne fenêtre à droite
            viewSerie.isHidden = true
            viewEpisode.isHidden = false
            graphAllSaisons.isHidden = true
            graphUneSaison.isHidden = true
            labelSaison.isHidden = false
            labelEpisode.isHidden = false
            labelTitre.isHidden = false
            
            // et on raffraichit les champs
            lEpisode = episodesTable.selectedRow
            epResume.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].resume
            epFichier.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].fichier
            epRepertoire.url = URL.init(fileURLWithPath: dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].path)
            epQualite.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].qualite
            epSource.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].source
            epCodec.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].codec
            epTeam.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].team
            epVideo.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].video
            epDistributeur.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].distrib
            labelSaison.stringValue = "Saison " + String(laSaison+1)
            labelEpisode.stringValue = "Episode " + String(lEpisode+1)
            labelTitre.stringValue = dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].titre
            
            // et on raffraichit les notes des sources
            noteTVdb.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].ratingTVdb)
            noteTrakt.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].ratingTrakt)
            noteIMDB.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].ratingIMdb)
            noteBetaSeries.title = String(format: "%.1f", dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].ratingBetaSeries)
        }
        
    }
    
    
    
    
    //
    // UI Actions
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func upTable(_ sender: AnyObject) {
        
        if (currentMode == modeSaison) { currentMode = modeSerie }
        if (currentMode == modeEpisode) { currentMode = modeSaison }
        self.refreshAll(sender)
    }
    
    @IBAction func deuxClics(_ sender: AnyObject) {
        if (currentMode == modeSaison)
        {
            currentMode = modeEpisode
            episodesTable.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
        }
        
        if (currentMode == modeSerie)
        {
            currentMode = modeSaison
            saisonsTable.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
        }
        
        self.refreshAll(sender)
    }
    
    @IBAction func loadTrakt(_ sender: AnyObject) {
        trakt.getSerieInfos(dispSeries[laSerie])
        dispSeries[laSerie].computeSerieInfos()
        self.refreshAll(sender)
    }
    
    @IBAction func loadTVdb(_ sender: AnyObject) {
        theTVdb.getSerieInfos(dispSeries[laSerie])
        dispSeries[laSerie].computeSerieInfos()
        self.refreshAll(sender)
    }
    
    @IBAction func loadBetaSeries(_ sender: AnyObject) {
        betaSeries.getSerieInfos(dispSeries[laSerie])
        dispSeries[laSerie].computeSerieInfos()
        self.refreshAll(sender)
    }
    
    @IBAction func loadIMdb(_ sender: AnyObject) {
        imdb.getSerieInfos(dispSeries[laSerie])
        dispSeries[laSerie].computeSerieInfos()
        self.refreshAll(sender)
    }
    
    
    @IBAction func keyFilled(_ sender: AnyObject) {
        
        if (traktKey.stringValue.isEmpty) { return }
        
        myLog(message: "Trakt : Renégotiation du token en cours avec \(traktKey.stringValue)", typeMessage: messageInfo)
        
        if (trakt.renegotiateToken(traktKey.stringValue))
        {
            traktKey.isHidden = true
            traktKey.stringValue = ""
            self.syncCollected(traktKey)
            self.syncWatched(traktKey)
            
            initcomplete = true
            
            seriesTable.reloadData()
        }
        else
        {
            traktKey.isHidden = false
        }
    }
    
    
    
    
    @IBAction func filterSeries(_ sender: AnyObject) {
        
        
        let selecteur : NSPopUpButton = sender as! NSPopUpButton
        var tmpListeSerie: [Serie] = [Serie]()
        var tmp2ListeSerie: [Serie] = [Serie]()
        var tmp3ListeSerie: [Serie] = [Serie]()
        dispSeries = []
        
        myLog(message: "Selection = \(selecteur.indexOfSelectedItem), \(selecteur.item(at: 2)?.title ?? "")", typeMessage: messageInfo)
        
        if ((selecteur.item(at: 2)?.title ?? "") == "A jour")
        {
            filtreVisonnage = selecteur.indexOfSelectedItem
        }
        else if ((selecteur.item(at: 2)?.title ?? "") == "AMC")
        {
            filtreNetwork = selecteur.indexOfSelectedItem
        }
        else if ((selecteur.item(at: 2)?.title ?? "") == "Adventure")
        {
            filtreGenre = selecteur.indexOfSelectedItem
        }
        else
        {
            filtreDiffusion = selecteur.indexOfSelectedItem
        }
        
        
        
        switch filtreVisonnage {
        case filtreAucun:
            tmpListeSerie = allSeries
            
        case filtreEnCours:
            tmpListeSerie = []
            for uneSerie in allSeries { if (!uneSerie.watched && !uneSerie.watchlist && !uneSerie.stopped) { tmpListeSerie.append(uneSerie) } }
            
        case filtreAJour:
            tmpListeSerie = []
            for uneSerie in allSeries { if (uneSerie.watched) { tmpListeSerie.append(uneSerie) } }
            
        case filtreWatchlist:
            tmpListeSerie = []
            for uneSerie in allSeries { if (uneSerie.watchlist) { tmpListeSerie.append(uneSerie) } }
            
        case filtreAbandonnee:
            tmpListeSerie = []
            for uneSerie in allSeries { if (uneSerie.stopped) { tmpListeSerie.append(uneSerie) } }
            
        default:
            tmpListeSerie = allSeries
        }
        
        
        
        switch filtreNetwork {
        case filtreAucun:
            tmp2ListeSerie = tmpListeSerie
            
        case filtreABC:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "ABC (US)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreAMC:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "AMC") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreArte:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Arte") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreBBC:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "BBC One" || uneSerie.network == "BBC Two" ) { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreCBS:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "CBS") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreCanal:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Canal+") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreChannel4:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Channel 4" || uneSerie.network == "E4") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreCinemax:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Cinemax") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreFOX:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "FOX (US)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreFX:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "FX (US)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreHBO:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "HBO") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreHistory:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "History") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreLifetime:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Lifetime") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreM6:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "M6") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreMTV:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "MTV (US)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreNBC:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "NBC") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreNetflix:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Netflix") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreSVT:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "SVT") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreSciFi:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "SciFi") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreShowcase:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Showcase (CA)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreShowtime:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Showtime") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreSky:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Sky Atlantic (UK)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreSpace:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Space") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreStarz:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Starz!") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreSyfy:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Syfy") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreTBS:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "TBS") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreTNT:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "TNT (US)") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreTheCW:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "The CW") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreUSANetwork:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "USA Network") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreWGNAmerica:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "WGN America") { tmp2ListeSerie.append(uneSerie) } }
            
        case filtreYahooScreen:
            tmp2ListeSerie = []
            for uneSerie in tmpListeSerie { if (uneSerie.network == "Yahoo! Screen") { tmp2ListeSerie.append(uneSerie) } }
            
        default:
            dispSeries = tmpListeSerie
        }
        
        
        switch filtreGenre {
        case filtreAucun:
            tmp3ListeSerie = tmp2ListeSerie
            
        case filtreAction:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Action")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreAdventure:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Adventure")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreAnimation:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Animation")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreComedy:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Comedy")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreCrime:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Crime")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreDrama:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Drama")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreFantasy:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Fantasy")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreHorror:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Horror")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreMiniSeries:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Mini-Series")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreMystery:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Mystery")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreRomance:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Romance")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreScienceFiction:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Science-Fiction")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreSoap:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Soap")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreSuspense:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Suspense")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreThriller:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Thriller")) { tmp3ListeSerie.append(uneSerie) } }
            
        case filtreWestern:
            tmp3ListeSerie = []
            for uneSerie in tmp2ListeSerie { if (uneSerie.genres.contains("Western")) { tmp3ListeSerie.append(uneSerie) } }
            
        default:
            tmp3ListeSerie = tmp2ListeSerie
        }
        
        
        switch filtreDiffusion {
        case filtreAucun:
            dispSeries = tmp3ListeSerie
            
        case filtreSerieAVenir:
            for uneSerie in tmp3ListeSerie { if (uneSerie.status == "Ended") { dispSeries.append(uneSerie) } }
            
        case filtreSerieEnCours:
            for uneSerie in tmp3ListeSerie { if (uneSerie.status == "Continuing") { dispSeries.append(uneSerie) } }
            
        case filtreSerieTerminee:
            for uneSerie in tmp3ListeSerie { if (uneSerie.status == "Ended") { dispSeries.append(uneSerie) } }
            
        default:
            dispSeries = tmp3ListeSerie
        }
        
        
        laSerie = 0
        refreshAll(sender)
    }
    
    
    
    
    //
    // UI Actions : boutons d'accès au web
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func webTrakt(_ sender: AnyObject) {
        let myURL : String = "http://trakt.tv/shows/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: "'", with: "-").replacingOccurrences(of: " ", with: "-"))/seasons/\(laSaison+1)/episodes/\(lEpisode+1)"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webTheTVdb(_ sender: AnyObject) {
        let myURL : String = "https://www.thetvdb.com/?tab=episode&id=\(dispSeries[laSerie].saisons[laSaison].episodes[lEpisode].idTVdb)"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webRottenTomatoes(_ sender: AnyObject) {
        let myURL : String = String(format: "http://www.rottentomatoes.com/tv/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "_"))/s%02d/e%02d", laSaison+1, lEpisode+1)
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webIMdb(_ sender: AnyObject) {
        let myURL : String = "http://www.imdb.com/title/\(dispSeries[laSerie].idIMdb)/episodes?season=\(laSaison+1)"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webAlloCine(_ sender: AnyObject) {
        let myURL : String = "http://trakt.tv/shows/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "-"))/seasons/\(laSaison+1)/episodes/\(lEpisode+1)"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webBetaSeries(_ sender: AnyObject) {
        let myURL : String = String(format: "https://www.betaseries.com/episode/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "-"))/s%02de%02d", laSaison+1, lEpisode+1)
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webTVshowTime(_ sender: AnyObject) {
        let myURL : String = "http://trakt.tv/shows/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "-"))/seasons/\(laSaison+1)/episodes/\(lEpisode+1)"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webTVmaze(_ sender: AnyObject) {
        let myURL : String = "http://trakt.tv/shows/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "-"))/seasons/\(laSaison+1)/episodes/\(lEpisode+1)"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webAddicted(_ sender: AnyObject) {
        let myURL : String = "http://www.addic7ed.com/serie/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "%20"))/\(laSaison+1)/\(lEpisode+1)/8"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    @IBAction func webSousTitresEU(_ sender: AnyObject) {
        let myURL : String = "https://www.sous-titres.eu/series/\(dispSeries[laSerie].serie.lowercased().replacingOccurrences(of: " ", with: "_")).html"
        NSWorkspace.shared.open(URL(string: myURL)!)
    }
    
    
    
    
    //
    // UI Actions : temp pilotage boutons
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func saveDB(_ sender: AnyObject) { NSKeyedArchiver.archiveRootObject(allSeries, toFile: dataFile) }
    @IBAction func downloadIMDB(_ sender: AnyObject) { imdb.loadRatings(dataPath) }
    
    @IBAction func testFunction(_ sender: AnyObject)   {
        
        var sumTVdb : Double = 0.0
        var nbTVdb : Int = 0
        var sumIMdb : Double = 0.0
        var nbIMdb : Int = 0
        var sumBetaSeries : Double = 0.0
        var nbBetaSeries : Int = 0
        var sumTrakt : Double = 0.0
        var nbTrakt : Int = 0
        
        for uneSerie in allSeries
        {
            for uneSaison in uneSerie.saisons
            {
                for unEpisode in uneSaison.episodes
                {
                    if (unEpisode.ratingTVdb != 0.0 && !unEpisode.ratingTVdb.isNaN)
                    {
                        sumTVdb = sumTVdb + unEpisode.ratingTVdb
                        nbTVdb = nbTVdb + 1
                    }
                    
                    if (unEpisode.ratingIMdb != 0.0 && !unEpisode.ratingIMdb.isNaN)
                    {
                        sumIMdb = sumIMdb + unEpisode.ratingIMdb
                        nbIMdb = nbIMdb + 1
                    }
                    
                    if (unEpisode.ratingBetaSeries != 0.0 && !unEpisode.ratingBetaSeries.isNaN)
                    {
                        sumBetaSeries = sumBetaSeries + unEpisode.ratingBetaSeries
                        nbBetaSeries = nbBetaSeries + 1
                    }
                    
                    if (unEpisode.ratingTrakt != 0.0 && !unEpisode.ratingTrakt.isNaN)
                    {
                        sumTrakt = sumTrakt + unEpisode.ratingTrakt
                        nbTrakt = nbTrakt + 1
                    }
                }
            }
        }
        
        myLog(message: "Note moyenne TVdb : \(sumTVdb / Double(nbTVdb)) pour \(nbTVdb) épisodes", typeMessage: messageInfo)
        myLog(message: "Note moyenne IMdb : \(sumIMdb / Double(nbIMdb)) pour \(nbIMdb) épisodes", typeMessage: messageInfo)
        myLog(message: "Note moyenne BetaSeries : \(sumBetaSeries / Double(nbBetaSeries)) pour \(nbBetaSeries) épisodes", typeMessage: messageInfo)
        myLog(message: "Note moyenne Trakt : \(sumTrakt / Double(nbTrakt)) pour \(nbTrakt) épisodes", typeMessage: messageInfo)
    }
    
    
    @IBAction func bannerClick(_ sender: AnyObject) {
        
        if (frameSaisons.isHidden == false)
        {
            self.graphUneSaison.change()
        }
        
        if (frameSeries.isHidden == false)
        {
            self.graphAllSaisons.change()
        }
        
    }
    
    @IBAction func printInfos(_ sender: AnyObject) {
        dispSeries[laSerie].computeSerieInfos()
        myLog(message: "========================================================", typeMessage: messageError)
        for uneSaison in dispSeries[laSerie].saisons
        {
            myLog(message: "    Saison \(uneSaison.saison) (loaded = \(uneSaison.loaded); collected = \(uneSaison.collected); watched = \(uneSaison.watched))", typeMessage: messageWarning)
            for unEpisode in uneSaison.episodes
            {
                myLog(message: "        Episode \(unEpisode.episode) (loaded = \(unEpisode.loaded); collected = \(unEpisode.collected); watched = \(unEpisode.watched))", typeMessage: messageInfo)
                myLog(message: "                      (Trakt = \(unEpisode.ratingTrakt); theTVdb = \(unEpisode.ratingTVdb); BetaSeries = \(unEpisode.ratingBetaSeries))", typeMessage: messageInfo)
                myLog(message: " ", typeMessage: messageInfo)
            }
        }
        
        for uneSerie in allSeries
        {
            print(uneSerie.genres)
        }
    }
    
    func myLog(message: String, typeMessage: Int) {
        var enteteAttrib: [NSAttributedStringKey : Any] = [:]
        
        
        if (typeMessage == messageWarning) {
            enteteAttrib = [ NSAttributedStringKey.foregroundColor: NSColor.orange,
                             NSAttributedStringKey.font: NSFont(name: "Helvetica", size: 10.0)!] as [NSAttributedStringKey : Any]
        }
        else if (typeMessage == messageError) {
            enteteAttrib = [ NSAttributedStringKey.foregroundColor: NSColor.red,
                             NSAttributedStringKey.font: NSFont(name: "Helvetica", size: 10.0)!] as [NSAttributedStringKey : Any]
        }
        else {
            enteteAttrib = [ NSAttributedStringKey.foregroundColor: NSColor.blue,
                             NSAttributedStringKey.font: NSFont(name: "Helvetica", size: 10.0)!] as [NSAttributedStringKey : Any]
        }
        let texteAttrib = [ NSAttributedStringKey.foregroundColor: NSColor.black,
                            NSAttributedStringKey.font: NSFont(name: "Helvetica", size: 10.0)!] as [NSAttributedStringKey : Any]
        
        
        logger.textStorage?.append(NSAttributedString(string: dateFormatter.string(from: Date()), attributes: enteteAttrib))
        logger.textStorage?.append(NSAttributedString(string: " - ", attributes: enteteAttrib))
        logger.textStorage?.append(NSAttributedString(string: timeFormatter.string(from: Date()), attributes: enteteAttrib))
        logger.textStorage?.append(NSAttributedString(string: " : ", attributes: enteteAttrib))
        logger.textStorage?.append(NSAttributedString(string: message, attributes: texteAttrib))
        logger.textStorage?.append(NSAttributedString(string: "\n", attributes: texteAttrib))
    }
    
    
    //
    // Download infos methods
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func loadAllTrakt(_ sender: Any) {
        myLog(message: "loadAllTrakt START", typeMessage: messageInfo)
        for uneSerie:Serie in allSeries
        {
            trakt.getSerieInfos(uneSerie)
            uneSerie.computeSerieInfos()
        }
        myLog(message: "loadAllTrakt END", typeMessage: messageInfo)
    }
    
    
    @IBAction func loadAllTVdb(_ sender: Any) {
        myLog(message: "loadAllTVdb START", typeMessage: messageInfo)
        for uneSerie:Serie in allSeries
        {
            theTVdb.getSerieInfos(uneSerie)
            uneSerie.computeSerieInfos()
        }
        myLog(message: "loadAllTVdb END", typeMessage: messageInfo)
    }
    
    
    @IBAction func loadAllIMdb(_ sender: Any) {
        myLog(message: "loadAllIMdb START", typeMessage: messageInfo)
        for uneSerie:Serie in allSeries
        {
            imdb.getSerieInfos(uneSerie)
            uneSerie.computeSerieInfos()
        }
        myLog(message: "loadAllIMdb END", typeMessage: messageInfo)
    }
    
    @IBAction func loadAllBetaSeries(_ sender: Any) {
        myLog(message: "loadAllBetaSeries START", typeMessage: messageInfo)
        for uneSerie:Serie in allSeries
        {
            betaSeries.getSerieInfos(uneSerie)
            uneSerie.computeSerieInfos()
        }
        myLog(message: "loadAllBetaSeries END", typeMessage: messageInfo)
    }
    
    
    
    //
    // Build database methods
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func syncCollected(_ sender: AnyObject) { allSeries = self.merge(allSeries, adds: trakt.getCollection()) }
    @IBAction func syncWatched(_ sender: AnyObject) { allSeries = self.merge(allSeries, adds: trakt.getWatched()) }
    @IBAction func syncStopped(_ sender: AnyObject) { allSeries = self.merge(allSeries, adds: trakt.getStopped()) }
    @IBAction func syncWatchlist(_ sender: AnyObject) { allSeries = self.merge(allSeries, adds: trakt.getWatchlist()) }
    
    @IBAction func syncLoaded(_ sender: AnyObject) {
        
        var fileList: [String]!
        var merged : Bool = false
        var localPath :String = String()
        
        // Initialisation de la liste des fichiers en attente
        if (Host.current().localizedName == "iiMac")
        {
            localPath = NSHomeDirectory()+"/Playground/SubsMgr/Torrents"
        }
        else
        {
            localPath = NSHomeDirectory()+"/Data/Telechargements/Torrents"
        }
        fileList = (try! fileManager.contentsOfDirectory(atPath: localPath))
        
        for i:Int in 0 ..< fileList.count
        {
            let episode: Episode = Episode.init(fichier: fileList[i])
            merged = false
            episode.path = localPath
            
            if (episode.serie != "Error")
            {
                for uneSerie in allSeries
                {
                    if (episode.serie.lowercased() == uneSerie.serie.lowercased())
                    {
                        if (episode.saison <= uneSerie.saisons.count)
                        {
                            if (episode.episode <= uneSerie.saisons[episode.saison - 1].episodes.count)
                            {
                                uneSerie.saisons[episode.saison - 1].episodes[episode.episode - 1].merge(episode)
                                merged = true
                            }
                        }
                    }
                }
            }
            if (!merged) { myLog(message: "Fichier à sous titrer ignoré : \(fileList[i])", typeMessage: messageWarning) }
        }
        
    }
    
    @IBAction func syncLocalLibrary(_ sender: Any) {
        var fileListEpisodes: [String]!
        var fileListSaisons: [String]!
        var fileListSeries: [String]!
        var merged : Bool = false
        
        
        // Initialisation de la liste des fichiers rangés
        var localPath :String = String()
        
        if (Host.current().localizedName == "iiMac")
        {
            localPath = NSHomeDirectory()+"/Playground/SubsMgr/Series/"
        }
        else
        {
            localPath = NSHomeDirectory()+"/Data/Videos/Series/"
        }
        fileListSeries = (try! fileManager.contentsOfDirectory(atPath: localPath))
        
        var isSerieDir : ObjCBool = false
        var isSeasonDir : ObjCBool = false
        
        for j:Int in 0 ..< fileListSeries.count
        {
            if ((fileManager.fileExists(atPath: localPath+fileListSeries[j], isDirectory: &isSerieDir)) && (isSerieDir.boolValue))
            {
                fileListSaisons = (try! fileManager.contentsOfDirectory(atPath: localPath+fileListSeries[j]))
                
                for k:Int in 0 ..< fileListSaisons.count
                {
                    if ((fileManager.fileExists(atPath: localPath+fileListSeries[j]+"/"+fileListSaisons[k], isDirectory: &isSeasonDir)) && (isSeasonDir.boolValue))
                    {
                        fileListEpisodes = (try! fileManager.contentsOfDirectory(atPath: localPath+fileListSeries[j]+"/"+fileListSaisons[k]))
                        
                        for i:Int in 0 ..< fileListEpisodes.count
                        {
                            if (!fileListEpisodes[i].hasSuffix("srt"))
                            {
                                let episode: Episode = Episode.init(fichier: fileListEpisodes[i])
                                episode.collected = true
                                merged = false
                                episode.path = localPath+fileListSeries[j]+"/"+fileListSaisons[k]
                                
                                if (episode.serie != "Error")
                                {
                                    for uneSerie in allSeries
                                    {
                                        if (episode.serie.lowercased() == uneSerie.serie.lowercased())
                                        {
                                            if ((episode.saison <= uneSerie.saisons.count) && (episode.episode <= uneSerie.saisons[episode.saison - 1].episodes.count))
                                            {
                                                uneSerie.saisons[episode.saison - 1].episodes[episode.episode - 1].merge(episode)
                                                merged = true
                                            }
                                        }
                                    }
                                }
                                if (!merged) { myLog(message: "Fichier rangé ignoré : \(fileListEpisodes[i])", typeMessage: messageWarning) }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func syncLocalLibraryOld(_ sender: Any) {
        var fileListEpisodes: [String]!
        var fileListSaisons: [String]!
        var fileListSeries: [String]!
        var merged : Bool = false
        
        
        // Initialisation de la liste des fichiers rangés
        var localPath :String = String()
        
        if (Host.current().localizedName == "iiMac")
        {
            localPath = NSHomeDirectory()+"/Playground/SubsMgr/Series/"
        }
        else
        {
            localPath = NSHomeDirectory()+"/Data/Videos/Series/"
        }
        fileListSeries = (try! fileManager.contentsOfDirectory(atPath: localPath))
        
        var isSerieDir : ObjCBool = false
        var isSeasonDir : ObjCBool = false
        
        for j:Int in 0 ..< fileListSeries.count
        {
            if (fileManager.fileExists(atPath: localPath+fileListSeries[j], isDirectory: &isSerieDir))
            {
                if (isSerieDir.boolValue)
                {
                    fileListSaisons = (try! fileManager.contentsOfDirectory(atPath: localPath+fileListSeries[j]))
                    
                    for k:Int in 0 ..< fileListSaisons.count
                    {
                        if (fileManager.fileExists(atPath: localPath+fileListSeries[j]+"/"+fileListSaisons[k], isDirectory: &isSeasonDir))
                        {
                            if (isSeasonDir.boolValue)
                            {
                                fileListEpisodes = (try! fileManager.contentsOfDirectory(atPath: localPath+fileListSeries[j]+"/"+fileListSaisons[k]))
                                
                                for i:Int in 0 ..< fileListEpisodes.count
                                {
                                    if (!fileListEpisodes[i].hasSuffix("srt"))
                                    {
                                        let episode: Episode = Episode.init(fichier: fileListEpisodes[i])
                                        episode.collected = true
                                        merged = false
                                        episode.path = localPath+fileListSeries[j]+"/"+fileListSaisons[k]
                                        
                                        if (episode.serie != "Error")
                                        {
                                            for uneSerie in allSeries
                                            {
                                                if (episode.serie.lowercased() == uneSerie.serie.lowercased())
                                                {
                                                    if (episode.saison <= uneSerie.saisons.count)
                                                    {
                                                        if (episode.episode <= uneSerie.saisons[episode.saison - 1].episodes.count)
                                                        {
                                                            uneSerie.saisons[episode.saison - 1].episodes[episode.episode - 1].merge(episode)
                                                            merged = true
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        if (!merged) { myLog(message: "Fichier rangé ignoré : \(fileListEpisodes[i])", typeMessage: messageWarning) }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func merge(_ db : [Serie], adds : [Serie]) -> [Serie]
    {
        var merged : Bool = false
        var newDB : [Serie] = db
        
        for uneSerie in adds
        {
            merged = false
            
            // On cherche la serie dans les series de la DB
            for dbSerie in db
            {
                if (dbSerie.idTrakt == uneSerie.idTrakt) {
                    dbSerie.merge(uneSerie)
                    merged = true
                }
            }
            
            // Nouvelle serie : on l'ajoute à la DB
            if (!merged) { newDB.append(uneSerie) }
        }
        
        return newDB
    }
    
    
    
    //
    // Table(s) linked methods
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @objc func numberOfRowsInTableView(_ aTableView: NSTableView!) -> Int
    {
        if initcomplete {
            if (aTableView.identifier!.rawValue == "ListeEpisodes") { return dispSeries[laSerie].saisons[laSaison].episodes.count }
            else if (aTableView.identifier!.rawValue == "ListeSeries") { return dispSeries.count }
            else if (aTableView.identifier!.rawValue == "ListeSaisons") { return dispSeries[laSerie].saisons.count }
            else { return 0 }
        }
        else
        {
            return 0
        }
    }
    
    @objc func tableView(_ tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!
    {
        // Table des épisodes
        if (tableView.identifier!.rawValue == "ListeEpisodes"){
            switch tableColumn.identifier.rawValue
            {
            case "Saison": return dispSeries[laSerie].saisons[laSaison].episodes[row].saison as AnyObject
            case "Episode": return dispSeries[laSerie].saisons[laSaison].episodes[row].episode as AnyObject
            case "Titre": return dispSeries[laSerie].saisons[laSaison].episodes[row].titre as AnyObject
            case "Date": return dateFormatter.string(from: dispSeries[laSerie].saisons[laSaison].episodes[row].date as Date) as AnyObject
            case "Diffusion":
                if (dispSeries[laSerie].saisons[laSaison].episodes[row].date.compare(Date()) == ComparisonResult.orderedAscending)
                { return NSImage.init(named: NSImage.Name(rawValue: "Viewed")) }
                else
                { return NSImage.init(named: NSImage.Name(rawValue: "pausing")) }
                
            case "Video":
                if (dispSeries[laSerie].saisons[laSaison].episodes[row].collected)
                { return NSImage.init(named: NSImage.Name(rawValue: "videoOK")) }
                else if (dispSeries[laSerie].saisons[laSaison].episodes[row].loaded)
                { return NSImage.init(named: NSImage.Name(rawValue: "videoWarning")) }
                else
                { return NSImage.init(named: NSImage.Name(rawValue: "videoKO")) }
                
            case "Status":
                if (dispSeries[laSerie].saisons[laSaison].episodes[row].watched)
                { return NSImage.init(named: NSImage.Name(rawValue: "Vu")) }
                else
                { return NSImage() }
                
            default: return "" as AnyObject
            }
        }
            
            // Table des séries
        else if (tableView.identifier!.rawValue == "ListeSeries")
        {
            switch tableColumn.identifier.rawValue
            {
            case "Logo": return getImage(dispSeries[row].banner)
            case "Saison": return dispSeries[row].saisons.count as AnyObject
            case "Episodes": return dispSeries[row].nbEpisodes as AnyObject
            case "Rate": return computeCorrectedRate(uneSerie: dispSeries[row]) as AnyObject
                
            case "Diffusion":
                if (dispSeries[row].status == "Continuing")
                { return NSImage.init(named: NSImage.Name(rawValue: "ToBeContinued")) }
                else if (dispSeries[row].status == "Ended")
                { return NSImage.init(named: NSImage.Name(rawValue: "TheEnd")) }
                else
                { return NSImage.init(named: NSImage.Name(rawValue: "ComingSoon")) }
                
            case "Status":
                if (dispSeries[row].watchlist)
                { return NSImage.init(named: NSImage.Name(rawValue: "Watchlist")) }
                else if (dispSeries[row].stopped)
                { return NSImage.init(named: NSImage.Name(rawValue: "stopped")) }
                else if (dispSeries[row].watched)
                { return NSImage.init(named: NSImage.Name(rawValue: "Vu")) }
                else
                { return NSImage.init(named: NSImage.Name(rawValue: "GoingOn"))}
                
            default: return "" as AnyObject
            }
        }
            
            // Table des saisons
        else if (tableView.identifier!.rawValue == "ListeSaisons")
        {
            switch tableColumn.identifier.rawValue
            {
            case "Logo": return getImage(dispSeries[laSerie].banner)
            case "Saison": return dispSeries[laSerie].saisons[row].saison as AnyObject
            case "Episodes": return dispSeries[laSerie].saisons[row].episodes.count as AnyObject
                
            case "Diffusion":
                if (dispSeries[laSerie].saisons[row].fin.compare(Date()) == ComparisonResult.orderedAscending)
                { return NSImage.init(named: NSImage.Name(rawValue: "Viewed")) }
                else if (dispSeries[laSerie].saisons[row].debut.compare(Date()) == ComparisonResult.orderedAscending)
                { return NSImage.init(named: NSImage.Name(rawValue: "continuing")) }
                else
                { return NSImage.init(named: NSImage.Name(rawValue: "pausing")) }
                
            case "Video":
                if (dispSeries[laSerie].saisons[row].loaded)
                { return NSImage.init(named: NSImage.Name(rawValue: "videoOK")) }
                else if (dispSeries[laSerie].saisons[row].collected)
                { return NSImage.init(named: NSImage.Name(rawValue: "videoWarning")) }
                else
                { return NSImage.init(named: NSImage.Name(rawValue: "videoKO")) }
                
            case "Status":
                if (dispSeries[laSerie].saisons[row].watched)
                { return NSImage.init(named: NSImage.Name(rawValue: "Vu")) }
                else
                { return NSImage() }
                
            case "Debut": return dateFormatter.string(from: dispSeries[laSerie].saisons[row].debut as Date) as AnyObject
            case "Fin": return dateFormatter.string(from: dispSeries[laSerie].saisons[row].fin as Date) as AnyObject
            default: return "" as AnyObject
            }
        }
        else
        {
            return "" as AnyObject
        }
    }
    
    
    @objc func tableView(_ tableView: NSTableView!, sortDescriptorsDidChange oldDescriptors: [AnyObject]) {
        
        if (seriesTable.sortDescriptors[0].ascending)
        {
            switch seriesTable.sortDescriptors[0].key
            {
            case "serie"?: dispSeries = dispSeries.sorted(by: { $0.serie < $1.serie })
            case "saisons"?: dispSeries = dispSeries.sorted(by: { $0.saisons.count < $1.saisons.count })
            case "episodes"?: dispSeries = dispSeries.sorted(by: { $0.nbEpisodes < $1.nbEpisodes })
            case "rate"?: dispSeries = dispSeries.sorted(by: { computeCorrectedRate(uneSerie: $0) < computeCorrectedRate(uneSerie: $1) })
            case "diffusion"?: dispSeries = dispSeries.sorted(by: { $0.status < $1.status })
            case "status"?: dispSeries = dispSeries.sorted(by: { $0.watched.hashValue < $1.watched.hashValue })
            default: break
            }
        }
        else
        {
            switch seriesTable.sortDescriptors[0].key
            {
            case "serie"?: dispSeries = dispSeries.sorted(by: { $0.serie > $1.serie })
            case "saisons"?: dispSeries = dispSeries.sorted(by: { $0.saisons.count > $1.saisons.count })
            case "episodes"?: dispSeries = dispSeries.sorted(by: { $0.nbEpisodes > $1.nbEpisodes })
            case "rate"?: dispSeries = dispSeries.sorted(by: { computeCorrectedRate(uneSerie: $0) > computeCorrectedRate(uneSerie: $1) })
            case "diffusion"?: dispSeries = dispSeries.sorted(by: { $0.status > $1.status })
            case "status"?: dispSeries = dispSeries.sorted(by: { $0.watched.hashValue > $1.watched.hashValue })
            default: break
            }
        }
        
        seriesTable.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
        tableView.reloadData()
    }
    
    
    
    
    
    func getImage(_ url: String) -> NSImage
    {
        if (url == "") { return NSImage() }
        
        if fileManager.fileExists(atPath: "\(bannerPath)/\(url)")
        {
            return NSImage.init(contentsOfFile: "\(bannerPath)/\(url)")!
        }
        else
        {
            let imageData : Data = try! Data.init(contentsOf: URL(string: "https://www.thetvdb.com/banners/\(url)")!)
            try? imageData.write(to: URL(fileURLWithPath: "\(bannerPath)/\(url)"), options: [.atomic])
            return NSImage.init(data: imageData)!
        }
    }
    
    
    func computeCorrectedRate(uneSerie: Serie) -> Int
    {
        var totalRatings : Double = 0.0
        var nbRatings : Int = 0
        
        for uneSaison in uneSerie.saisons
        {
            for unEpisode in uneSaison.episodes
            {
                if (unEpisode.ratingTVdb != 0.0 && !unEpisode.ratingTVdb.isNaN)
                {
                    totalRatings = totalRatings + (80 * unEpisode.ratingTVdb / correctionTVdb)
                    nbRatings = nbRatings + 1
                }
                
                if (unEpisode.ratingIMdb != 0.0 && !unEpisode.ratingIMdb.isNaN)
                {
                    totalRatings = totalRatings + (80 * unEpisode.ratingIMdb / correctionIMdb)
                    nbRatings = nbRatings + 1
                }
                
                if (unEpisode.ratingBetaSeries != 0.0 && !unEpisode.ratingBetaSeries.isNaN)
                {
                    totalRatings = totalRatings + (80 * unEpisode.ratingBetaSeries / correctionBetaSeries)
                    nbRatings = nbRatings + 1
                }
                
                if (unEpisode.ratingTrakt != 0.0 && !unEpisode.ratingTrakt.isNaN)
                {
                    totalRatings = totalRatings + (80 * unEpisode.ratingTrakt / correctionTrakt)
                    nbRatings = nbRatings + 1
                }
            }
        }
        
        if (nbRatings > 0)
        {
            //return Int(totalRatings/Double(nbRatings))
            let rate = 60+((40/15)*((totalRatings/Double(nbRatings))-75))
            return Int(rate)
        }
        else
        {
            return -1
        }
    }
    
    func computeCorrections()   {
        var sumTVdb : Double = 0.0
        var nbTVdb : Int = 0
        var sumIMdb : Double = 0.0
        var nbIMdb : Int = 0
        var sumBetaSeries : Double = 0.0
        var nbBetaSeries : Int = 0
        var sumTrakt : Double = 0.0
        var nbTrakt : Int = 0
        
        var minTVdb : Double = 10.0
        var maxTVdb : Double = 0.0
        var minIMdb : Double = 10.0
        var maxIMdb : Double = 0.0
        var minBetaSeries : Double = 10.0
        var maxBetaSeries : Double = 0.0
        var minTrakt : Double = 10.0
        var maxTrakt : Double = 0.0
        
        for uneSerie in allSeries
        {
            for uneSaison in uneSerie.saisons
            {
                for unEpisode in uneSaison.episodes
                {
                    if (unEpisode.ratingTVdb != 0.0 && !unEpisode.ratingTVdb.isNaN)
                    {
                        if (unEpisode.ratingTVdb < minTVdb) { minTVdb = unEpisode.ratingTVdb }
                        if (unEpisode.ratingTVdb > maxTVdb) { maxTVdb = unEpisode.ratingTVdb }
                        sumTVdb = sumTVdb + unEpisode.ratingTVdb
                        nbTVdb = nbTVdb + 1
                    }
                    
                    if (unEpisode.ratingIMdb != 0.0 && !unEpisode.ratingIMdb.isNaN)
                    {
                        if (unEpisode.ratingIMdb < minIMdb) { minIMdb = unEpisode.ratingIMdb }
                        if (unEpisode.ratingIMdb > maxIMdb) { maxIMdb = unEpisode.ratingIMdb }
                        sumIMdb = sumIMdb + unEpisode.ratingIMdb
                        nbIMdb = nbIMdb + 1
                    }
                    
                    if (unEpisode.ratingBetaSeries != 0.0 && !unEpisode.ratingBetaSeries.isNaN)
                    {
                        if (unEpisode.ratingBetaSeries < minBetaSeries) { minBetaSeries = unEpisode.ratingBetaSeries }
                        if (unEpisode.ratingBetaSeries > maxBetaSeries) { maxBetaSeries = unEpisode.ratingBetaSeries }
                        sumBetaSeries = sumBetaSeries + unEpisode.ratingBetaSeries
                        nbBetaSeries = nbBetaSeries + 1
                    }
                    
                    if (unEpisode.ratingTrakt != 0.0 && !unEpisode.ratingTrakt.isNaN)
                    {
                        if (unEpisode.ratingTrakt < minTrakt) { minTrakt = unEpisode.ratingTrakt }
                        if (unEpisode.ratingTrakt > maxTrakt) { maxTrakt = unEpisode.ratingTrakt }
                        sumTrakt = sumTrakt + unEpisode.ratingTrakt
                        nbTrakt = nbTrakt + 1
                    }
                }
            }
        }
        
        correctionTVdb = sumTVdb / Double(nbTVdb)
        correctionIMdb = sumIMdb / Double(nbIMdb)
        correctionBetaSeries = sumBetaSeries / Double(nbBetaSeries)
        correctionTrakt = sumTrakt / Double(nbTrakt)
        
        myLog(message: "Ratings TVdb       : \(minTVdb) < \(correctionTVdb) < \(maxTVdb)", typeMessage: messageInfo)
        myLog(message: "Ratings IMdb       : \(minIMdb) < \(correctionIMdb) < \(maxIMdb)", typeMessage: messageInfo)
        myLog(message: "Ratings BetaSeries : \(minBetaSeries) < \(correctionBetaSeries) < \(maxBetaSeries)", typeMessage: messageInfo)
        myLog(message: "Ratings Trakt      : \(minTrakt) < \(correctionTrakt) < \(maxTrakt)", typeMessage: messageInfo)
        
    }
    
}


