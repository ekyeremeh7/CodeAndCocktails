run:
	@echo "[+] Running app"
	fvm flutter run
clean:
	@echo "[+] Cleaning dependencies"
	fvm flutter clean
	fvm flutter pub get

split-apk:
	@echo "[+] Cleaning dependencies"
	fvm flutter clean
	fvm flutter pub get
	@echo "[+] Building split apk"
	fvm flutter build apk --split-per-abi

universal:
	@echo "[+] Cleaning dependencies"
	fvm flutter clean
	fvm flutter pub get
	@echo "[+] Building universal apk"
	fvm flutter build apk --release 

# Clean iOS dependencies
_ios-clean:
	@echo "[+] Cleaning iOS dependencies..."
	@cd ios/ && rm -rf Podfile.lock Pods

_ios-pod-install:
	@echo "[+] Installing iOS pods..."
	@cd ios/ && pod install
	@echo "[+] Pods installed successfully"

ipa-prod-testflight: _ios-clean
	@echo "[+] Building production IPA for TestFlight..."
	@$(MAKE) _ios-pod-install
	fvm flutter clean
	fvm flutter pub get
	fvm flutter build ipa --release
	@echo "[+] Uploading to TestFlight via App Store Connect API..."
	xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey 3995SSD6VR --apiIssuer 975dbc96-75bf-4396-b398-a5b7fc4417f0 
	@echo "[+] Upload completed successfully!"


# Production App Bundle for Internal Testing
bundle-prod-internal:
	@echo "[+] Building production App Bundle for Internal Testing..."
	fvm flutter clean
	fvm flutter pub get
	fvm flutter build appbundle --release
	@echo "[+] App Bundle built successfully at: build/app/outputs/bundle/release/app-release.aab"
	@echo "[+] Ready for upload to Google Play Console Internal Testing track"	