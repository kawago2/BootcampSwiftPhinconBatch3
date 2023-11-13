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
        setup()
        startAutoplay()
    }
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        registerButton.setRoundedBorder(cornerRadius: 10)
        loginButton.setRoundedBorder(cornerRadius: 10)
        collectionView.registerCellWithNib(SliderCell.self)
    }
    
    func startAutoplay() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoplay), userInfo: nil, repeats: true)
    }
    
    @objc func autoplay() {
        currentPages = (currentPages + 1) % numberOfPages
        let index = IndexPath(item: currentPages, section: 0)
        print(index)
        collectionView.scrollToItem(at: index, at: .centeredVertically, animated: true)
        setDataScroll(index: currentPages) // Call setDataScroll with the updated currentPage
    }

    
    
    func setDataScroll(index: Int) {
        titleLabel.text = dataArray[index]["title"]
        descLabel.text = dataArray[index]["desc"]
    }
}

extension WelcomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        setDataScroll(index :currentPage)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
    
    
}
