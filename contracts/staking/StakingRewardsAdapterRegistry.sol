pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

/// @notice The stakingRewardsAdapter registry database for Furucombo
contract StakingRewardsAdapterRegistry is Ownable {
    mapping(address => bytes32) adapters;

    bytes32 constant DEPRECATED = bytes10(0x64657072656361746564);

    /**
     * @notice Register a adapter with a bytes32 information.
     * @param registration Adapter address.
     * @param info Info string.
     */
    function register(address registration, bytes32 info) external onlyOwner {
        require(registration != address(0), "zero address");
        require(adapters[registration] == bytes32(0), "registered");
        adapters[registration] = info;
    }

    /**
     * @notice Unregister a adapter. The adapter will be deprecated.
     * @param registration The adapter to be unregistered.
     */
    function unregister(address registration) external onlyOwner {
        require(registration != address(0), "zero address");
        require(adapters[registration] != bytes32(0), "no registration");
        require(adapters[registration] != DEPRECATED, "unregistered");
        adapters[registration] = DEPRECATED;
    }

    /**
     * @notice Update the info of a valid adapter.
     * @param adapter The adapter to be updating info.
     * @param info New info to be updated.
     */
    function updateInfo(address adapter, bytes32 info) external onlyOwner {
        require(adapter != address(0), "zero address");
        require(adapters[adapter] != bytes32(0), "no registration");
        require(adapters[adapter] != DEPRECATED, "unregistered");
        adapters[adapter] = info;
    }

    /**
     * @notice Check if the adapter is valid.
     * @param adapter The adapter to be verified.
     */
    function isValid(address adapter) external view returns (bool result) {
        if (adapters[adapter] == 0 || adapters[adapter] == DEPRECATED)
            return false;
        else return true;
    }

    /**
     * @notice Get the information of a registration.
     * @param adapter The adapter address to be queried.
     */
    function getInfo(address adapter) external view returns (bytes32 info) {
        return adapters[adapter];
    }
}
