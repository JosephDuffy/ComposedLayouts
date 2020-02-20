import UIKit
import ComposedUI

/// Encapsulates the metrics for a section
public struct CollectionFlowLayoutMetrics {
    /// Represents the insets applied to the section
    public var contentInsets: UIEdgeInsets = .zero
    /// Represents the spacing between lines in a section
    public var minimumLineSpacing: CGFloat = 0
    /// Represets the spacing between items in a section
    public var minimumInteritemSpacing: CGFloat = 0

    public init() { }
}

/// Represents the current environment for a `UICollectionView`
public struct CollectionFlowLayoutEnvironment {
    /// Returns the current size of the collectionView
    public let contentSize: CGSize
    /// Returns the current traits of the collectionView
    public let traitCollection: UITraitCollection
}

/// Conform your section to this protocol to override sizing and metric values for a `UICollectionViewFlowLayout`
public protocol CollectionFlowLayoutHandler: CollectionSectionProvider {

    /// Return the size for the item at the specified index
    /// - Parameters:
    ///   - index: The index of the item
    ///   - suggested: A suggested value which is generally inherited from the layout itself
    ///   - environment: The current environment for this layout
    func sizeForItem(at index: Int, suggested: CGSize, environment: CollectionFlowLayoutEnvironment) -> CGSize

    /// Return the size for the header in this section
    /// - Parameters:
    ///   - suggested: A suggested value which is generally inherited from the layout itself
    ///   - environment: The current environment for this layout
    func referenceHeaderSize(suggested: CGSize, environment: CollectionFlowLayoutEnvironment) -> CGSize

    /// Return the size for the footer in this section
    /// - Parameters:
    ///   - suggested: A suggested value which is generally inherited from the layout itself
    ///   - environment: The current environment for this layout
    func referenceFooterSize(suggested: CGSize, environment: CollectionFlowLayoutEnvironment) -> CGSize

    /// Return the metrics to be applied to this section
    /// - Parameters:
    ///   - suggested: A suggested value which is generally inherited from the layout itself
    ///   - environment: The current environment for this layout
    func layoutMetrics(suggested: CollectionFlowLayoutMetrics, environment: CollectionFlowLayoutEnvironment) -> CollectionFlowLayoutMetrics
    
}

// Default implementations
public extension CollectionFlowLayoutHandler {
    func sizeForItem(at index: Int, suggested: CGSize, environment: CollectionFlowLayoutEnvironment) -> CGSize { return suggested }
    func referenceHeaderSize(suggested: CGSize, environment: CollectionFlowLayoutEnvironment) -> CGSize { return suggested }
    func referenceFooterSize(suggested: CGSize, environment: CollectionFlowLayoutEnvironment) -> CGSize { return suggested }
    func layoutMetrics(suggested: CollectionFlowLayoutMetrics, environment: CollectionFlowLayoutEnvironment) -> CollectionFlowLayoutMetrics { return suggested }
}
