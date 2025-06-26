import UIKit

final class PhotoViewController: UIViewController {
	override func loadView() {
		super.loadView()
		view.backgroundColor = .systemBackground

		let imageView = UIImageView(image: UIImage(named: "Luna’s Photo"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true

		let commentsViewController = CommentsViewController()
		addChild(commentsViewController)
		defer { commentsViewController.didMove(toParent: self) }

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapComments(_:)))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanComments(_:)))
		commentsViewController.view.addGestureRecognizer(tapGestureRecognizer)
		commentsViewController.view.addGestureRecognizer(panGestureRecognizer)

		imageView.translatesAutoresizingMaskIntoConstraints = false
		commentsViewController.view.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(imageView)
		view.addSubview(commentsViewController.view)

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			commentsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			commentsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			commentsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Luna’s Photo"
	}

	@objc
	private func didTapComments(_ gestureRecognizer: UITapGestureRecognizer) {
		guard presentedViewController == nil else { return }
		present(CommentsViewController(), animated: true)
	}

	@objc
	private func didPanComments(_ gestureRecognizer: UIPanGestureRecognizer) {
		guard presentedViewController == nil else { return }
		present(CommentsViewController(), animated: true)
	}
}
