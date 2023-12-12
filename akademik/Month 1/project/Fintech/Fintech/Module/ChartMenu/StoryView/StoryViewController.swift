import UIKit
import RxGesture

class StoryViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var barView: StackedBarsView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    private let viewModel = StoryViewModel()
    private var currentStoryIndex = 0
    private var timer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateStory), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let initialStory = viewModel.dummyStories.first ?? Story()
        barView.barCount = viewModel.dummyStories.count
        barView.selectedBarIndex = 0
        updateUI(with: initialStory)
    }
    
    // MARK: - Event Setup
    private func setupEvent() {
    }
    
    // MARK: - Story Update
    @objc private func updateStory() {
        if currentStoryIndex == viewModel.dummyStories.count - 1 {
            navigationController?.popViewController(animated: true)
        }
        currentStoryIndex = (currentStoryIndex + 1) % viewModel.dummyStories.count
        barView.selectedBarIndex = currentStoryIndex
        let currentStory = viewModel.dummyStories[currentStoryIndex]
        updateUI(with: currentStory)
    }
    
    // MARK: - UI Update
    private func updateUI(with story: Story) {
        imageView.image = UIImage(named: story.imageName ?? CustomImage.notAvailImage)
        view.backgroundColor = UIColor(named: story.backgroundColor ?? "")
    }
}
