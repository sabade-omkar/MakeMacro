import UIKit
import MakeMacroKit
import MakemacroUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = MacroMakerViewController()
        viewController.view.backgroundColor = .gray

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .white

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
