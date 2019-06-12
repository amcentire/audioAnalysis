//
//  ResultsObserver.swift
//  audioPhileAnalyzer
//
//  Created by MacOS Test Account on 6/12/19.
//  Copyright © 2019 MacOS Test Account. All rights reserved.
//
import SoundAnalysis
// Observer object that is called as analysis results are found.
class ResultsObserver : NSObject, SNResultsObserving {
    
    public var resultArray = [String]()
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        // Get the top classification.
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        // Determine the time of this result.
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds)
        
        let confidence = classification.confidence * 100.0
        let percent = String(format: "%.2f%%", confidence)
        
        let liveResult = ("Analysis result for audio at time: \(formattedTime) | \(classification.identifier): \(percent) confidence.\n")
        resultArray.append(liveResult)
        
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}
