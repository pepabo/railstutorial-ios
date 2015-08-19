SHELL = /bin/bash
PROJECT = FoodTracker.xcodeproj
TEST_TARGET = FoodTrackerTests
OS = 8.4
DEVICE = iPhone 6

test:
	set -o pipefail && \
	xcodebuild -project $(PROJECT) \
		   -scheme $(TEST_TARGET) \
		   -sdk iphonesimulator \
		   -configuration Debug \
		   -destination platform='iOS Simulator',OS=$(OS),name='$(DEVICE)' \
		   clean test | \
		   bundle exec xcpretty -c
