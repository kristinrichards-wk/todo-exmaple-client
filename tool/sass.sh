#!/usr/bin/env bash

set -e

sassc -t expanded lib/styles.scss lib/styles.css
