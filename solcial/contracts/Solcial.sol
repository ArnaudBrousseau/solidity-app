pragma solidity ^0.4.4;

contract Solcial {

    address SolcialAdmin;

    // this allows to look up notarizedImages by their SHA256notaryHash
    mapping (bytes32 => notarizedImage) notarizedImages;

    // Array of all images (keyed by hash)
    bytes32[] imagesByNotaryHash; 

    // To lookup users by their address
    mapping (address => User) Users;

    // Keeps track of all users
    address[] usersByAddress;

    struct notarizedImage {
        string imageURL;
        uint timeStamp;
    }

    struct User {
        string handle;
        bytes32 city;
        bytes32 state;
        bytes32 country;
        bytes32[] myImages;
    }

    function Solcial() payable {
        // just set the admin, so they can remove bad users or images if
        // needed, but nobody else can.
        SolcialAdmin = msg.sender;
    }

    modifier onlyAdmin() {
        if (msg.sender != SolcialAdmin) {
            revert();
        }
        // Do not forget the "_;"! It will be replaced by the actual function
        // body when the modifier is used.
        _;
    }

    function removeUser(address badUser) onlyAdmin returns (bool success) {
        delete Users[badUser];
        return true;
    }

    function removeImage(bytes32 badImage) onlyAdmin returns (bool success) {
        delete notarizedImages[badImage];
        return true;
    }

    function registerNewUser(string handle, bytes32 city, bytes32 state, bytes32 country) returns (bool success) {
        address thisNewAddress = msg.sender;
        // don't overwrite existing entries, and make sure handle isn't null
        if (bytes(Users[msg.sender].handle).length == 0 && bytes(handle).length != 0) {
            Users[thisNewAddress].handle = handle;
            Users[thisNewAddress].city = city;
            Users[thisNewAddress].state = state;
            Users[thisNewAddress].country = country;

            // don't forget to keep track of this user
            usersByAddress.push(thisNewAddress);

            return true;
        } else {
            // either handle was null, or a user with this handle already existed
            return false;
        }
    }

    function addImageToUser(string imageURL, bytes32 SHA256notaryHash) returns (bool success) {
        address thisNewAddress = msg.sender;

        // Make sure this user has created an account first
        if (bytes(Users[thisNewAddress].handle).length != 0) {
            if (bytes(imageURL).length != 0) {
                // prevent users from fighting over sha->image listings in the
                // but still allow them to add a personal ref to any sha
                if (bytes(notarizedImages[SHA256notaryHash].imageURL).length == 0) {
                    // adds entry for this image to our image whitepages
                    imagesByNotaryHash.push(SHA256notaryHash);
                }

                notarizedImages[SHA256notaryHash].imageURL = imageURL;
                notarizedImages[SHA256notaryHash].timeStamp = block.timestamp; 

                // add the image hash to this users' images array
                Users[thisNewAddress].myImages.push(SHA256notaryHash);

                return true;
            } else {
                // either imageURL or SHA256notaryHash was null, couldn't store image
                return false; 
            }
            return true;
        } else {
            return false; // user didn't have an account yet, couldn't store image
        }
    }

    function getUsers() constant returns (address[]) {
        return usersByAddress;
    }

    // This is only here to sense the number of users in Solidity tests
    function getNumberOfUsers() constant returns (uint) {
        return usersByAddress.length;
    }

    function getUser(address userAddress) constant returns (string,bytes32,bytes32,bytes32,bytes32[]) {
        return (
            Users[userAddress].handle,
            Users[userAddress].city,
            Users[userAddress].state,
            Users[userAddress].country,
            Users[userAddress].myImages
        );
    }

    function getAllImages() constant returns (bytes32[]) {
        return imagesByNotaryHash;
    }

    function getUserImages(address userAddress) constant returns (bytes32[]) {
        return Users[userAddress].myImages;
    }

    function getImage(bytes32 SHA256notaryHash) constant returns (string,uint) {
        return (
            notarizedImages[SHA256notaryHash].imageURL,
            notarizedImages[SHA256notaryHash].timeStamp
        );
    }

}
