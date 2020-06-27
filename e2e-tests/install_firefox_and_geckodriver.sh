#!/bin/bash

function get_latest_github_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
        grep '"tag_name":' |
        sed -E 's/.*"([^"]+)".*/\1/'
}

geckodriver_version=$(get_latest_github_release mozilla/geckodriver)
geckodriver_url="https://github.com/mozilla/geckodriver/releases/download/${geckodriver_version}/geckodriver-${geckodriver_version}-linux64.tar.gz"

firefox_url="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=pl"

curl -L "${geckodriver_url}" | tar -xz -C /usr/local/bin/
curl -L "${firefox_url}" | tar -jx -C /usr/local
ln -s /usr/local/firefox/firefox /usr/local/bin/firefox
