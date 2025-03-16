import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem?
    var hasOpenWindows = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusBarButton = statusBarItem?.button {
            let icon = createSwiftUIIcon(iconName: "append.page")
            statusBarButton.image = icon
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Open Window", action: #selector(openWindow), keyEquivalent: "O"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusBarItem?.menu = menu
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowDidClose(_:)), name: NSWindow.didCloseNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(windowDidOpen(_:)), name: NSWindow.didBecomeKeyNotification, object: nil)

    }
    
    func createSwiftUIIcon(iconName: String) -> NSImage {
        let swiftUIView = Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .foregroundColor(.white)

        let size = CGSize(width: 18, height: 18)
        
        let hostingController = NSHostingController(rootView: swiftUIView.foregroundColor(.black))

        let bitmapRep = hostingController.view.bitmapImageRepForCachingDisplay(in: NSRect(origin: .zero, size: size))!
        hostingController.view.cacheDisplay(in: NSRect(origin: .init(x: -9, y: -9), size: size), to: bitmapRep)

        let image = NSImage(size: size)
        image.addRepresentation(bitmapRep)

        return image
    }
    
    @objc func windowDidOpen(_ notification: Notification) {
        hasOpenWindows = true
        
        NSApplication.shared.setActivationPolicy(.regular)
    }

    @objc func windowDidClose(_ notification: Notification) {
        if NSApplication.shared.windows.isEmpty {
            hasOpenWindows = false
            NSApplication.shared.setActivationPolicy(.accessory)
        }
    }
    
    @objc func openWindow() {
        let window = NSWindow(contentViewController: NSViewController())
        window.makeKeyAndOrderFront(nil)
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
