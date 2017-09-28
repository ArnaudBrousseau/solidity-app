var Solcial = artifacts.require("./Solcial.sol");

var toAscii = function(hex) {
    var str = '',
        i = 0,
        l = hex.length;
    if (hex.substring(0, 2) === '0x') {
        i = 2;
    }
    for (; i < l; i+=2) {
        var code = parseInt(hex.substr(i, 2), 16);
        if (code === 0) continue; // this is added
        str += String.fromCharCode(code);
    }
    return str;
};

contract('Solcial', function(accounts) {

    it("should start without any users", async function() {
        let solcial = await Solcial.deployed();
        let users = await solcial.getUsers.call();
        assert.equal(0, users.length);
    });

    it("should register users", async function() {
        let solcial = await Solcial.deployed();
        await solcial.registerNewUser(
            "Bob",
            "San Francisco",
            "CA",
            "USA"
        );

        // Assert that we have one user now
        let users = await solcial.getUsers.call();
        assert.equal(1, users.length);

        // Assert that this is the right user
        let user = await solcial.getUser.call(users[0]);
        assert.equal("Bob", user[0]);
        assert.equal("San Francisco", toAscii(user[1]));
        assert.equal("CA", toAscii(user[2]));
        assert.equal("USA", toAscii(user[3]));
    });
});
