 //SPDX-License-Identifier: MIT

 pragma solidity ^0.8.26;

 contract TicketingContract {
        struct Ticket{
            uint256 id;
            string eventName;
            uint8 price;
            address owner;
            uint256 Timestamp;
        }

        emit TicketCreated(uint256 indexed ticketId, string eventName, uint8 price, address indexed owner);

        enum EventStatus { Upcoming, Ongoing, Ended }

        mapping(uint256 => Ticket) public tickets;
        uint256 public nextTicketId;

        modifier onlyOwner(uint256 _ticketId) {
            require(msg.sender == tickets[_ticketId].owner, "Only the ticket owner can perform this action");
            _;
        }

        function createTicket(string memory _eventName, uint8 _price) public onlyOwner(nextTicketId) {
            require(_price > 0, "price must be greater than zero");
            tickets[nextTicketId] = Ticket(
                nextTicketId,
                _eventName,
                _price,
                msg.sender,
                block.timestamp
            );

            nextTicketId++;

            event TicketCreated(nextTicketId - 1, _eventName, _price, msg.sender);
        }

        function buyTicket(string memory _eventName, uint8 _price) public {
            require(buyer == address(0), "Not a registered buyer");
            require(_price > 0, "price must be greater than zero");

            tickets[nextTicketId] = Ticket({
                id: nextTicketId,
                eventName: _eventName,
                price: _price,
                owner: msg.sender,
                Timestamp: block.timestamp
            });
            (bool success, ) = msg.sender.call{value: _price}("");
            require(success, "Payment failed");
                nextTicketId++;
                
        }
 }