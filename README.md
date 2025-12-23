#  GSRouting
A light-weight Swift Package to improve the way different types of sheets and navigation destinations are presented, as well as
navigating between tabs.

# Getting started

## Step 1: Using `RoutableTabView`
RoutableTabView allows for programmatic navigation between tabs in the TabBar. It is recommended to set it up at the root of the app (in the `@main` annotated struct).
```swift
@main
struct AppView: App {
    
    var body: some Scene {
        WindowGroup {
            // 1. Register the available tab routes with `AppRouterView` in return for an instance of `AppTabRouter`.
            AppRouterView(tabs: [HomeTabRoute(), SettingsTabRoute()]) { tabRouter in
                // 2. Use the `AppTabRouter` to render `RoutableTabView`.
                RoutableTabView(tabRouter: tabRouter)
            }
        }
    }
}
```

### Creating a `TabRoute`:
A TabRoute conforming object represents a single tab, providing functions to render the label displayed in the tab bar,
as well as the content displayed when the tab is selected. 

**Note:** The `makeLabel` and `makeContent` functions are called when the state of the tab
changes, so it is possible to do things like changing the tab icon when selected/deselected etc.

**Important:** It's recommended to use the `.routable(_:AppNavigationRouter)` modifier in the `makeContent` function for TabRoute implementations, as this
will establish a link between the tab's navigation stack and the `AppTabRouter` instance (from step 1), allowing control over navigation operations for this tab from outside the context of this tab. Will discuss this further, but
first let's move onto step 2.
```swift
struct HomeTabRoute: TabRoute {
    let id: String = "home"
    
    func makeLabel(context: Context) -> some View {
        Label("Home", systemImage: context.isSelected ? "house.fill" : "house")
    }
    
    func makeContent(context: Context) -> some View {
        HomeContainerView().routable(context.router)
    }
}
```

## Step 2: Navigating to & presenting views.
All navigation operations can be performed by interacting with the injected instance of `AppNavigationRouter`. This can be done by a property marked with `@Router` in a SwiftUI view.

**Important:** It's important the parent view applies the `.routable()` modifier which injects the router and enables navigation functionality.

### Usage of `@Router`:
```swift
struct MyViewSomewhereInTheApp: View {
    @Router private var router

    var body: some View {
      VStack {
        Button("Go to next page") {
         router.push(.anotherPage)
        }

        Button("Present a sheet") {
         router.presentSheet(.someSheet)
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
```swift
struct MyViewRoute: ViewRoute {
    func makeBody(context: Context) -> some View {
      MyView()
    }
}
```

For convenience, an extension on `ViewRoute` can be made to declare the route as a property, so XCode will suggest our custom `ViewRoute` in the auto-complete window that appears when typing.
```swift
extension ViewRoute where Self == MyViewRoute {
   var myView: Self { .init() }
}
```

That allows for this syntax to work:
```swift
router.push(.myView)
```

## Controlling navigation from outside of a tab
In some cases you may want to switch to a tab, then push onto it's stack from outside the context of that tab. For example, maybe you are using iOS 26's' `tabViewBottomAccessory` which requires you to attach it to a `TabView`
to work. You may have some controls in that bottom accessory view which should switch active tabs and/or push onto the active tab's navigation stack. It can be done like this:
```swift
@main
struct AppView: App {
    
    var body: some Scene {
        WindowGroup {
            AppRouterView(tabs: [HomeTabRoute(), SettingsTabRoute()]) { tabRouter in
                RoutableTabView(tabRouter: tabRouter)
                    .tabViewBottomAccessory {
                        Button("Go to settings tab, and push into one of the sub pages") {
                            // 1. Use tabRouter instance to switch to the settings tab.
                            tabRouter.switchTab(id: "settings_id")
                            // 2. Push onto it's nav stack.
                            tabRouter.navigationRouterForTab(id: "settings_id").push(AdvancedSettingsRoute())
                        }
                    }
                }
            }
        }
    }
}
```
In that example, `tabViewBottomAccessory` is attached to the `RoutableTabView` inside the `AppRouterView` block, so it has access to `AppTabRouter` and can use it to switch tabs and/or control navigation
of any tab.
