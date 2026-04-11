import SwiftUI

/// Root TabView. Each tab hosts exactly one screen, and each screen
/// instantiates exactly one SDK viewmodel via `TMDBContainer.get<Name>ViewModel()`.
/// **No shared viewmodels. No wrappers.**
///
/// The initial tab can be overridden by setting the `initialTab` UserDefaults
/// key (0..4). Useful for screenshot automation:
///   xcrun simctl spawn booted defaults write io.github.erikg84.SwiftAndroidImdbDemo initialTab -int 2
struct RootView: View {
    @State private var selection: Int = UserDefaults.standard.integer(forKey: "initialTab")

    var body: some View {
        TabView(selection: $selection) {
            HomeScreen()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            MoviesScreen()
                .tabItem { Label("Movies", systemImage: "film") }
                .tag(1)

            TVShowsScreen()
                .tabItem { Label("TV", systemImage: "tv") }
                .tag(2)

            SearchScreen()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(3)

            TrendingScreen()
                .tabItem { Label("Trending", systemImage: "flame") }
                .tag(4)
        }
    }
}
