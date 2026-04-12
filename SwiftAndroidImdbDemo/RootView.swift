import SwiftUI

struct RootView: View {
    @State private var selection: Int = UserDefaults.standard.integer(forKey: "initialTab")
    @State private var showDrawer = false
    @State private var drawerDestination: DrawerDestination?

    var body: some View {
        NavigationStack {
            ZStack {
                if let dest = drawerDestination {
                    drawerScreen(dest)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button { showDrawer = true } label: {
                                    Image(systemName: "line.3.horizontal")
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Back to Tabs") {
                                    drawerDestination = nil
                                }
                            }
                        }
                } else {
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button { showDrawer = true } label: {
                                Image(systemName: "line.3.horizontal")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showDrawer) {
                DrawerMenu { dest in
                    showDrawer = false
                    drawerDestination = dest
                }
                .presentationDetents([.medium])
            }
        }
    }

    @ViewBuilder
    private func drawerScreen(_ dest: DrawerDestination) -> some View {
        switch dest {
        case .countries:  CountriesScreen()
        case .continents: ContinentsScreen()
        case .languages:  LanguagesScreen()
        }
    }
}

// MARK: - Drawer

enum DrawerDestination: String, CaseIterable {
    case countries  = "Countries"
    case continents = "Continents"
    case languages  = "Languages"

    var icon: String {
        switch self {
        case .countries:  return "globe"
        case .continents: return "map"
        case .languages:  return "character.book.closed"
        }
    }
}

struct DrawerMenu: View {
    let onSelect: (DrawerDestination) -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("GraphQL Features") {
                    ForEach(DrawerDestination.allCases, id: \.self) { dest in
                        Button {
                            onSelect(dest)
                        } label: {
                            Label(dest.rawValue, systemImage: dest.icon)
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}
