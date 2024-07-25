import Foundation
import ToastViewSwift

final class ToastView {
    
    private init() {
    }
    
    static var toastDuration: TimeInterval = 3.0
    static var config = ToastConfiguration(
        direction: .top,
        dismissBy: [.time(time: toastDuration), .swipe(direction: .natural), .longPress],
        animationTime: 0.2,
        enteringAnimation: .fade(alpha: 0.5),
        exitingAnimation: .default,
        allowToastOverlap: false
    )
    
    static var viewConfig = ToastViewConfiguration(darkBackgroundColor: .black,
                                                   lightBackgroundColor: .white,
                                                   titleNumberOfLines: 0,
                                                   subtitleNumberOfLines: 0)
    

    static func show(_ message: String?, title: String = "" , image: UIImage? = nil) {
        if let image = image {
            let toast = Toast.default(image: image,
                          title: title,
                          subtitle: message,
                          viewConfig: viewConfig,
                          config: config)
            toast.show()
            return
        }
        
        guard let message = message else {
            return
        }
        
        let toast = Toast.text(message,
                               viewConfig: viewConfig,
                               config: config)
        toast.show()
    }
}
