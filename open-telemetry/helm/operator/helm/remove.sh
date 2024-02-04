#!/bin/bash

set -x
helm uninstall my-opentelemetry-operator -n opentelemetry-operator
set +x
