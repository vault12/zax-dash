_This repository is discontinued: See https://github.com/vault12/zax-dashboard for the new reference dashboard implementation._

# Zax-Dash

Zax-Dash is a simple AngularJS single page app to interact with [Zax Relay](https://github.com/vault12/zax), a [NaCl-based Cryptographic Relay](https://s3-us-west-1.amazonaws.com/vault12/zax_infogfx.jpg). Zax-Dash uses the [Glow](https://github.com/vault12/glow) library to provide a user-friendly access point to given relay internal mailboxes. We maintain a live [Test Server](https://zax-test.vault12.com) that runs our latest build. For testing purposes expiration of any communication on that relay is set for 30 minutes. You can read the full [technical specification here](http://bit.ly/nacl_relay_spec).

## Dashboard
The default Zax-Dash deployment is included in the Zax repository and can be accessed via `/public`. You do not need to clone this repository to have the dashboard functionality included on your Zax server.

## Getting Started

#### NodeJS
In order to build and use Zax-Dash from source, you need to have a relatively recent version of nodeJS installed.

#### Installation
In a terminal, navigate to the directory in which you'd like to install Zax-Dash and type the following:

```Shell
# get the source
git clone git@github.com:vault12/zax-dash.git

# install dependencies
cd zax-dash
npm install

# run the build script
node_modules/gulp/bin/gulp.js build
```

#### Running Zax
To connect to your relay, first make sure that it is running on `localhost:8080` via `rails s -p 8080`.

Alternatively, you can modify the `relayUrl`  method in `crypto.service.coffee` to use an alternate relay or to use Zax-dash in standalone mode.

To run Zax-Dash locally (outside of a Zax instance) run this command:

```Shell
node_modules/gulp/bin/gulp.js watch
```
​
Note that if you have [Gulp](https://github.com/gulpjs/gulp) installed globally, you can also simply type:
​
```Shell
gulp watch
```

## Contributing
We encourage you to contribute to Zax-Dash using [pull requests](https://github.com/vault12/zax-dash/pulls)! Please check out the [Contributing to Zax Guide](CONTRIBUTING.md) for guidelines about how to proceed.

## Slack Community [![Slack Status](https://slack.vault12.com/badge.svg)](https://slack.vault12.com)
We've set up a public slack community [Vault12 Dwellers](https://vault12dwellers.slack.com/). Request an invite by clicking [here](https://slack.vault12.com/).

## License
Zax-Dash is released under the [MIT License](http://opensource.org/licenses/MIT).

## Legal Reminder
Exporting/importing and/or use of strong cryptography software, providing cryptography hooks, or even just communicating technical details about cryptography software is illegal in some parts of the world. If you import this software to your country, re-distribute it from there or even just email technical suggestions or provide source patches to the authors or other people you are strongly advised to pay close attention to any laws or regulations which apply to you. The authors of this software are not liable for any violations you make - it is your responsibility to be aware of and comply with any laws or regulations which apply to you.
