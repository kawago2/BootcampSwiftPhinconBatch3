import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bottonView: UIView!
    
    var contentSlider: [InfoItem] = []
    var numberOfPages: Int  {
        return self.contentSlider.count
    }
    var timer: Timer?
    var currentPages = 0
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        startAutoplay()
        buttonEvent()
    }
    
    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerButton.setRoundedBorder(cornerRadius: 10)
        loginButton.setRoundedBorder(cornerRadius: 10)
        bottonView.makeCornerRadius(30,maskedCorner: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        collectionView.registerCellWithNib(SliderCell.self)
    }
    
    func buttonEvent() {
        
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
            })
            .disposed(by: disposeBag)

    }
    
    func loadData() {
        contentSlider.append(contentsOf: [
            InfoItem(title: "DIGITAL ABSENSI", description: "Kehadiran sistem absensi digital merupakan penemuan yang mampu menggantikan pencatatan data kehadiran secara manual", imageName: "slide-1"),
            InfoItem(title: "ATTENDANCE SYSTEM", description: "Pengelolaan karyawan di era digital yang baik, menghasilkan karyawan terbaik pula, salah satunya absensi karyawan", imageName: "slide-2"),
            InfoItem(title: "SELALU PAKAI MASKER", description: "Guna mencegah penyebaran virus Covid-19, Pemerintah telah mengeluarkan kebijakan Physical Distancing serta kebijakan bekerja, belajar, dan beribadah dari rumah.", imageName: "slide-3")
        ])
        
    }
    
    func navigateLogin() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    @objc func navigateRegister() {
        let vc = RegisterViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    func startAutoplay() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoplay), userInfo: nil, repeats: true)
    }
    
    @objc func autoplay() {
        currentPages = (currentPages + 1) % numberOfPages
        pageControl.currentPage = currentPages
        let newOffset = CGPoint(x: collectionView.frame.width * CGFloat(currentPages), y: collectionView.contentOffset.y)
        collectionView.setContentOffset(newOffset, animated: true)
        collectionView.layoutIfNeeded()
        updateUIForCurrentPage()
    }

    @objc func pageControlClicked() {
        let currentPage = pageControl.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateUIForCurrentPage()
    }
    
    func updateUIForCurrentPage() {
        guard currentPages < contentSlider.count else { return }
        titleLabel.text = contentSlider[currentPages].title ?? ""
        descLabel.text = contentSlider[currentPages].description ?? ""
    }
}

extension WelcomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = contentSlider.count
        return numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        let image = contentSlider[index].imageName ?? ""
        cell.initData(img: image)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = currentPage
        updateUIForCurrentPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
    
    
}
