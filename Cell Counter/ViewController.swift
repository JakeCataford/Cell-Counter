import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var InputImageCell: NSImageView!
    @IBOutlet weak var OutputImageCell: NSImageView!
    @IBOutlet weak var MinDistanceSlider: NSSliderCell!
    @IBOutlet weak var CellsCountedLabel: NSTextField!
    @IBOutlet var ThresholdRangeSlider: RangeSlider!
    @IBOutlet var FilterByAreaCheckbox: NSButton!
    @IBOutlet var AreaRangeSlider: RangeSlider!
    @IBOutlet var FilterByInteriaCheckbox: NSButton!
    @IBOutlet var InertiaRangeSlider: RangeSlider!
    @IBOutlet var FilterByConvexityCheckbox: NSButton!
    @IBOutlet var ConvexityRangeSlider: RangeSlider!
    @IBOutlet weak var SearchColorPicker: NSColorWell!
    @IBOutlet weak var BrightnessSlider: NSSlider!
    weak var Input: NSImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThresholdRangeSlider.minValue = 0;
        ThresholdRangeSlider.maxValue = 255;
        AreaRangeSlider.minValue = 0;
        AreaRangeSlider.maxValue = 1000;
        InertiaRangeSlider.minValue = 0;
        InertiaRangeSlider.maxValue = 1;
        ConvexityRangeSlider.minValue = 0;
        ConvexityRangeSlider.maxValue = 1;
        
        ThresholdRangeSlider.onControlChanged = updateOutput
        AreaRangeSlider.onControlChanged = updateOutput
        InertiaRangeSlider.onControlChanged = updateOutput
        ConvexityRangeSlider.onControlChanged = updateOutput
        
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    
    @IBAction func inputImageDidChange(_ sender: NSImageView) {
        if (sender.image != nil) {
            Input = sender.image!
            updateOutput(sender: sender)
        }
    }
    
    @IBAction func filterByAreaCheckboxDidChange(_ sender: Any) {
        updateOutput(sender: sender)
    }
    
    @IBAction func filterByInertiaCheckboxDidChange(_ sender: Any) {
        updateOutput(sender: sender)
    }
    
    @IBAction func filterByConvexityCheckboxDidChange(_ sender: Any) {
        updateOutput(sender: sender)
    }
    
    @IBAction func brightnessSliderDidChange(_ sender: NSSlider) {
        SearchColorPicker.color = NSColor(hue: 1, saturation: 0, brightness: CGFloat(sender.floatValue), alpha: 1)
    }
    
    @IBAction func onBatchProcessShouldOccur(_ sender: Any) {
        let batch = BatchImageCounter(params: getParams(), window: view.window!)
        batch.performBatch()
    }
    
    func updateOutput(sender: Any) {
        if (Input != nil) {
            let result = OpenCV.detectBlobs(
                in: Input,
                with: getParams()
            )
            
            OutputImageCell.image = result?.markedImage;
            CellsCountedLabel.stringValue = "\(uint((result?.numberOfCellsCounted)!)) Cells Counted"
        }
    }
    
    private func getParams() -> SearchParams {
        let params = SearchParams();
        
        params.minDistance = MinDistanceSlider.floatValue
        
        params.minThreshold = Float(ThresholdRangeSlider.start)
        params.maxThreshold = Float(ThresholdRangeSlider.end)
        
        params.filterByArea = (FilterByAreaCheckbox.state == NSOnState)
        params.minArea = Float(AreaRangeSlider.start)
        params.maxArea = Float(AreaRangeSlider.end)
        
        params.filterByInertia = (FilterByInteriaCheckbox.state == NSOnState)
        params.minInertiaRatio = Float(InertiaRangeSlider.start)
        params.maxInertiaRatio = Float(InertiaRangeSlider.end)
        
        params.filterByConvexity = (FilterByConvexityCheckbox.state == NSOnState)
        params.minConvexity = Float(ConvexityRangeSlider.start)
        params.maxConvexity = Float(ConvexityRangeSlider.end)
        
        params.searchColor = SearchColorPicker.color

        return params;
    }
}

