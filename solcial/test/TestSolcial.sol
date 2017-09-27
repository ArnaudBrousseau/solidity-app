pragma solidity ^0.4.4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Solcial.sol";

/**
 * That's by far the most painful way to test contracts
 * Better to test with mocha/JS, the assert library is more mature, and BDD
 * style reads easier IMO.
 * https://github.com/trufflesuite/truffle/blob/beta/lib/testing/Assert.sol is
 * a bit of a joke honestly.
 */
contract TestSolcial {

  function testNetworkIsInitiallyEmpty() {
    Solcial solcial = Solcial(DeployedAddresses.Solcial());
    uint num_users = solcial.getNumberOfUsers();
    Assert.isZero(num_users, "Network should be initially empty");
  }

  function testUserRegistrationAddOneUser() {
    Solcial solcial = Solcial(DeployedAddresses.Solcial());
    bool success = solcial.registerNewUser("Bob", "San Diego", "CA", "USA");
    uint num_users = solcial.getNumberOfUsers();
    uint expected_num_users = 1;
    Assert.isTrue(success, "Registration is successful");
    Assert.equal(expected_num_users, num_users, "Registration adds a user");
  }
}
