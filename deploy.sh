#! /bin/bash

if [[ -e ./hugo ]]; then
    rm ./hugo
fi

echo "Installing Hugo"
wget https://github.com/gohugoio/hugo/releases/download/v0.37/hugo_0.37_Linux-64bit.tar.gz
tar -xzf hugo_0.37_Linux-64bit.tar.gz

./hugo -d /home/site/wwwroot/
echo "Hugo build finished successfully."

