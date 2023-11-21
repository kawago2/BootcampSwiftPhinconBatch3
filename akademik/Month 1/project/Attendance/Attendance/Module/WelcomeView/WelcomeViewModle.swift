import RxSwift
import RxCocoa
import UIKit

class WelcomeViewModel {
    let title = BehaviorRelay<String>(value: "")
    let description = BehaviorRelay<String>(value: "")
    let image = BehaviorRelay<[String]>(value: [])
    let currentPage = BehaviorRelay<Int>(value: 0)
    let pageCount = BehaviorRelay<Int>(value: 0)

    let skipButtonTappedSubject = PublishSubject<Void>()
    let loginButtonTappedSubject = PublishSubject<Void>()
    let registerButtonTappedSubject = PublishSubject<Void>()
    let pageControlChangedSubject = PublishSubject<Int>()

    private let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        let dataArray = [
            ["title": "DIGITAL ABSENSI", "desc": "Kehadiran sistem absensi digital merupakan penemuan yang mampu menggantikan pencatatan data kehadiran secara manual", "img": "slide-1"],
            ["title": "ATTENDANCE SYSTEM", "desc": "Pengelolaan karyawan di era digital yang baik, menghasilkan karyawan terbaik pula, salah satunya absensi karyawan", "img": "slide-2"],
            ["title": "SELALU PAKAI MASKER", "desc": "Guna mencegah penyebaran virus Covid-19, Pemerintah telah mengeluarkan kebijakan Physical Distancing serta kebijakan bekerja, belajar, dan beribadah dari rumah.", "img": "slide-3"]
        ]

        title.accept(dataArray[0]["title"] ?? "")
        description.accept(dataArray[0]["desc"] ?? "")
        image.accept(dataArray.map { $0["img"] ?? "" })
        currentPage.accept(0)
        pageCount.accept(dataArray.count)

        skipButtonTappedSubject
            .subscribe(onNext: { [weak self] in
                self?.handleSkipButtonTapped()
            })
            .disposed(by: disposeBag)

        loginButtonTappedSubject
            .subscribe(onNext: { [weak self] in
                self?.handleLoginButtonTapped()
            })
            .disposed(by: disposeBag)

        registerButtonTappedSubject
            .subscribe(onNext: { [weak self] in
                self?.handleRegisterButtonTapped()
            })
            .disposed(by: disposeBag)

        pageControlChangedSubject
            .subscribe(onNext: { [weak self] index in
                self?.handlePageControlChanged(index: index)
            })
            .disposed(by: disposeBag)
    }

    func handleSkipButtonTapped() {
        print("Skip button tapped")
    }

    func handleLoginButtonTapped() {
        print("Login button tapped")
    }

    func handleRegisterButtonTapped() {
        print("Register button tapped")
    }

    func handlePageControlChanged(index: Int) {
        currentPage.accept(index)
        print("Page control value changed to index \(index)")
    }
}

