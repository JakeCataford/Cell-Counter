//
//  BatchImageCounter.swift
//  Cell Counter
//
//  Created by Jake Cataford on 2016-12-18.
//  Copyright © 2016 Jake Cataford. All rights reserved.
//

import Cocoa

class BatchImageCounter: NSObject {
    let inputFileDialog = NSOpenPanel()
    let params: SearchParams;
    let window: NSWindow;

    init(params: SearchParams, window: NSWindow) {
        self.params = params;
        self.window = window;
    }
    
    func performBatch() {
        inputFileDialog.allowsMultipleSelection = true
        inputFileDialog.allowedFileTypes = NSImage.imageTypes();
        inputFileDialog.canChooseDirectories = false
        inputFileDialog.canCreateDirectories = false
        inputFileDialog.canChooseFiles = true
        inputFileDialog.beginSheetModal(for: window, completionHandler: onInputFilesWereSelected)
    }
    
    private func onInputFilesWereSelected(result: Int) {
        if (result == NSFileHandlingPanelOKButton) {
            var csvArray = ["file_name,count"]
            for url in inputFileDialog.urls {
                let info = processImage(url: url);
                csvArray.append("\(info.fileName),\(uint((info.count)!))")
            }

            let outputFileDialog = NSSavePanel()
            
            outputFileDialog.title = "Save Counts as CSV"
            outputFileDialog.allowedFileTypes = ["csv"]
            outputFileDialog.nameFieldStringValue = "Output.csv"
            outputFileDialog.beginSheetModal(for: window, completionHandler: { (saveResult: Int) -> Void in
                if (saveResult == NSFileHandlingPanelOKButton) {
                    do {
                        try csvArray.joined(separator: "\n").write(to: outputFileDialog.url!, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        
                    }
                }
            })
        }
    }
    
    private func processImage(url: URL) -> (fileName: String, count: UInt?, preview: NSImage?) {
        let image = NSImage.init(contentsOf: url);
        let result = OpenCV.detectBlobs(in: image, with: params);
        
        return (fileName: url.lastPathComponent, count: result?.numberOfCellsCounted, preview: result?.markedImage)
    }

}
