# solidity-app
A set of distributed apps written in Solidity.
Inspired from the tutorial at https://blockgeeks.com/guides/how-to-learn-solidity/

# NodeJS dependencies
I'm using Node 8.6.0. It's available for download at https://nodejs.org/dist/v8.6.0/

# Node modules
I usually install node modules locally to avoid version conflicts. To run
modules as if they were global:

    export PATH=$PWD/node_modules/.bin:$PATH

# Installing
The command below assumes you have node/npm installed somewhere on your `$PATH`:

    cd solcial
    npm install .

# Running

Start the test network:

    testrpc -p 8123 (this port is referenced in truffle.js)

Then:

    truffle compile
    truffle migrate

If you want to run the web app:

    http-server app -p 8888

# Testing

Simply run:

    truffle test

# Notes about Blockgeeks's tutorial
* "The Ethereum miners will decide if you paid enough, and include your state-changing transaction in the next block,...": this sentence is repeated twice in a row.
* `npm i -g ethereum-testrpc` is incorrect. You want `npm i -g ethereumjs-testrpc`
* the sample contract showcases `throw`, but really should be `revert()`. See https://github.com/ethereum/solidity/issues/1793
* The migration step does not automatically scan your contracts to deploy them all! You'll need to add a line to `migrations/2_deploy_contracts.js` to deploy a newly created contract
* In the console, do NOT do `Geekt = Geekt.deployed()` (or whatever your app is called). Otherwise you lose the original reference to your deployed app!
* The last part of the tutorial is very rough and confusing. I ended up building my own old-school, non-react frontend which just displays the list of users of Solcial. Nothing fancy but it's better than blindly copying the over-complicated code at https://github.com/Tectract/ethereum-demo-tools/tree/master/GeektReactApp/src IMO
* No mention of testing :( -- I highly recommend trying to write a minimal set of test for the contract created for the sample app. Here's [Truffle's wiki about testing](http://truffleframework.com/docs/getting_started/solidity-tests)

# General Notes
* Dynamically sized arrays cannot be returned from within Solidity
  (http://solidity.readthedocs.io/en/develop/types.html#members), but they're
  able to be returned when called `web3`! What a mess. This means truffle tests
  will fail while the actual Dapp is fine. Workaround is to use a large array
  (instead of `address[]`, use `address[100]`, say). Here I'm just working
  around this by adding an extra `getNumberOfUsers` method for testing.
* `contract.method.call` vs. `contract.method()` can seem very similar (in
  JavaScript, `.call` is a method on the `Function` prototype to override the
  context!) but they are NOT. See [these
  docs](http://truffleframework.com/docs/getting_started/contracts#executing-contract-functions).
  The TLDR is that `contract.method.call()` executes a read on the local node
  (cheap, only applicable to reads, and returns values), whereas
  `contract.method()` executes a _transaction_ which returns a transaction
  object on success (expensive, should be used only to alter state, and results
  in a transaction returned as a value to the call)
* Testing with Solidity really sucks. I much prefer going with mocha/chai.
* While we're on the subject of tests: it's not clear at all that `.call()`
  returns a promise! You either have to go with a promise chain to read values
  OR get fancy and start using async/await (my preferred option since it makes
  the tests so much more readable.)

# TODO
- [x] Follow tutorial, get the app running on dev
- [x] Build UI to access data with web3 in a browser
- [x] Write Solidity tests for `Solcial.sol`
- [x] Write JS tests for `Solcial.sol`
- [ ] Write more complete JS tests for `Solcial.sol`
- [x] Cleanup the project and the extra contracts
