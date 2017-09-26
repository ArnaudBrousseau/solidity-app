const HOST = 'localhost';
const PORT = '8123';
const SOLCIAL_ADDRESS = '0xfdea74352575991872f9f6d5112c63c316e0de9c';

const SOLCIAL_ABI_STRING = '[{"constant":true,"inputs":[],"name":"getUsers","outputs":[{"name":"","type":"address[]"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"handle","type":"string"},{"name":"city","type":"bytes32"},{"name":"state","type":"bytes32"},{"name":"country","type":"bytes32"}],"name":"registerNewUser","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"SHA256notaryHash","type":"bytes32"}],"name":"getImage","outputs":[{"name":"","type":"string"},{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUser","outputs":[{"name":"","type":"string"},{"name":"","type":"bytes32"},{"name":"","type":"bytes32"},{"name":"","type":"bytes32"},{"name":"","type":"bytes32[]"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getAllImages","outputs":[{"name":"","type":"bytes32[]"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"imageURL","type":"string"},{"name":"SHA256notaryHash","type":"bytes32"}],"name":"addImageToUser","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"badUser","type":"address"}],"name":"removeUser","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"badImage","type":"bytes32"}],"name":"removeImage","outputs":[{"name":"success","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserImages","outputs":[{"name":"","type":"bytes32[]"}],"payable":false,"type":"function"},{"inputs":[],"payable":true,"type":"constructor"}]';

var getConnection = function(host, port) {
    let providerURL = `http://${host}:${port}`;
    let provider = new Web3.providers.HttpProvider(providerURL);
    return new Web3(provider);
};

var getAccount = function(connection) {
    return connection.eth.accounts[0];
};

var getContract = function(connection, abi, address) {
    return connection.eth.contract(abi).at(address);
};

var getAllUsers = function(connection, cb) {
    let contract = getContract(connection, JSON.parse(SOLCIAL_ABI_STRING), SOLCIAL_ADDRESS);
    let account = getAccount(connection);

    // Async version of contract calls
    contract.getUsers(function(err, users){
        if (err) {
            alert(err);
        }
        results = [];
        for (var i=0; i < users.length; i++) {
            // Sync version of contract calls
            results.push(contract.getUser.call(users[i]));
        }
        cb(results)
    });
};

var templateUser = function(connection, user) {
    return '<li>'
        + user[0] + ' -- '
        + connection.toAscii(user[1]) + ' -- '
        + connection.toAscii(user[2])
        + '</li>';
};

var displayUsers = function(connection) {
    $('.users').html('Fetching...');
    let users = getAllUsers(connection, function(users){
        let templatedUsers = '<ul>';
        for (var i=0; i < users.length; i++) {
            templatedUsers += templateUser(connection, users[i]);
        }
        templatedUsers += '</ul>';
        $('.users').html(templatedUsers);
    });
}

// DO EET
$(document).ready(function() {
    let connection = getConnection(HOST, PORT);
    displayUsers(connection);
});
