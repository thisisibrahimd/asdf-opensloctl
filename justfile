
test: install-plugin install-tool

install-plugin:
	mise plugin install opensloctl https://github.com/thisisibrahimd/asdf-opensloctl.git#$(git log -n 1 --format="%H") --force

install-tool VERSION="latest":
	mise install --verbose opensloctl@{{VERSION}}

