import Foundation
import RxSwift
class WelcomeViewModel {
    
    let updateLabel = PublishSubject<(String, String)>()
    var contentSlider: [InfoItem] = []
    var numberOfPages: Int  {
        return self.contentSlider.count
    }
    var timer: Timer?
    var currentPages = 0
    
    init() {
       loadData()
    }
    
    
    func loadData() {
        contentSlider.append(contentsOf: [
            InfoItem(title: "DIGITAL ABSENSI", description: "Kehadiran sistem absensi digital merupakan penemuan yang mampu menggantikan pencatatan data kehadiran secara manual", imageName: "slide-1"),
            InfoItem(title: "ATTENDANCE SYSTEM", description: "Pengelolaan karyawan di era digital yang baik, menghasilkan karyawan terbaik pula, salah satunya absensi karyawan", imageName: "slide-2"),
            InfoItem(title: "SELALU PAKAI MASKER", description: "Guna mencegah penyebaran virus Covid-19, Pemerintah telah mengeluarkan kebijakan Physical Distancing serta kebijakan bekerja, belajar, dan beribadah dari rumah.", imageName: "slide-3")
        ])
    }
    
    func updateUIForCurrentPage() {
        guard currentPages < contentSlider.count else { return }
        updateLabel.onNext((contentSlider[currentPages].title ?? "",contentSlider[currentPages].description ?? ""))
    }
}
