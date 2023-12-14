import UIKit
import RxGesture

class StoryViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var barView: StackedBarsView!
    @IBOutlet weak var imageView: UIImageView!
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Properties
    private var viewModel: StoryViewModel!
    private var currentStoryIndex = 0
    private var timer: Timer?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StoryViewModel()
        setupUI()
        setupEvent()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Timer
    private func startTimer() {
        timer?.invalidate()
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
        setupTopView()
    }
    
    // MARK: - Event Setup
    private func setupEvent() {
        addTapGestures()
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

// MARK: - Gesture Handling
extension StoryViewController: UIGestureRecognizerDelegate {
    // MARK: - Top View Setup
    func setupTopView() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Tap Gestures
    func addTapGestures() {
        topView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] gesture in
            guard let self = self else {return}
            self.handleTap(gesture)
        }).disposed(by: disposeBag)
    }
    
     func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: view)
        if tapLocation.x < view.bounds.width / 2 {
            leftSideTapAction()
        } else {
            rightSideTapAction()
        }
        startTimer()
    
    }
    
    // MARK: - Tap Actions
    func leftSideTapAction() {
        guard currentStoryIndex != 0 else {
            navigationController?.popViewController(animated: true)
            return
        }
        currentStoryIndex = (currentStoryIndex - 1) % viewModel.dummyStories.count
        barView.selectedBarIndex = currentStoryIndex
        updateUI(with: viewModel.dummyStories[currentStoryIndex])
        
    }
    
    func rightSideTapAction() {
        guard currentStoryIndex != viewModel.dummyStories.count - 1 else { navigationController?.popViewController(animated: true)
            return
        }
        currentStoryIndex = (currentStoryIndex + 1) % viewModel.dummyStories.count
        barView.selectedBarIndex = currentStoryIndex
        updateUI(with: viewModel.dummyStories[currentStoryIndex])
        
    }
}
