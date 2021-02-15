//
//  NodeView.swift
//  GKPlayground
//
//  Created by Duncan on 2/10/19.
//  Copyright © 2019 Duncan. All rights reserved.
//

import Cocoa

/**
 `NodeView` instances are used in conjunction with `NodeMapView` to illustrate connections between
 concepts.
 */
open class NodeView: NSView
{
  // MARK: Constants
	/// The mininum width and height for a `NodeView`.
	public static let minSize = CGSize(width: 100.0, height: 32.0)
	/// The maximum width and height for a `NodeView`.
	public static let maxSize = CGSize(width: 200.0,  height: 178.0)
	/// The vertical distance between connection line on either side of a `NodeView`.
	public static let connectionSpacing: CGFloat = 16.0
	// MARK: -
	/// The global `CAConstraintLayoutManager` used to layout all `NodeView` sublayers.
	private static let nodeConstraintLayoutManager = CAConstraintLayoutManager()
	
	// MARK: -
	/// The spacing on each side between the text of the `NodeView` and its borders
	open var padding = NSEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
	//MARK: -
	// TODO: Store name in CATextLayer as NSAttributedString? (I: 🔅)
	/// The displayed name of the `NodeView`.
	public var name: String?
	{
		get
		{
			return self.nameLayer.string as? String
		}
		set
		{
			self.nameLayer.string = newValue
			self.resizeNode()
		}
	}
	/// The text style attributes used to display the `NodeView` instance's `name`.
	public var nameAttributes: [NSAttributedString.Key : Any]
	{
		get
		{
			let currentFont = (self.nameLayer.font as? NSFont) ??
				NSFont.boldSystemFont(ofSize: self.nameLayer.fontSize)
			let font = NSFont(descriptor: currentFont.fontDescriptor, size: self.nameLayer.fontSize)
			return [.font               : font ?? currentFont,
					.foregroundColor    : self.nameLayer.foregroundColor ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
		}
		set
		{
			// TODO: Support other font classes (I: 🔆)
			if let newFont = newValue[.font] as? NSFont
			{
				self.nameLayer.font = newFont
			}
			if let newFontSize = (newValue[.font] as? NSFont)?.pointSize
			{
				self.nameLayer.fontSize = newFontSize
			}
			// TODO: Test for no `.foregroundColor` key (I: 🔆)
			let newColor = (newValue[.foregroundColor] as! CGColor)
			self.nameLayer.foregroundColor = newColor
		}
	}
	// TODO: Make weak collections (I: 🔆)
	/// An ordered array of all views with connections leading into this `NodeView`.
	public var inConnections    = [NodeView]()
	{
		didSet
		{
			self.sortConnections(in: &self.inConnections)
			self.resizeNode()
		}
	}
	/// An ordered array of all views with connections from this `NodeView`
	public var outConnections   = [NodeView]()
	{
		didSet
		{
			self.sortConnections(in: &self.outConnections)
			self.resizeNode()
		}
	}
	/// The `NodeMapView` that contains this `NodeView`.
	public var nodeMapView: NodeMapView? { return self.superview as? NodeMapView }
	
	// MARK: -
	/// The sublayer used to display this `NodeView` instance's `name`.
	private var nameLayer = CATextLayer()
	/// The `name` of this `NodeView` with the display attributes applied, as a
	/// `NSAttributedString`.
	private var nameAttributedString: NSAttributedString?
	{
		guard let name = self.name else { return nil }
		return NSAttributedString(string: name, attributes: self.nameAttributes)
	}
	/// The distance the cursor is from this `NodeView` instance's origin while it is being dragged.
	/// Used to set position during a drag operation.
	private var dragOffset: CGPoint?
	
	// MARK: - Initializers
	/**
	 Creates a new `NodeView` with the given name.
	
	 - Parameter initialName: The name of the new `NodeView`
	
	 - Returns: A newly initialized `NodeView` with the given name.
	 */
	convenience init(withName initialName: String?)
	{
		let frame = CGRect(origin: .zero, size: NodeView.minSize)
		self.init(frame: frame)
		self.name = initialName
	}
	
	override init(frame frameRect: NSRect)
	{
		super.init(frame: frameRect)
//      Initialize layers
		self.wantsLayer = true
		self.layer = NodeView.newNodeLayer()
		self.nameLayer = self.newNameLayer()
		self.layer?.addSublayer(self.nameLayer)
		// TODO: Versus (I: 🔅)
//        let layer = NodeView.newNodeLayer()
//        let nameLayer = self.newNameLayer()
//        layer.addSublayer(self.nameLayer)
//        self.layer = layer
//        self.nameLayer = nameLayer
	}
	
	// TODO: Implement (I: 🔆)
	required public init?(coder decoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	/**
	 Returns a new `CALayer` formatted for display a node.
	
	 - Returns: A `CALayer` with the default parameters for representing a node.
	 */
	class open func newNodeLayer() -> CALayer
	{
		let nodeLayer = CALayer()
		let nodeColor: CGColor = #colorLiteral(red: 0.1160337528, green: 0.8740647007, blue: 0.940814124, alpha: 1)
		
		nodeLayer.cornerRadius      = 8.0
		nodeLayer.borderWidth       = 1.0
		nodeLayer.borderColor       = nodeColor
		nodeLayer.backgroundColor   = nodeColor.copy(alpha: 0.35)
		nodeLayer.layoutManager     = NodeView.nodeConstraintLayoutManager
		
		return nodeLayer
	}
	
	// MARK: -
	// TODO: static (I: 🔅)
	/**
	 Returns a new `CALayer` formatted for display the name of a node.
	
	 - Returns: A `CALayer` with the default parameters for a `NodeView` instance's label sublayer.
	 */
	open func newNameLayer() -> CATextLayer
	{
		let nameLayer = CATextLayer()
		nameLayer.font              = NSFont.boldSystemFont(ofSize: 12.0)
		nameLayer.fontSize          = 12.0
		nameLayer.alignmentMode     = .center
		nameLayer.truncationMode    = .end
		nameLayer.foregroundColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		// TODO: Adjust on padding set (make padding computed property based on offsets of constriants?) (I: 🔅)
		nameLayer.addConstraint(CAConstraint(attribute:     .minX,
											 relativeTo:    "superlayer",
											 attribute:     .minX,
											 offset:        self.padding.left))
		nameLayer.addConstraint(CAConstraint(attribute:     .maxX,
											 relativeTo:    "superlayer",
											 attribute:     .maxX,
											 offset:        -self.padding.right))
		nameLayer.addConstraint(CAConstraint(attribute:     .midY,
											 relativeTo:    "superlayer",
											 attribute:     .midY))
		return nameLayer
	}
	
	// MARK: -
	// TODO: Combine `inPoint`, `outPoint`, `connectionY` with enum param for direction (I: 🔅)
	/**
	 For a given `NodeView`, returns the point, in this containing `NodeMapView` instance's
	 coordinate space, where that view points to this `NodeView`.
	
	 - Parameter view: The incoming `NodeView`.
	
	 - Returns: The connection point on this `NodeView` as a `CGPoint` or nil if there is no
				connection.
	 */
	public func inPoint(forView view: NodeView) -> CGPoint?
	{
		guard let connectionY = self.connectionY(ofView:                view,
												 forConnectionArray:    self.inConnections)
			else { return nil }
		return CGPoint(x: self.frame.minX, y: connectionY)
	}
	
	/**
	 Returns the point, in this containing `NodeMapView` instance's coordinate space, where this
	 view connects to the given `NodeView`.
	
	 - Parameter view: The outgoing `NodeView`.
	
	 - Returns: The connection point on this `NodeView` as a `CGPoint` or nil if there is no
				connection.
	 */
	public func outPoint(forView view: NodeView) -> CGPoint?
	{
		guard let connectionY = self.connectionY(ofView:                view,
												 forConnectionArray:    self.outConnections)
			else { return nil }
		return CGPoint(x: self.frame.maxX, y: connectionY)
	}
	
	// MARK: -
	/**
	 Sorts the passed `NodeView` array so that any connections to the current instance is the first
	 item.
	
	 - Parameter connections: The `NodeView` array to sort.
	 */
	private func sortConnections(in connections: inout [NodeView])
	{
		if let selfIndex = connections.firstIndex(of: self)
		{
			let selfConnection = connections.remove(at: selfIndex)
			connections.insert(selfConnection, at: 0)
		}
	}
	
	/**
	 Calculates the vertical position for a node connection for given `NodeView` and collection of
	 connections.
	
	 - Parameter view:              The referenced `NodeView`.
	 - Parameter connectionArray:   The `NodeView` array representing the desired side.
	
	 - Returns: A `CGFloat` for the expected vertial position of the desired node connection.
				Returns `nil` if the view is not found in the provide array.
	 */
	private func connectionY(ofView view: NodeView,
							 forConnectionArray connectionArray: [NodeView])
		-> CGFloat?
	{
		guard let viewIndex = connectionArray.firstIndex(of: view) else { return nil }
		return self.frame.minY
			+ (self.layer?.cornerRadius ?? 0.0)
			+ (NodeView.connectionSpacing * CGFloat(viewIndex))
	}
	
	/**
	 Move this 'NodeView` to within the bounds of its superview through animation.
	 */
	private func repositionNode()
	{
		guard let nodeMapView = self.nodeMapView else { return }
		let newOrigin = CGPoint(x: max(self.frame.origin.x,
									   (nodeMapView.margins.left + NodeMapView.arrowClearance)),
								y: max(self.frame.origin.y,
									   (nodeMapView.margins.top + NodeMapView.arrowClearance)))
		guard newOrigin != self.frame.origin else { return }
		let newRect = CGRect(origin: newOrigin, size: self.frame.size)
		
//  Make move animations
		let moveAnimations : [NSViewAnimation.Key : Any] = [.startFrame:    self.frame,
															.endFrame:      newRect,
															.target:        self]
		let repositionAnimation = NSViewAnimation(viewAnimations: [moveAnimations])
		repositionAnimation.duration = 0.23
		repositionAnimation.delegate = self
		repositionAnimation.start()
	}
	
	/**
	 Resize this `NodeView` to accommodate its name and the number of connections on either side.
	 The size will not exceed `NodeView.maxSize`, nor go below `NodeView.minSize`.
	 */
	private func resizeNode()
	{
//  Calculate height based on the most number of connections on a side
		let maxConnectionPerSide    = max(self.inConnections.count, self.outConnections.count)
		let currentBorderWidth      = self.layer?.borderWidth ?? 0.0
		let currentCornerRadius     = self.layer?.cornerRadius ?? 0.0
		let nodeHeight =
			2.0 * (currentCornerRadius + currentBorderWidth)
				+ (CGFloat(max(maxConnectionPerSide - 1, 0)) * NodeView.connectionSpacing)
//  Calculate width based on node name
		let maxStringSize = self.nameAttributedString?.size() ?? .zero
		let nodeWidth = ceil(maxStringSize.width)
			+ self.padding.left
			+ self.padding.right
		self.frame.size = CGSize(
			width:  nodeWidth.clamped(to: NodeView.minSize.width...NodeView.maxSize.width),
			height: nodeHeight.clamped(to: NodeView.minSize.height...NodeView.maxSize.height))
//  Recalculate name layer height
		self.nameLayer.frame.size.height = maxStringSize.height
		
		self.nodeMapView?.refresh()
	}
	
	// MARK: - NSResponder methods
	override open func mouseDown(with event: NSEvent)
	{
		guard let startingDragPosition = self.superview?.convert(event.locationInWindow, from: nil)
			else { return }
		// TODO: Delta instead of offset (+ vs -) (I: 🔅)
		self.dragOffset = startingDragPosition - self.frame.origin
	}
	
	override open func mouseDragged(with event: NSEvent)
	{
		guard   let dragOffset = self.dragOffset,
			let currentDragLocation = self.superview?.convert(event.locationInWindow, from: nil)
			else { return }
		self.frame.origin = currentDragLocation - dragOffset
		
		self.nodeMapView?.refresh()
	}
	
	override open func mouseUp(with event: NSEvent)
	{
		self.dragOffset = nil
		
		self.repositionNode()
	}
}

// MARK: NSAnimationDelegate conformance
extension NodeView: NSAnimationDelegate
{
  public func animation(_ animation: NSAnimation,
							valueForProgress progress: NSAnimation.Progress)
		-> Float
	{
		self.nodeMapView?.refresh()
		return progress
	}
}
