SHELL = /bin/bash
PROJECT = Kakico.xcworkspace
TEST_TARGET = KakicoTests
OS = 8.4
DEVICE = iPhone 6

test:
	set -o pipefail && \
	xcodebuild -workspace $(PROJECT) \
		-scheme $(TEST_TARGET) \
		-sdk iphonesimulator \
		-configuration Debug \
		-destination platform='iOS Simulator',OS=$(OS),name='$(DEVICE)' \
		clean test | \
		bundle exec xcpretty -c

debug-test:
	xcodebuild -workspace $(PROJECT) \
		-scheme $(TEST_TARGET) \
		-sdk iphonesimulator \
		-configuration Debug \
		-destination platform='iOS Simulator',OS=$(OS),name='$(DEVICE)' \
		clean test

deploy:
	git checkout development && \
		git pull origin development && \
		bundle exec ipa build -w Kakico.xcworkspace -s Kakico && \
		bundle exec terminal-notifier -message 'Build Succeeded' && \
		bundle exec dgate push Kakico.ipa
