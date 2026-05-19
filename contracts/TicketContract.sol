 //SPDX-License-Identifier: MIT

 pragma solidity ^0.8.26;

 contract TicketingContract {
        struct Ticket{
            uint256 id;
            string eventName;
            uint256 price;
            address owner;
            uint256 Timestamp;
        }

        event EventCreated(uint256 indexed ticketId, string eventName, uint256 price, address indexed owner);
        event TicketPurchased(uint256 indexed ticketId, address indexed buyer, string eventName, uint256 price);
        event FundsWithdrawn(address indexed owner, uint256 amount);
        
        enum EventStatus { Upcoming, Ongoing, Ended }

        mapping(uint256 => Ticket) public tickets;
        uint256 public nextTicketId;

        modifier onlyOwner(uint256 _ticketId) {
            require(msg.sender == tickets[_ticketId].owner, "Only the ticket owner can perform this action");
            _;
        }

        modifier ticketExist(uint256 id){
            require(id < nextTicketId, "ticket does not exist");
            _;
        }

        function createEvent(string memory _eventName, uint256 _price) public onlyOwner(nextTicketId) {
            require(_price > 0, "price must be greater than zero");
            require(bytes(_eventName).length > 0, "Event name cannot be empty");
            tickets[nextTicketId] = Ticket(
                nextTicketId,
                _eventName,
                _price,
                msg.sender,
                block.timestamp
            );

            nextTicketId++;

            emit EventCreated(nextTicketId - 1, _eventName, _price, msg.sender);
        }

        function buyTicket(string memory _eventName) public payable {
            require(msg.value > 0, "price must be greater than zero");
            
            uint256 currenTicketId = nextTicketId;

            tickets[currenTicketId] = Ticket({
                id: nextTicketId,
                eventName: _eventName,
                price: msg.value,
                owner: msg.sender,
                Timestamp: block.timestamp
            });

            emit TicketPurchased(nextTicketId, msg.sender, _eventName, msg.value);
            nextTicketId++;
        }

        function withdrawFunds() external onlyOwner {
            uint256 balance = address(this).balance;
            require(balance > 0, "Nothing to withdraw");

            (bool success,) = owner.call{value: balance}("");
            require(success, "Withdrawal failed");

            emit FundsWithdrawn(owner, balance);
        }
 }