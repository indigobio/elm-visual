#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <test-file>"
    exit 1
fi

read -d '' handler <<- EOF
(function(){
    if (typeof Elm === "undefined") { throw "elm-io config error: Elm is not defined. Make sure you call elm-io with a real Elm output file"}
    if (typeof Elm.Main === "undefined" ) { throw "Elm.Main is not defined, make sure your module is named Main." };
    var worker = Elm.worker(Elm.Main);
})();
EOF

elm make $1 --output test.js
echo "$handler" >> test.js
node test.js