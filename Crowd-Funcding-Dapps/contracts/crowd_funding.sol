//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.5 <= 0.9;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public manager;
    uint public target;
    uint public deadline;
    uint public minimumContribution;
    uint public raisedAmount;
    uint public noOfContributors;

    constructor(uint _target, uint _deadline){
        target = _target;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }
    mapping(uint => Request) public requests;
    uint public noOfRequest;

    function receiveEth() public payable{
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum Contribution is not met");

        if(contributors[msg.sender] == 0){
            noOfContributors ++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    modifier onlyManager(){
        require(msg.sender == manager, "Only Manager can access this.");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public {
        Request storage newRequest = requests[noOfRequest];
        noOfRequest ++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "You haven't contributed anything.");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false, "You already have voted.");
        thisRequest.noOfVoters ++;
        thisRequest.voters[msg.sender] = true;
    }

    function makePayment(uint _requestNo) public onlyManager{
        require(raisedAmount >= target, "Target didn't matched.");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "This request has already been completed.");
        require(thisRequest.noOfVoters >= noOfContributors/2, "Majority not matched.");
        thisRequest.recipient.transfer(raisedAmount);
        thisRequest.completed = true;
    }

}