#  GSRouting
A light-weight Swift Package to improve the way different types of sheets and navigation destinations are presented, as well as
navigating between tabs.

# Getting started

## Step 1: Using `RoutableTabView`
RoutableTabView allows for programmatic navigation between tabs in the TabBar.
```
@main
struct AppView: App {
    
    var body: some Scene {
        WindowGroup {
            // Use `RoutableTabView` at the root of the app in the `@main` view.
            // Initialise it by passing in an array of routes, in the order you wish them to be displayed.
            RoutableTabView(tabs: [
              HomeTabRoute(),
              SettingsTabRoute()
            ])
        }
    }
}
```

### Creating a `TabRoute`:
A TabRoute conforming object represents a single tab, providing functions to render the label displayed in the tab bar,
as well as the content displayed when the tab is selected. 

**Note:** The `makeLabel` and `makeContent` functions are called when the state of the tab
changes, so it is possible to do things like changing the tab icon when selected/deselected etc.

**Important:** It's recommended to use the `.routable()` modifier in the `makeContent` function for each tab, which allows
navigation to work within it's subviews.

```
struct HomeTabRoute: TabRoute {
    let id: String = "home"
    
    func makeLabel(context: Context) -> some View {
        Label("Home", systemImage: context.isSelected ? "house.fill" : "house")
    }
    
    func makeContent(context: Context) -> some View {
        HomeContainerView().routable()
    }
}
```

## Step 2: Navigating to & presenting views.
All navigation operations can be performed by interacting with the injected instance of `AppNavigationRouter`. This can be done by a property marked with `@Router` in a SwiftUI view.

**Important:** It's important the parent view applies the `.routable()` modifier which injects the router and enables navigation functionality.

### Usage of `@Router`:

```
struct MyViewSomewhereInTheApp: View {
    @Router private var router

    var body: some View {
      VStack {
        Button("Go to next page") {
         router.push(.anotherPage)
        }

        Button("Present a sheet") {
         router.push(.someSheet)
        }

        Button("Go back 1 page") {
         router.pop()
        }

        Button("Go back to start") {
         router.popToRoot()
        }

        Button("Present full screen cover") {
         router.presentCover(.someCover)
        }

        Button("Go to settings tab") {
         router.switchTab(id: "settings")
        }
      }
    }
}
```

### Creating a `ViewRoute` for presentation/navigation:
A ViewRoute declaration allows for presenting and navigating to the view returned in it's `makeBody` function.
ViewRoutes are passed into functions on the router like `push(_:), presentSheet(_:)`, etc.
```
struct MyViewRoute: ViewRoute {
    func makeBody(context: Context) -> some View {
      MyView()
    }
}
```

For convenience, an extension on `ViewRoute` can be made to declare the route as a property, so XCode will suggest our custom `ViewRoute` in the auto-complete window that appears when typing.
```
extension ViewRoute where Self == MyViewRoute {
   var myView: Self { .init() }
}
```

That allows for this syntax to work:
```
router.push(.myView)
```
