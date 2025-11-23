set -e

cp -r "$(dirname "$0")/src"/* "$HOME/.config/" || {
    echo "Error appear during the copy."
    exit 1
}

echo "Copy done !"