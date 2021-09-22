//SPDX-License-Identifier: UNLICENSED
// https://medium.com/rayonprotocol/creating-a-smart-contract-having-iterable-mapping-9b117a461115
pragma solidity ^0.8.6;

contract IterableMapAddrToUint256 {
    
    struct Entry {
        uint256 index; // index starts at 1
        uint256 value;
    }
    
    mapping (address => Entry) _mapping;
    address[] _arr;
    
    function size() public view returns (uint256) {
        return _arr.length;
    }
    
    function contains(address addr) public view returns (bool) {
        return getIndex(addr) > 0;
    }
    
    function get(address addr) public view returns (uint256 value) {
        return _mapping[addr].value;
    }
    
    function getIndex(address addr) public view returns (uint256 index) {
        return _mapping[addr].index;
    }
    
    function getAddrByIndex(uint256 index) public view returns (address) {
        require(index != 0);
        require(index <= size());
        return _arr[index-1];
    }
    
    function getByIndex(uint256 index) public view returns (uint256 value) {
        require(index != 0);
        require(index <= size());
        return get(getAddrByIndex(index));
    }

    function set(address addr, uint256 value) public {
        if (contains(addr)) {
            if (value == 0) {
                _remove(addr);
                return;
            }
            
            _mapping[addr].value = value;
        } else {
            _arr.push(addr);
            _mapping[addr].index = _arr.length;
            
            _mapping[addr].value = value;
        }
    }
    
    function _remove(address addr) internal {
        // swap to end
        uint256 index = getIndex(addr);
        _arr[index-1] = _arr[size()-1];
        _arr[size()-1] = addr;
        
        // pop and cleanup
        _arr.pop();
        delete _mapping[addr];
        _mapping[_arr[index-1]].index = index;
    }
    
}