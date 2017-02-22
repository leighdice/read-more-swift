//
//  ReadMoreTextView.swift
//  read-more-text-view
//
//  Created by Leigh Brown on 22/02/2017.
//  Copyright © 2017 Leighroy. All rights reserved.
//

import UIKit

/// Informs delegate when ReadMoreTextView has finished maximizing / minimizing if UI changes are needed
protocol ReadMoreTextViewDelegate {

    /// Notify when the ReadMoreTextView has finished maximizing
    func hasFinishedMaximizing()

    /// Notify when the ReadMoreTextView has finished minimizing
    func hasFinishedMinimizing()
}

class ReadMoreTextView: UITextView {

    /// Button to show / hide text view
    @IBOutlet weak var readMoreButton: UIButton?

    /// Height constraint for preview size
    @IBOutlet weak var trimmedConstraint: NSLayoutConstraint?

    /// Height constraint for full size
    @IBOutlet weak var extendedConstraint: NSLayoutConstraint?

    /// Gradient view overlay
    var gradientView: GradientView?

    /// Optional gradient view over the trimmed textview. Defaults to true
    var useGradientView: Bool = true

    /// Whether the textview is extended or not (read only)
    var isExtended: Bool = false

    /// Removes the readMoreButton from the superview. Defaults to false.
    var removeReadMoreButtonOnMaximize: Bool = false

    /// Delegate for receiving protocol methods
    var readMoreDelegate: ReadMoreTextViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGradientView()
        isScrollEnabled = false
        readMoreButton?.addTarget(self, action: #selector(readMoreButtonPressed), for: .touchUpInside)
    }
}

// MARK: - Private functions
private extension ReadMoreTextView {

    /// Determines whether constraints are being used for resizing
    ///
    /// - Returns: whether constraints have been connected
    func isUsingConstraints() -> Bool {
        guard let _ = trimmedConstraint, let _ = extendedConstraint else {
            return false
        }
        return true
    }

    @IBAction func readMoreButtonPressed() {
        switch (isUsingConstraints(), isExtended) {
        case (true, true):
            animateMinimizeWithConstraints()
        case (true, false):
            animateMinimize()
        case (false, true):
            animateMaximizeWithConstraints()
        case (false, false):
            animateMaximize()
        }
    }

    func setupGradientView() {
        if !useGradientView {
            return
        }

        let gradient = GradientView(frame: frame)
        gradient.topColor    = UIColor.clear
        gradient.bottomColor = UIColor.white
        gradientView = gradient
        insertSubview(gradientView!, at: 0)
    }
}

// MARK: - Animations
private extension ReadMoreTextView {

    func animateMaximizeWithConstraints() {
        UIView.animate(withDuration: TimeInterval(0.7), animations: {
            self.readMoreButton?.alpha = 0.0
            self.gradientView?.alpha = 0.0
        }, completion: { completed in
            self.trimmedConstraint?.priority = 250
            self.extendedConstraint?.priority = 750
            self.setNeedsLayout()
            self.isExtended = true
            self.readMoreDelegate?.hasFinishedMaximizing()
        })
    }

    func animateMinimizeWithConstraints() {
        UIView.animate(withDuration: TimeInterval(0.7), animations: {
            self.readMoreButton?.alpha = 1.0
            self.gradientView?.alpha = 1.0
        }, completion: { completed in
            self.trimmedConstraint?.priority = 750
            self.extendedConstraint?.priority = 250
            self.setNeedsLayout()
            self.isExtended = false
            self.readMoreDelegate?.hasFinishedMinimizing()
        })
    }

    func animateMaximize() {

    }

    func animateMinimize() {

    }
}
