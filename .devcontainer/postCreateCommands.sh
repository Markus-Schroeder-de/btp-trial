#! /bin/sh
# slow build process: You could add the Key and download & install the latest package
# or fast build process: you could install the .deb-package version 8.7.1 from the .devcontainer
pnmp=false

# npm i -g @nestjs/cli

echo ">>>> install CLoudFoundry-cli (cf8-cli) && terraform ... "
echo "More Info: https://github.com/cloudfoundry/cli/wiki/V8-CLI-Installation-Guide"

sudo curl https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key > /usr/share/keyrings/cli.cloudfoundry.org.key && 
sudo echo "deb [signed-by=/usr/share/keyrings/cli.cloudfoundry.org.key] https://packages.cloudfoundry.org/debian stable main" > /etc/apt/sources.list.d/cloudfoundry-cli.list

sudo curl https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg &&
sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update && sudo apt-get install cf8-cli terraform=1.5.7-1 -y

if $pnmp; then
    pnpm config set store-dir ~/.local/share/pnpm/store && pnpm install --frozen-lockfile
fi

cf install-plugin -f multiapps 
cf install-plugin -f html5-plugin

sudo chown -R node:node .
sudo apt install sqlite3 -y
npm add -g @sap/cds-dk
npm i


sudo apt install bash-completion
sudo echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc

# Git-Stuff
git config pull.rebase false

sudo apt-get install gitk -y
