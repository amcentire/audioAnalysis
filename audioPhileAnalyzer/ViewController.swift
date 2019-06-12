//
//  ViewController.swift
//  audioPhileAnalyzer
//
//  Created by MacOS Test Account on 6/12/19.
//  Copyright © 2019 MacOS Test Account. All rights reserved.
//

import UIKit
import SoundAnalysis
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var diffDataSource: UITableViewDiffableDataSource<Int, String>!
    var soundPaths: [String] = []
    var clapOrCoughClassifier = ClapOrCoughClassifier_1_1()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cellId = "CellID"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // TODO: Replace with sound stream analyzer
        guard let pathToSnoring = Bundle.main.path(forResource: "testAudio.wav", ofType: nil) else {
            //TODO: Handle this scenario?
            return
        }
        soundPaths = [pathToSnoring]
        
        diffDataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView) { (tableView:UITableView, indexPath:IndexPath, model: String) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = String(model)
            return cell
        }
        tableView.dataSource = diffDataSource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(analyzeAudioFile())
        diffDataSource.apply(snapshot)
        //borissMagicFunctionOfAwesomePOWER()
    }
    
    //This function was written by Boris Mezhibovskiy
    //TODO: update so it loads percent return from audio analysis
    func borissMagicFunctionOfAwesomePOWER() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) { [weak self] in
            self?.borissMagicFunctionOfAwesomePOWER()
        }
        
        let currentSnapshot = diffDataSource.snapshot()
        let randomIndex = Int(arc4random()) % currentSnapshot.numberOfItems
        let randomId = currentSnapshot.itemIdentifiers[randomIndex]
        for result in analyzeAudioFile() {
            currentSnapshot.insertItems([result], afterItem: randomId)
        }
        
        diffDataSource.apply(currentSnapshot)
    }
    
    func analyzeAudioFile() -> [String] {
        var resultsArray = [String]()
        if let path = Bundle.main.path(forResource: "testAudio.wav", ofType: nil) {
            let audioFileURL = URL(fileURLWithPath: path)
            
            // Create a new audio file analyzer.
            do {
                let audioFileAnalyzer = try SNAudioFileAnalyzer(url: audioFileURL)
                let resultsObserver = ResultsObserver()
                let request = try SNClassifySoundRequest(mlModel: clapOrCoughClassifier.model)
                try audioFileAnalyzer.add(request, withObserver: resultsObserver)
                audioFileAnalyzer.analyze()
                
                resultsArray = resultsObserver.resultArray
            } catch {
                //do nothing
            }
        }
        return resultsArray
    }
}

