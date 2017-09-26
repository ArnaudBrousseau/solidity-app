# solidity-app
A set of distributed apps written in Solidity.
Inspired from the tutorial at https://blockgeeks.com/guides/how-to-learn-solidity/

# Node dependencies
I usually install node modules locally to avoid version conflicts. To run modules as if they were global:

    export PATH=$PWD/node_modules/.bin:$PATH

# Installing
The command below assumes you have node/npm installed somewhere on your `$PATH`:

    npm install truffle
    npm install ethereumjs-testrpc

# Running

Start the test network:

    testrpc -p 8123

Then:

    truffle compile
    truffle migrate

If you want to run the web app:

    cd app && python -m SimpleHTTPServer <PORT>

# Notes about Blockgeeks's tutorial
* "The Ethereum miners will decide if you paid enough, and include your state-changing transaction in the next block,...": this sentence is repeated twice in a row.
* `npm i -g ethereum-testrpc` is incorrect. You want `npm i -g ethereumjs-testrpc`
* the sample contract showcases `throw`, but really should be `revert()`. See https://github.com/ethereum/solidity/issues/1793
* The migration step does not automatically scan your contracts to deploy them all! You'll need to add a line to `migrations/2_deploy_contracts.js` to deploy a newly created contract
* In the console, do NOT do `Geekt = Geekt.deployed()` (or whatever your app is called). Otherwise you lose the original reference to your deployed app!
* The last part of the tutorial is very rough and confusing. I ended up building my own old-school, non-react frontend which just displays the list of users of Solcial. Nothing fancy but it's better than blindly copying the over-complicated code at https://github.com/Tectract/ethereum-demo-tools/tree/master/GeektReactApp/src IMO

# TODO
[x] Follow tutorial, get the app running on dev
[x] Build UI to access data with web3 in a browser
[ ] Write tests for `Solcial.sol`
[ ] Cleanup the project and the extra contracts
