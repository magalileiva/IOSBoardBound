import SwiftUI

var secondaryColor: Color = Color(.lightGreen)

struct MenuItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
}

var userActions: [MenuItem] = [
    MenuItem(id: 4001, icon: "game", text: "Juegos"),
    MenuItem(id: 4002, icon: "match", text: "Partidas")
]

var profileActions: [MenuItem] = [
    MenuItem(id: 4003, icon: "profile", text: "Perfil"),
    MenuItem(id: 4005, icon: "logout", text: "Logout")
]

struct SideMenu: View {
    @Binding var isSidebarVisible: Bool
    @Binding var currentScreen: Screen?
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.6
    var menuColor: Color = Color(.darkGreen)
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture {
                isSidebarVisible.toggle()
            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                menuColor
                MenuChevron
                
                VStack(alignment: .leading, spacing: 20) {
                    userProfile
                    Divider()
                    MenuLinks(items: userActions, currentScreen: $currentScreen, isSidebarVisible: $isSidebarVisible)
                    Divider()
                    MenuLinks(items: profileActions, currentScreen: $currentScreen, isSidebarVisible: $isSidebarVisible)
                }
                .padding(.top, 80)
                .padding(.horizontal, 40)
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSidebarVisible)
            
            Spacer()
        }
    }
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(menuColor)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: isSidebarVisible ? -18 : -10)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }
            
            Image(systemName: "chevron.right")
                .foregroundColor(secondaryColor)
                .rotationEffect(isSidebarVisible ? Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: isSidebarVisible ? -4 : 8)
                .foregroundColor(.blue)
        }
        .offset(x: sideBarWidth / 2, y: 80)
        .animation(.default, value: isSidebarVisible)
    }
    
    var userProfile: some View {
        VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(UserDefaults.standard.string(forKey: "username")!)
                        .bold()
                        .font(.title3)
                    Text(UserDefaults.standard.string(forKey: "email")!)
                        .foregroundColor(secondaryColor)
                        .font(.caption)
                }
            }
            .padding(.bottom, 20)
        }
    }

struct MenuLinks: View {
    var items: [MenuItem]
    @Binding var currentScreen: Screen?
    @Binding var isSidebarVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(items) { item in
                menuLink(icon: item.icon, text: item.text, currentScreen: $currentScreen, isSidebarVisible: $isSidebarVisible)
            }
        }
        .padding(.vertical, 14)
        .padding(.leading, 8)
    }
}

enum Screen {
    case Juegos
    case Partidas
    case Perfil
    case Logout
}

struct menuLink: View {
    var icon: String
    var text: String
    @Binding var currentScreen: Screen?
    @Binding var isSidebarVisible: Bool
    @EnvironmentObject var vm:LoginViewModel
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(secondaryColor)
                .padding(.trailing, 18)
            Text(text)
                .font(.body)
        }
        .onTapGesture {
            switch text {
                case "Juegos":
                    currentScreen = .Juegos
                case "Partidas":
                    currentScreen = .Partidas
                case "Perfil":
                    currentScreen = .Perfil
                case "Logout":
                    Task{ await vm.logOut() }
                default:
                    break
                }
            isSidebarVisible = false
        }
    }
}
