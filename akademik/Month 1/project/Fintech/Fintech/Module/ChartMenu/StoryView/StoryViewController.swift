import UIKit

class StoryViewController: BaseViewController {
    
    
    @IBOutlet weak var barView: StackedBarsView!
    @IBOutlet weak var imageView: UIImageView!
    
    private let viewModel = StoryViewModel()
    private var currentStoryIndex = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }
    
    private func startTimer() {
           timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateStory), userInfo: nil, repeats: true)
       }
    
    private func setupUI() {
        let initialStory = viewModel.dummyStories.first ?? Story()
        barView.barCount = viewModel.dummyStories.count
        barView.selectedBarIndex = 0
        updateUI(with: initialStory)
    }
    
    @objc private func updateStory() {
        if currentStoryIndex == viewModel.dummyStories.count - 1 {
            navigationController?.popViewController(animated: true)
        }
        currentStoryIndex = (currentStoryIndex + 1) % viewModel.dummyStories.count
        barView.selectedBarIndex = currentStoryIndex
        let currentStory = viewModel.dummyStories[currentStoryIndex]
        updateUI(with: currentStory)
    }
    
    private func updateUI(with story: Story) {
        imageView.image = UIImage(named: story.imageName ?? CustomImage.notAvailImage)
        view.backgroundColor = UIColor(named: story.backgroundColor ?? "")
    }

    deinit {
        stopTimer()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
