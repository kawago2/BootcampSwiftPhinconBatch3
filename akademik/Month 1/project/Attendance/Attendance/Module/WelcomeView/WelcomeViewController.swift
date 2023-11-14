//
//  WelcomeViewController.swift
//  Attendance
//
//  Created by Phincon on 13/11/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let dataArray = [
        ["title": "DIGITAL ABSENSI", "desc": "Kehadiran sistem absensi digital merupakan penemuan yang mampu menggantikan pencatatan data kehadiran secara manual", "img": "slide-1"],
        ["title": "ATTENDANCE SYSTEM", "desc": "Pengelolaan karyawan di era digital yang baik, menghasilkan karyawan terbaik pula, salah satunya absensi karyawan", "img": "slide-2"],
        ["title": "SELALU PAKAI MASKER", "desc": "Guna mencegah penyebaran virus Covid-19, Pemerintah telah mengeluarkan kebijakan Physical Distancing serta kebijakan bekerja, belajar, dan beribadah dari rumah.", "img": "slide-3"]
    ]
    
    let numberOfPages = 3
    var timer: Timer?
    var currentPages = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAutoplay()
    }
    
    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerButton.setRoundedBorder(cornerRadius: 10)
        loginButton.setRoundedBorder(cornerRadius: 10)
        collectionView.registerCellWithNib(SliderCell.self)
    }
    
    func buttonEvent() {
//        skipButton.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
    }
    
    func startAutoplay() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoplay), userInfo: nil, repeats: currentPages == 3 ? false : true)
    }
    
    @objc func autoplay() {
        currentPages = (currentPages + 1) % numberOfPages
        let index = IndexPath(item: currentPages, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        collectionView.layoutIfNeeded()
        updateUIForCurrentPage()
    }

    @IBAction func pageControlClicked(_ sender: Any) {
        let currentPage = (sender as AnyObject).currentPage
        let indexPath = IndexPath(item: currentPage ?? 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateUIForCurrentPage()
    }
    
    func updateUIForCurrentPage() {
        guard currentPages < dataArray.count else { return }
        titleLabel.text = dataArray[currentPages]["title"]
        descLabel.text = dataArray[currentPages]["desc"]
    }
}

extension WelcomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = dataArray.count
        return numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        let image = dataArray[index]["img"] ?? ""
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
