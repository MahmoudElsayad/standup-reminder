APP_NAME       := StandUpReminder
APP_BUNDLE     := $(APP_NAME).app
SOURCES_DIR    := Sources
BUILD_DIR      := .build
MACOS_DIR      := $(APP_BUNDLE)/Contents/MacOS
RESOURCES_DIR  := $(APP_BUNDLE)/Contents/Resources
SOURCES        := $(wildcard $(SOURCES_DIR)/*.swift)
EXECUTABLE     := $(MACOS_DIR)/$(APP_NAME)

SWIFTC         := swiftc
SDK_PATH       := $(shell xcrun --show-sdk-path --sdk macosx)
SWIFT_FLAGS    := -sdk $(SDK_PATH) \
                  -F $(SDK_PATH)/System/Library/Frameworks \
                  -framework AppKit \
                  -framework UserNotifications \
                  -framework SwiftUI \
                  -Xlinker -rpath -Xlinker /usr/lib/swift \
                  -target arm64-apple-macosx14.0 \
                  -parse-as-library \
                  -O

.PHONY: all build clean run install launchd-install launchd-uninstall help

all: build

build: $(APP_BUNDLE)

$(APP_BUNDLE): $(EXECUTABLE) Resources/Info.plist
	@echo "📦 Creating app bundle..."
	cp Resources/Info.plist $(APP_BUNDLE)/Contents/
	touch $(APP_BUNDLE)
	@echo ""
	@echo "✅ Build complete: $(APP_BUNDLE)"
	@echo ""
	@echo "To run: open $(APP_BUNDLE)"
	@echo "Or:     make run"
	@echo ""
	@echo "To auto-start on login:"
	@echo "  make launchd-install"
	@echo ""

$(EXECUTABLE): $(SOURCES)
	@echo "🔨 Compiling..."
	mkdir -p $(MACOS_DIR) $(RESOURCES_DIR)
	$(SWIFTC) $(SWIFT_FLAGS) -o $(EXECUTABLE) $(SOURCES)

clean:
	rm -rf $(APP_BUNDLE) $(BUILD_DIR)
	@echo "🧹 Cleaned"

run: build
	open $(APP_BUNDLE)

install: build
	@echo "📦 Installing to /Applications..."
	cp -R $(APP_BUNDLE) /Applications/
	@echo "✅ Installed to /Applications/$(APP_BUNDLE)"

launchd-install: install
	@echo "📋 Installing LaunchAgent for auto-start on login..."
	mkdir -p ~/Library/LaunchAgents
	sed 's|__APP_PATH__|/Applications/$(APP_BUNDLE)|g' com.standup.reminder.plist > ~/Library/LaunchAgents/com.standup.reminder.plist
	launchctl load ~/Library/LaunchAgents/com.standup.reminder.plist
	@echo "✅ Installed. The app will start automatically on login."
	@echo "To uninstall: make launchd-uninstall"

launchd-uninstall:
	launchctl unload ~/Library/LaunchAgents/com.standup.reminder.plist 2>/dev/null || true
	rm -f ~/Library/LaunchAgents/com.standup.reminder.plist
	@echo "✅ Uninstalled LaunchAgent"

help:
	@echo "StandUp Reminder — macOS Build"
	@echo ""
	@echo "  make build            Build the .app bundle"
	@echo "  make run              Build and launch the app"
	@echo "  make clean            Remove build artifacts"
	@echo "  make launchd-install  Auto-start on login"
	@echo "  make launchd-uninstall Remove auto-start"
