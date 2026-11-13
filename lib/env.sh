#!/usr/bin/env bash
# All immutable or rarely‑changing environment variables live here.

# Configuration
# DEFAULT_FLAGS is loaded from file in main.sh, don't reset it here

# Docker and user settings
readonly DOCKER_USER="claude"
readonly USER_ID=$(id -u)
readonly GROUP_ID=$(id -g)

# Directories and paths
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
readonly LINK_TARGET="$HOME/.local/bin/claudebox"
export CLAUDEBOX_HOME="${HOME}/.claudebox"

# Version constants
readonly NODE_VERSION="--lts"
readonly DELTA_VERSION="0.17.0"

# Optional upstream proxy for container egress.
# When set, init-firewall allows only this proxy address and drops everything
# else (killswitch): no proxy -> no network, never a direct fallback.
# Can be set via environment or by putting the URL on the first line of
# ~/.claudebox/proxy. Example: http://172.39.1.5:2081
if [[ -z "${CLAUDEBOX_PROXY_URL:-}" && -r "${HOME}/.claudebox/proxy" ]]; then
    while IFS= read -r _claudebox_proxy_line; do
        [[ "$_claudebox_proxy_line" =~ ^[[:space:]]*(#|$) ]] && continue
        CLAUDEBOX_PROXY_URL="$(echo "$_claudebox_proxy_line" | xargs)"
        break
    done < "${HOME}/.claudebox/proxy"
    unset _claudebox_proxy_line
fi
# Explicit opt-out: CLAUDEBOX_PROXY_URL=none/off restores direct access.
case "${CLAUDEBOX_PROXY_URL:-}" in
    none|off|no|disabled) CLAUDEBOX_PROXY_URL="" ;;
esac
readonly CLAUDEBOX_PROXY_URL="${CLAUDEBOX_PROXY_URL:-}"
# "true" (default) = only the proxy is reachable. "false" additionally keeps
# the domain allowlist open so listed hosts can still be reached directly.
readonly CLAUDEBOX_PROXY_STRICT="${CLAUDEBOX_PROXY_STRICT:-true}"
export CLAUDEBOX_PROXY_URL
export CLAUDEBOX_PROXY_STRICT

# Script path resolution - moved to main claudebox.sh since it needs BASH_SOURCE
# SCRIPT_PATH will be set by main script

# Export what other modules need
export USER_ID
export GROUP_ID
export PROJECT_DIR