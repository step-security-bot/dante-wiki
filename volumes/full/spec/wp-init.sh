#!/bin/sh

# This is an idempotent script which initializes a wiki installation existing on a directory of volume
# If the wiki is already installed, it does not break anything

# It assumes a running configuration of a DB and an LAP container