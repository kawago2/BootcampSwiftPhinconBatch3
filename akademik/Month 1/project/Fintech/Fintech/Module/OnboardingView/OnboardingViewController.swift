import UIKit
import RxSwift
import RxCocoa

private enum OnboardingImages {
    static let onboard1 = "onboard-1"
    static let onboard2 = "onboard-2"
    static let onboard3 = "onboard-3"
}

class OnboardingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: FormView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    var onboardingList: [Onboarding] = []
    var numberOfPages: Int  {
        return self.onboardingList.count
    }
    var timer: Timer?
    var currentPages = 0
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEvent()
        loadData()
        setupUI()
        updateUIForCurrentPage()
    }
    
    // MARK: - Button Events
    private func buttonEvent() {
        nextButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.nextButtonClicked()
        }).disposed(by: disposeBag)
        
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pageControlValueChanged()
            })
            .disposed(by: disposeBag)
        
        skipButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.getstartedTapped()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        skipButton.backgroundColor = .white.withAlphaComponent(0.10)
        skipButton.roundCorners(corners: [.allCorners], cornerRadius: 30)
        descriptionLabel.textColor = UIColor(hex: "13095E")?.withAlphaComponent(0.80)
        titleLabel.textColor = UIColor(hex: "13095E")
        nextButton.backgroundColor = UIColor(named: "Primary")
        nextButton.tintColor = .white
        nextButton.roundCorners(corners: [.allCorners], cornerRadius: 30)
        collectionView.isScrollEnabled = false
        
        collectionView.registerCellWithNib(OnboardingCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Data Load
    private func loadData() {
        onboardingList = [
            Onboarding(image: OnboardingImages.onboard1, title: "You ought to know where your money goes", description: "Get an overview of how you are performing and motivate yourself to achieve even more."),
            Onboarding(image: OnboardingImages.onboard2, title: "Gain total control of your money", description: "Track your transactions easily, with categories and financial reports."),
            Onboarding(image: OnboardingImages.onboard3, title: "Plan ahead and manage your money better", description: "Set up your budget for each category so you're in control. Track categories where you spend the most money.")
        ]
    }
    
    // MARK: - Button Actions
    private func nextButtonClicked() {
        if currentPages == onboardingList.count - 1 {
            getstartedTapped()
        } else {
            currentPages = (currentPages + 1) % numberOfPages
            pageControl.currentPage = currentPages
            let newOffset = CGPoint(x: collectionView.frame.width * CGFloat(currentPages), y: collectionView.contentOffset.y)
            collectionView.setContentOffset(newOffset, animated: true)
            updateUIForCurrentPage()
        }
    }
    
    private func pageControlValueChanged() {
        currentPages = pageControl.currentPage
        let indexPath = IndexPath(item: currentPages, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateUIForCurrentPage()
    }
    
    private func getstartedTapped() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    // MARK: - UI Update
    private func updateUIForCurrentPage() {
        guard currentPages < onboardingList.count else { return }
        titleLabel.text = onboardingList[currentPages].title ?? ""
        descriptionLabel.text = onboardingList[currentPages].description ?? ""
        nextButton.setTitle("Next", for: .normal)
        if currentPages == onboardingList.count - 1 {
            nextButton.setTitle("Get Started", for: .normal)
        }
    }
    
}

// MARK: - Extension
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        let onboarding = onboardingList[indexPath.item]
        cell.configureImage(image: onboarding.image ?? "image_not_available")

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        updateUIForCurrentPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 393, height: 275)
    }
    
}
