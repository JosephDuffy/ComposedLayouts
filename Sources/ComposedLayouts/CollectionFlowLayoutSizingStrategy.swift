import UIKit
import ComposedUI

/// A helper class that encapsulates the sizing logic for building column/table style layouts with `UICollectionViewFlowLayout`
open class CollectionFlowLayoutSizingStrategy {

    /// The sizing mode to apply for all cells
    public enum SizingMode {
        /// Cells will have a fixed height
        case fixed(height: CGFloat)
        /// Cells should be calculated automatically using AutoLayout. If `isUniform == true` only the first cell will be sized, which will then be used for all subsequent cells.
        case automatic(isUniform: Bool)
        /// Cells will be sized using an aspect ratio, using the `width` value as a reference. E.g. `height == width * ratio`
        case aspect(ratio: CGFloat)
    }

    /// The total number of columns
    public let columnCount: Int

    /// The sizing mode to use for sizing cells
    public let sizingMode: SizingMode

    /// The metrics used for calculating column widths
    public let metrics: CollectionFlowLayoutMetrics

    /// The prototype cell to use for sizing
    public let prototype: UICollectionReusableView?

    /// Makes a new strategy
    /// - Parameters:
    ///   - prototype: The prototype cell to use for sizing
    ///   - columnCount: The number of columns
    ///   - sizingMode: The sizing mode to use for sizing
    ///   - metrics: The metrics to use for calculating column widths
    public init(prototype: UICollectionReusableView?, columnCount: Int, sizingMode: SizingMode, metrics: CollectionFlowLayoutMetrics) {
        if case .automatic = sizingMode, prototype == nil {
            fatalError("Prototype cannot be nil when setting `sizingMode == .automatic`")
        }

        self.prototype = prototype
        self.columnCount = columnCount
        self.sizingMode = sizingMode
        self.metrics = metrics
    }

    private var cachedSizes: [Int: CGSize] = [:]
    private func cachedSize(forElementAt index: Int) -> CGSize? {
        switch sizingMode {
        case .aspect:
            return cachedSizes[index]
        case .fixed:
            return cachedSizes.values.first
        case let .automatic(isUniform):
            return isUniform ? cachedSizes.values.first : cachedSizes[index]
        }
    }

    /// Returns the size required for the cell at the specified index
    /// - Parameters:
    ///   - index: The index of the cell
    ///   - environment: The current environent
    /// - Returns: The required size for the cell at the specified index
    open func size(forElementAt index: Int, environment: CollectionFlowLayoutEnvironment) -> CGSize {
        if let size = cachedSize(forElementAt: index) { return size }

        var width: CGFloat {
            let interitemSpacing = CGFloat(columnCount - 1) * metrics.minimumInteritemSpacing
            let availableWidth = environment.contentSize.width
                - metrics.contentInsets.left - metrics.contentInsets.right
                - interitemSpacing
            return (availableWidth / CGFloat(columnCount)).rounded(.down)
        }

        switch sizingMode {
        case let .aspect(ratio):
            let size = CGSize(width: width, height: width * ratio)
            cachedSizes[index] = size
            return size
        case let .fixed(height):
            let size = CGSize(width: width, height: height)
            cachedSizes[index] = size
            return size
        case .automatic:
            let targetView: UIView?
            let targetSize = CGSize(width: width, height: 0)

            if let cell = prototype as? UICollectionViewCell {
                targetView = cell.contentView
            } else {
                targetView = prototype
            }

            let size = targetView?.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
                ?? .zero

            cachedSizes[index] = size
            return size
        }
    }

}

