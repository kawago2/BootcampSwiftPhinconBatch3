import UIKit
import RxSwift
import RxCocoa


class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardView: FormView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var onboardingList: [Onboarding] = []
    var numberOfPages: Int  {
        return self.onboardingList.count
    }
    var timer: Timer?
    var currentPages = 0
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonEvent()
        loadData()
        setupUI()
        updateUIForCurrentPage()
    }
    
    private func buttonEvent() {
        nextButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            self.buttonClicked()
        }).disposed(by: disposeBag)
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pageControlClicked()
            })
            .disposed(by: disposeBag)
    }
    
    
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
    
    private func loadData() {
        onboardingList = [
            Onboarding(image: "onboard-1", title: "You ought to know where your money goes", description: "Get an overview of how you are performing and motivate yourself to achieve even more."),
            Onboarding(image: "onboard-2", title: "Gain total control of your money", description: "Track your transactions easily, with categories and financial reports."),
            Onboarding(image: "onboard-3", title: "Plan ahead and manage your money better", description: "Set up your budget for each category so you're in control. Track categories where you spend the most money.")
        ]
    }
    
    private func buttonClicked() {
        if currentPages == onboardingList.count - 1 {
            
        } else {
            currentPages = (currentPages + 1) % numberOfPages
            pageControl.currentPage = currentPages
            let newOffset = CGPoint(x: collectionView.frame.width * CGFloat(currentPages), y: collectionView.contentOffset.y)
            collectionView.setContentOffset(newOffset, animated: true)
            updateUIForCurrentPage()
        }
    
    }
    
    private func pageControlClicked() {
        currentPages = pageControl.currentPage
        let indexPath = IndexPath(item: currentPages, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateUIForCurrentPage()
    }
    
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

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        let onboarding = onboardingList[index]
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
