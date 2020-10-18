# LocalCA

Create a custom Certificate Authority to allow HTTPS on local development

## Purpose

Certain web apps and protocols only work over HTTPS, and while this is a trivial matter on a remote server since the advent of Let's Encrypt, the case is not as simple on local development environments.

It is possible to use self-signed certificates locally, but the DX suffers greatly since all browsers constantly complain and require manually adding exceptions for self-signed certificates.

One workaround is to create a custom Certificate Authority on the local machine, add it manually to the browser(s) and then use it so sign a few wildcard certificates. Depending on the exact local development workflow, those certificates can then be included in the development environment therefore enabling HTTPS without browser warnings.

## Requirements

This script relies on the `openssl` and `ca-certificates` packages that should be included in Ubuntu based distributions. Support for other libraries and OSes is out of scope for the time being. If you need it, fork it :)

## Installation

First grab the script and have a look at what is included:

    git clone https://github.com/tiagosimoes-euf/LocalCA.git
    cd LocalCA/ && ls -hAl

Copy the example config file and edit the active config file.

    cp example.lca.cfg lca.cfg
    nano lca.cfg

Make the main script and the helper scripts executable.

## Usage

*TBD*

## Recipes

Some common use cases are included in the documentation; read them and adapt them to your particular needs.
