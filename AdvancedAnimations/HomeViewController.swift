import UIKit

final class HomeViewController: UIViewController {
	override func loadView() {
		super.loadView()

		let viewPhotoButton = UIButton(
			configuration: .tinted(),
			primaryAction: UIAction(title: "View Photo") { [weak self] _ in
				guard let self else { return }
				show(PhotoViewController(), sender: nil)
			},
		)

		viewPhotoButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(viewPhotoButton)

		NSLayoutConstraint.activate([
			viewPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			viewPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Home"
		navigationItem.backButtonDisplayMode = .minimal
	}
}
