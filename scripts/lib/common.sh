SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR" || exit 1

BASE_SERVICES="opencode mysql"

get_services() {
    if [ -n "$1" ]; then
        echo "$BASE_SERVICES $1"
    else
        echo "$BASE_SERVICES"
    fi
}