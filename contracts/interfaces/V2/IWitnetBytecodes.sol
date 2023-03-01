// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "../../libs/WitnetV2.sol";

interface IWitnetBytecodes {

    error UnknownDataSource(bytes32 hash);
    error UnknownRadonReducer(bytes32 hash);
    error UnknownRadonRetrieval(bytes32 hash);
    error UnknownRadonSLA(bytes32 hash);
    
    event NewDataProvider(uint256 index);
    event NewDataSourceHash(bytes32 hash);
    event NewRadonReducerHash(bytes32 hash);
    event NewRadHash(bytes32 hash);
    event NewSlaHash(bytes32 hash);

    function bytecodeOf(bytes32 radHash) external view returns (bytes memory);
    function bytecodeOf(bytes32 radHash, bytes32 slahHash) external view returns (bytes memory);

    function hashOf(bytes32 radHash, bytes32 slaHash) external pure returns (bytes32 drQueryHash);
    function hashWeightWitsOf(bytes32 radHash, bytes32 slaHash) external view returns (
            bytes32 drQueryHash,
            uint32  drQueryWeight,
            uint256 drQueryWits
        );

    function lookupDataProvider(uint256 index) external view returns (string memory, uint);
    function lookupDataProviderIndex(string calldata authority) external view returns (uint);
    function lookupDataProviderSources(uint256 index, uint256 offset, uint256 length) external view returns (bytes32[] memory);
    function lookupDataSource(bytes32 hash) external view returns (WitnetV2.DataSource memory);
    function lookupDataSourceArgsCount(bytes32 hash) external view returns (uint8);
    function lookupDataSourceResultDataType(bytes32 hash) external view returns (WitnetV2.RadonDataTypes);
    function lookupRadonReducer(bytes32 hash) external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonRetrievalAggregator(bytes32 hash) external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonRetrievalResultMaxSize(bytes32 hash) external view returns (uint256);
    function lookupRadonRetrievalResultDataType(bytes32 hash) external view returns (WitnetV2.RadonDataTypes);
    function lookupRadonRetrievalSources(bytes32 hash) external view returns (bytes32[] memory);
    function lookupRadonRetrievalSourcesCount(bytes32 hash) external view returns (uint);
    function lookupRadonRetrievalTally(bytes32 hash) external view returns (WitnetV2.RadonReducer memory);
    function lookupRadonSLA(bytes32 hash) external view returns (WitnetV2.RadonSLA memory);
    function lookupRadonSLAReward(bytes32 hash) external view returns (uint);
    
    function verifyDataSource(
            WitnetV2.DataRequestMethods requestMethod,
            string calldata requestSchema,
            string calldata requestAuthority,
            string calldata requestPath,
            string calldata requestQuery,
            string calldata requestBody,
            string[2][] calldata requestHeaders,
            bytes calldata requestRadonScript
        ) external returns (bytes32 hash);
    
    function verifyRadonReducer(WitnetV2.RadonReducer calldata reducer)
        external returns (bytes32 hash);
    
    function verifyRadonRetrieval(
            WitnetV2.RadonDataTypes resultDataType,
            uint16 resultMaxSize,
            bytes32[] calldata sources,
            string[][] calldata sourcesArgs,
            bytes32 aggregatorHash,
            bytes32 tallyHash
        ) external returns (bytes32 hash);    
    
    function verifyRadonSLA(WitnetV2.RadonSLA calldata sla)
        external returns (bytes32 hash);

    function totalDataProviders() external view returns (uint);
   
}