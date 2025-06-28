import UIKit

final class PhotoViewController: UIViewController {
	private var commentsBar: CommentsViewController!

	override func loadView() {
		super.loadView()
		view.backgroundColor = .systemBackground

		let imageView = UIImageView(image: UIImage(named: "Luna’s Photo"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true

		commentsBar = CommentsViewController()
		addChild(commentsBar)
		defer { commentsBar.didMove(toParent: self) }

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapComments(_:)))
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanComments(_:)))
		commentsBar.view.addGestureRecognizer(tapGestureRecognizer)
		commentsBar.view.addGestureRecognizer(panGestureRecognizer)

		imageView.translatesAutoresizingMaskIntoConstraints = false
		commentsBar.view.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(imageView)
		view.addSubview(commentsBar.view)

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			commentsBar.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			commentsBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			commentsBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Luna’s Photo"
	}

	@objc
	private func didTapComments(_: UITapGestureRecognizer) {
		guard presentedViewController == nil else { return }
		let commentsViewController = CommentsViewController()
		commentsViewController.modalPresentationStyle = .custom
		commentsViewController.transitioningDelegate = self
		present(commentsViewController, animated: true)
	}

	@objc
	private func didPanComments(_: UIPanGestureRecognizer) {
		guard presentedViewController == nil else { return }
		let commentsViewController = CommentsViewController()
		commentsViewController.modalPresentationStyle = .custom
		commentsViewController.transitioningDelegate = self
		present(commentsViewController, animated: true)
	}
}

extension PhotoViewController: UIViewControllerTransitioningDelegate {
	func presentationController(
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source _: UIViewController,
	) -> UIPresentationController? {
		CommentsPresentationController(presentedViewController: presented, presenting: presenting)
	}

	func animationController(
		forPresented _: UIViewController,
		presenting _: UIViewController,
		source _: UIViewController,
	) -> (any UIViewControllerAnimatedTransitioning)? {
		CommentsAnimationController(mode: .presenting, initialFrame: commentsBar.view.frame)
	}

	func animationController(forDismissed _: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
		CommentsAnimationController(mode: .dismissing, initialFrame: commentsBar.view.frame)
	}
}

private final class CommentsAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
	let mode: Mode
	let initialFrame: CGRect

	init(mode: Mode, initialFrame: CGRect) {
		self.mode = mode
		self.initialFrame = initialFrame
	}

	func transitionDuration(using _: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
		0.4
	}

	func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
		let animatingViewController = switch mode {
		case .presenting: transitionContext.viewController(forKey: .to)!
		case .dismissing: transitionContext.viewController(forKey: .from)!
		}

		let duration = transitionDuration(using: transitionContext)
		let timingParameters = UISpringTimingParameters(duration: duration, bounce: 0.1)
		let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)

		let appearedFrame = transitionContext.finalFrame(for: animatingViewController)
		let disappearedFrame = initialFrame

		switch mode {
		case .presenting:
			transitionContext.containerView.addSubview(animatingViewController.view)
			animatingViewController.view.frame = disappearedFrame
			animatingViewController.view.layoutIfNeeded()
			animator.addAnimations { animatingViewController.view.frame = appearedFrame }

		case .dismissing:
			animator.addAnimations { animatingViewController.view.frame = disappearedFrame }
		}

		animator.addCompletion { _ in
			transitionContext.completeTransition(true)
		}

		animator.startAnimation()
	}

	enum Mode {
		case presenting
		case dismissing
	}
}

private final class CommentsPresentationController: UIPresentationController {
	private var dimmingView = UIVisualEffectView(effect: nil)

	override var frameOfPresentedViewInContainerView: CGRect {
		let containerView = containerView!
		let size = size(
			forChildContentContainer: presentedViewController,
			withParentContainerSize: containerView.bounds.size,
		)
		var frame = containerView.bounds
		frame.origin.y = frame.size.height - size.height
		frame.origin.x = (frame.size.width - size.width) / 2
		frame.size = size
		return frame
	}

	override func size(
		forChildContentContainer _: any UIContentContainer,
		withParentContainerSize parentSize: CGSize,
	) -> CGSize {
		var size = parentSize
		let safeAreaInsets = containerView!.safeAreaInsets
		size.height -= safeAreaInsets.top + 40
		size.width -= 100
		return size
	}

	override func presentationTransitionWillBegin() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView(_:)))
		dimmingView.addGestureRecognizer(tapGestureRecognizer)
		dimmingView.frame = containerView!.bounds
		containerView!.addSubview(dimmingView)
		presentedViewController.transitionCoordinator?.animate { [self] _ in
			dimmingView.effect = UIBlurEffect(style: .systemThinMaterialDark)
		}
	}

	override func dismissalTransitionWillBegin() {
		presentedViewController.transitionCoordinator?.animate { [self] _ in
			dimmingView.effect = nil
		}
	}

	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			dimmingView.removeFromSuperview()
		}
	}

	@objc
	private func didTapDimmingView(_: UITapGestureRecognizer) {
		presentedViewController.dismiss(animated: true)
	}
}
