import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bottonView: UIView!
    
    // MARK: - Properties
    
    private var viewModel: WelcomeViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        startAutoplay()
        setupEvent()
        configureCollection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
 
    // MARK: - Setup View Model
    
    private func setupViewModel() {
        viewModel = WelcomeViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        registerButton.setRoundedBorder(cornerRadius: 10)
        loginButton.setRoundedBorder(cornerRadius: 10)
        bottonView.makeCornerRadius(30,maskedCorner: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
    }
    
    // MARK: - Setup Event
    
    private func setupEvent() {
        viewModel.updateLabel.subscribe(onNext: {[weak self] (title, desc) in
            guard let self = self else { return }
            self.titleLabel.text = title
            self.descLabel.text = desc
        }).disposed(by: disposeBag)
        
        skipButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigateLogin()
        }).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigateLogin()
        }).disposed(by: disposeBag)
        
        registerButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigateRegister()
        }).disposed(by: disposeBag)
        
        pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pageControlClicked()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    private func navigateLogin() {
        UserDefaultsManager.shared.setLoginTapped(true)
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
        
        
    }
    
    private func navigateRegister() {
        UserDefaultsManager.shared.setLoginTapped(false)
        let vc = RegisterViewController()
        navigationController?.setViewControllers([vc], animated: true)
        
       

    }
}

// MARK: - Setup AutoScroll

extension WelcomeViewController {
    private func startAutoplay() {
        viewModel.timerDisposable = Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] int in
                guard let self = self else { return }
                self.autoplay()
            })
    }
    
    private func resetTimer() {
        viewModel.timerDisposable?.dispose()
        startAutoplay()
    }
    
    private func autoplay() {
        viewModel.currentPages = (viewModel.currentPages + 1) % viewModel.numberOfPages
        pageControl.currentPage = viewModel.currentPages
        let newOffset = CGPoint(x: collectionView.frame.width * CGFloat(viewModel.currentPages), y: collectionView.contentOffset.y)
        collectionView.setContentOffset(newOffset, animated: true)
        collectionView.layoutIfNeeded()
        viewModel.updateUIForCurrentPage()
    }
    
    private func pageControlClicked() {
        let currentPage = pageControl.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        viewModel.updateUIForCurrentPage()
    }
}

// MARK: - Configure Colletion

extension WelcomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollection() {
        collectionView.registerCellWithNib(SliderCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = viewModel.contentSlider.count
        return viewModel.numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SliderCell
        let image = viewModel.contentSlider[index].imageName ?? ""
        cell.initData(img: image)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        viewModel.currentPages = currentPage
        resetTimer()
        viewModel.updateUIForCurrentPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
}
