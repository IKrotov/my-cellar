import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  /// Гарантирует, что у главного окна есть rootViewController.
  /// iOS при уходе в фон проверяет все окна; если rootViewController == nil, пишет
  /// "No windows have a root view controller, cannot save application state" и может некорректно восстанавливать приложение при следующем запуске.
  private func ensureWindowHasRootViewController() {
    guard let w = window else { return }
    if w.rootViewController == nil {
      w.rootViewController = UIViewController()
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if window == nil {
      window = UIWindow(frame: UIScreen.main.bounds)
    }
    ensureWindowHasRootViewController()
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    // После super Flutter может подменить window — снова проверить.
    ensureWindowHasRootViewController()
    return result
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    ensureWindowHasRootViewController()
    super.applicationWillResignActive(application)
  }

  override func applicationDidEnterBackground(_ application: UIApplication) {
    ensureWindowHasRootViewController()
    super.applicationDidEnterBackground(application)
  }
}
