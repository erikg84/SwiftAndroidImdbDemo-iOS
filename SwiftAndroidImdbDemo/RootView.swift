import SwiftUI

/// Root TabView. Each tab hosts exactly one screen, and each screen
/// instantiates exactly one SDK viewmodel via `TMDBContainer.get<Name>ViewModel()`.
/// **No shared viewmodels. No wrappers.**
struct RootView: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem { Label("Home", systemImage: "house") }

            MoviesScreen()
                .tabItem { Label("Movies", systemImage: "film") }

            TVShowsScreen()
                .tabItem { Label("TV", systemImage: "tv") }

            SearchScreen()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            TrendingScreen()
                .tabItem { Label("Trending", systemImage: "flame") }
        }
    }
}
