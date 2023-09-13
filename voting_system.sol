// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract VotingSystem{
    address electionCommision;
    address public winner;

    struct Voter {
        string name;
        uint age;
        uint viterID;
        string gender;
        uint voteCandidateID;
        address voterAddress;
    }

    struct Candidate {
        string name;
        string party;
        uint age;
        string gender;
        uint candidateID;
        address candidateAddress;
        uint votes;
    }
    
    uint nextVoterID = 1; // Voter ID for voter
    uint nextCandidateID = 1; // Candidate ID for candidate

    uint startTime;  // Voting start time
    uint endTime; // Voting end time

    mapping(uint => Voter) voterDetails; // Voter details
    mapping (uint => Candidate) candidateDetails; // Candidate details

    bool stopVoting; // This is for an emergency situation to stop voting

    constructor(){
        electionCommision = msg.sender; // Assigning the deployer of contract as election commision
    }

    modifier isVotingOver(){
        require(block.timestamp > endTime || stopVoting == true, "Voting is not over");
        _;
    }

    modifier onlyElectionCommission(){
        require(electionCommision == msg.sender, "Not from election commission");
        _;
    }

    function candidateRegistration(
        string calldata _name,
        string calldata _party,
        uint _age,
        string calldata _gender
    ) external {
        require(msg.sender != electionCommision, "You are from election commission.");
        require(!isCandateAlreadyRegistered(msg.sender), "You are already registered.");
        require(_age>18, "You are not eligible");
        require(nextCandidateID<3, "Candidate registration has been full.");
        candidateDetails[nextCandidateID] = Candidate(
            _name,
            _party,
            _age,
            _gender,
            nextCandidateID,
            msg.sender,
            0
        );
        nextCandidateID++;
    }

    function isCandateAlreadyRegistered(address _person) internal view returns (bool) {
        for(uint i = 1; i < nextCandidateID; i++){
            if(candidateDetails[i].candidateAddress == _person){
                return true;
            }
        }
        return false;
    }

    function candidateList() public view returns (Candidate[] memory){
        Candidate[] memory array = new Candidate[](nextCandidateID-1);
        for(uint i=1; i < nextCandidateID; i++){
            array[i-1] = candidateDetails[i];
        }
        return array;
    }

    function voterRegistration(
        string calldata _name,
        uint _age,
        string calldata _gender
    ) external {
        // require(msg.sender != electionCommision, "You are from election commission.");
        require(_age > 18, "You are not eligible");
        // require(!isVoterAlreadyRegistered(msg.sender), "You are already registered as a voter");
        // require(!isCandateAlreadyRegistered(msg.sender), "You are registered as a candidate");
        voterDetails[nextVoterID] = Voter(
            _name,
            _age,
            nextVoterID,
            _gender,
            0,
            msg.sender
        );
        nextVoterID++;
    }

    function isVoterAlreadyRegistered(address _person) internal view returns (bool){
        for(uint i=1; i<nextVoterID; i++){
            if(voterDetails[i].voterAddress == _person){
                return true;
            }
        }
        return false;
    }

    function voterList() external view returns (Voter[] memory){
        Voter[] memory array = new Voter[](nextVoterID-1);
        for(uint i=1; i<nextVoterID; i++){
            array[i-1] = voterDetails[i];
        }
        return array;
    }

    function vote(uint _voterID, uint _candidateID) external {
        require(voterDetails[_voterID].voteCandidateID != 0, "Already voted.");
        require(voterDetails[_voterID].voterAddress == msg.sender, "You are not registered.");
        require(startTime != 0, "Voting not started yet.");
        require(nextCandidateID == 3, "Candidate not registered yet.");
        voterDetails[_voterID].voteCandidateID = _candidateID;
        candidateDetails[_candidateID].votes ++;
    }

    function voteTime(uint _starttime, uint _endtime) external onlyElectionCommission(){
        startTime = _starttime + block.timestamp;
        endTime = startTime + _endtime;
    }

    function votingStatus() public view returns (string memory){
        if(startTime == 0){
            return "Voting not started";
        }else if((endTime > block.timestamp) && (stopVoting == false)){
            return "Voting is in progress";
        }
        return "Voting ended";
    }

    function result() external onlyElectionCommission(){
        uint maxi = 0;
        for(uint i = 0; i<nextCandidateID; i++){
            if(candidateDetails[i].votes > maxi){
                maxi = candidateDetails[i].votes;
                winner = candidateDetails[i].candidateAddress;
            }
        }

    }

    function emergency() public onlyElectionCommission(){
        stopVoting = true;
    }

}