# aliases.zsh: @droxey's custom aliases


# ==================================  CUSTOM ALIASES  ===================================

# VSCode:
alias code='/usr/local/bin/code --new-window'      







# =================================  CUSTOM FUNCTIONS  ==================================

# prettyapi()
# usage: prettyapi https://api.punkapi.com/v2/beers
# requires: `npm install -g underscore-api`
prettyapi () { curl --write-out '%{http_code}' --silent --output /dev/null "$1" | underscore pretty --strict --color --trace ;}
