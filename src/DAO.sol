// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {DAOToken} from "./DAOToken.sol";
import {DAONft} from "./DAONft.sol";

contract DAO {
    error DAO__DAOMustOwnDAOTokenToParticipate();
    error DAO__DAOInvalidProposalId();
    error DAO__DAOAlreadyVoted();
    error DAO__DAOVotingAlreadyExecuted();
    error DAO__DAOMustBeOwner();

    struct Proposal {
        string description;
        uint256 votes;
        bool executed;
    }

    DAOToken public daoToken;
    DAONft public daoNft;
    address public owner;
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(uint256 proposalId, address voter);
    event ProposalExecuted(uint256 proposalId);

    constructor(address _daoToken, address _daoNFT) {
        daoToken = DAOToken(_daoToken);
        daoNft = DAONft(_daoNFT);
        owner = msg.sender;
    }

    modifier onlyTokenHolder() {
        if (daoToken.balanceOf(msg.sender) <= 0) {
            revert DAO__DAOMustOwnDAOTokenToParticipate();
        }
        _;
    }

    function createProposal(string memory _description) external onlyTokenHolder {
        proposals.push(Proposal({description: _description, votes: 0, executed: false}));
        emit ProposalCreated(proposals.length, _description);
    }

    function vote(uint256 proposalId) external onlyTokenHolder {
        if (proposalId >= proposals.length) {
            revert DAO__DAOInvalidProposalId();
        }

        if (hasVoted[proposalId][msg.sender]) {
            revert DAO__DAOAlreadyVoted();
        }

        proposals[proposalId].votes += daoToken.balanceOf(msg.sender);
        hasVoted[proposalId][msg.sender] = true;
        emit Voted(proposalId, msg.sender);
    }

    function executeProposal(uint256 proposalId) public onlyOwner {
        if (proposalId >= proposals.length) {
            revert DAO__DAOInvalidProposalId();
        }

        if (proposals[proposalId].executed) {
            revert DAO__DAOVotingAlreadyExecuted();
        }

        if (proposals[proposalId].votes >= 1000 * 10 ** daoToken.decimals()) {
            proposals[proposalId].executed = true;
            emit ProposalExecuted(proposalId);
        }
    }

    function getProposalDescription(uint256 index) external view returns (string memory propDesc) {
        Proposal memory proposal = proposals[index];
        string memory proposalDescription = proposal.description;
        return proposalDescription;
    }

    function getProposalVotes(uint256 index) external view returns (uint256 propVotes) {
        Proposal memory proposal = proposals[index];
        uint256 proposalVotes = proposal.votes;
        return proposalVotes;
    }

    function getProposalExecuted(uint256 index) external view returns (bool executed) {
        Proposal memory proposal = proposals[index];
        bool proposalExecuted = proposal.executed;
        return proposalExecuted;
    }

    modifier onlyOwner {
        if(msg.sender != owner) {
            revert DAO__DAOMustBeOwner();
        }
        _;
    }
}
