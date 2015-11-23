# Zax-dash

Zax-dash is a simple [AngularJS](https://s3-us-west-1.amazonaws.com/vault12/zax_infogfx.jpg) single page app to interact with your Zax relay. Zax-Dash uses [Glow](https://github.com/vault12/glow) to provide user-friend access point to given relay internal mailboxes. We maintain live [Test Server](https://zax_test.vault12.com) that runs our latest build. For testing purposes expiration on that relay is set for 30 minutes. Zax-dash is implemented using the the [Glow](https://github.com/vault12/glow) library. You can read the full [techinical specification here](http://bit.ly/nacl_relay_spec). t

## Dashboard
The default Zax-dash deployment is included in the Zax repository and can be accessed '/public' (via `/public`). You do not need to clone this repository to have the dashboard functionality included on your zax server.

## Getting Started

#### NodeJS
In order to build and use Zax-dash from source, you need to have a relatively recent version of nodeJS installed.

#### Installation
In a terminal, navigate to the directory in which you'd like to install Zax-dash and type the following:

```Shell
# get the source
git clone git@github.com:vault12/zax-dash.git

# install dependencies
cd zax-dash
npm install

# run the build script
gulp dist

# alternatively, you can use locally with the following command
gulp
```

If the 'bundle install' command fails with a message for libxml2 or Nokogiri, see the [Troubleshooting](#troubleshooting) section.

#### Running Zax

To run Zax-dash locally (outside of a Zax instance) run this command:

```Shell
gulp
```

#### Testing Zax-Dash

To run tests, use the following command.

```Shell
npm test
```

## Contributing
We encourage you to contribute to Zax-Dash using [pull requests](https://github.com/vault12/zax-dash/pulls)! Please check out the [Contributing to Zax Guide](CONTRIBUTING.md) for guidelines about how to proceed.

## Slack Community [![Slack Status](https://slack.vault12.com/badge.svg)](https://slack.vault12.com)
We've set up a public slack community [Vault12 Dwellers](https://vault12dwellers.slack.com/). Request an invite by clicking [here](https://slack.vault12.com/).

## License
Zax-Dash is released under the [MIT License](http://opensource.org/licenses/MIT).

## Legal Reminder
Exporting/importing and/or use of strong cryptography software, providing cryptography hooks, or even just communicating technical details about cryptography software is illegal in some parts of the world. If you import this software to your country, re-distribute it from there or even just email technical suggestions or provide source patches to the authors or other people you are strongly advised to pay close attention to any laws or regulations which apply to you. The authors of this software are not liable for any violations you make - it is your responsibility to be aware of and comply with any laws or regulations which apply to you.
