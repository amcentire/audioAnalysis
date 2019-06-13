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
    private var clapOrCoughClassifier = ClapOrCoughClassifier_1_1()
    private let snapshot = NSDiffableDataSourceSnapshot<Int, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellId = "CellID"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        diffDataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView) { (tableView:UITableView, indexPath:IndexPath, model: String) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = String(model)
            return cell
        }
        tableView.dataSource = diffDataSource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        snapshot.appendSections([0])
        snapshot.appendItems(analyzeAudioFile())
        diffDataSource.apply(snapshot)
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
