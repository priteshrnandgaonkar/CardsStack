# CardStack [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


CardStack converts your `UICollectionView` to an awesome stack of cards using custom `UICollectionViewLayout`, written in Swift 3.

## What is CardStack? 💫 ✨💥⭐️

Talk is cheap, lets look at the gif. 

![Basic Interaction](Documentation/BasicCardStackInteraction.gif)


The Basic interaction with the CardStack is dragging up the cards till they are unraveled. But hold on, for the impatient users, there is one more interaction, you can drag a little and the cards will unwind or wind.

![Lazy Interaction](Documentation/LazyInteraction.gif)


## How to use it?

There are 4 basic components required by CardStack to function. To initialise the `CardsStack` it needs the `CardsPosition`, `Configuration` along with `UICollectionView` and its height constraint i.e `NSLayoutConstraint` 

Initialise `CardsStack` as follows

``` swift
let config = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: 500, cardHeight: 200, downwardThreshold: 20, upwardThreshold: 20, leftSpacing: 8.0, rightSpacing: 8.0, verticalSpacing: 8.0)
let cardsStack = CardsStack(cardsState: .Collapsed, configuration: config, collectionView: collectionView, collectionViewHeight: heightConstraint)

```
### Configuration

`Configuration` object holds the information related to Stacks view, like the collapsed height, expanded height etc.

``` swift
public struct Configuration {
    public let cardOffset: Float
    public let collapsedHeight:Float
    public let expandedHeight:Float
    public let cardHeight: Float
    public let downwardThreshold: Float
    public let upwardThreshold: Float
    public let verticalSpacing: Float
    public let leftSpacing: Float
    public let rightSpacing: Float
    
    public init(cardOffset: Float, collapsedHeight: Float, expandedHeight: Float, cardHeight: Float, downwardThreshold: Float = 20, upwardThreshold: Float = 20, leftSpacing: Float = 8.0, rightSpacing: Float = 8.0, verticalSpacing: Float = 8.0) {
        self.cardOffset = cardOffset
        self.collapsedHeight = collapsedHeight
        self.expandedHeight = expandedHeight
        self.downwardThreshold = downwardThreshold
        self.upwardThreshold = upwardThreshold
        self.cardHeight = cardHeight
        self.verticalSpacing = verticalSpacing
        self.leftSpacing = leftSpacing
        self.rightSpacing = rightSpacing
    }
}

```

Its initialiser requires the necessary fields like `cardOffset`, `collapsedHeight`, `expandedHeight` and `cardHeight`

1. `cardOffset` is the offset between thetwo cards while in collapsed state
2. `collapsedHeight`, as name suggests its the height of the collectionview while in collapsed state
3. `expandedHeight` is the height of the collectionview while in expanded state
4. `cardHeight` is the height of the cell

### CardsPosition

Its an enum which states the current state of CardsStack

``` swift
@objc public enum CardsPosition: Int {
    case Collapsed
    case Expanded
}

```

## CardsManagerDelegate

With this delegate you can get the hooks to specific events

``` swift

@objc public protocol CardsManagerDelegate {
    
    @objc optional func cardsPositionChangedTo(position: CardsPosition)
    @objc optional func tappedOnCardsStack(cardsCollectionView: UICollectionView)
    @objc optional func cardsCollectionView(_ cardsCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func cardsCollectionView(_ cardsCollectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
}

```
For listening to this call backs assign a delegate to `CardsStack`

``` swift
cardsStack.delegate = self
```

The last two functions are the same as the delegate function for collection view.

The first function gives the hook to the `CardStacks` position change

``` swift
@objc optional func cardsPositionChangedTo(position: CardsPosition) 
```

The CardStack also has the tap gesture which is enabled when the cards are collapsed.The second function gives the hook to the tap gesture on collectionview when the cards are in collapsed state.

So you can use this hook to open cards, like this

``` swift

func tappedOnCardsStack(cardsCollectionView: UICollectionView) {
        cardsStack.changeCardsPosition(to: .Expanded)
    }

```

In order to change the state of the cards programatically you can use

``` swift
public func changeCardsPosition(to position: CardsPosition) {

```

You can checkout the example and play around with it to get hang of the API's

## TODO
- [x] Carthage Support
- [ ] CocoaPods Support
- [ ] SwiftPM Support
- [ ] Watch, TvOS Targets 

## Contributions

Found a bug? Want a new feature? Please feel free to report any issue or raise a Pull Request.
