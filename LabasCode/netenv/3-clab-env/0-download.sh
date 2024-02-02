#!/bin/bash
set -v

bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.30.0
bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.42.0

