//SPDX-License-Identifier:MIT

pragma solidity ^0.8.12;

contract EventManagement{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint => Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;

    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external{
        require(date>block.timestamp,"you can organise event for future date");
        require(ticketCount>0,"You have to generate atleast 1 ticket for the event");
        events[nextId]=Event(msg.sender,name, date, price, ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id, uint quantity ) public payable{
        require(events[id].date!=0,"This event doesn't exits");
        require(events[id].date>block.timestamp,"Events has already occured");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"Not enough tickets");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;

    }

    function transferTicket(uint id, uint quantity, address to) external{
        require(events[id].date!=0,"This event doesn't exits");
        require(events[id].date>block.timestamp,"Events has already occured");
        require(tickets[msg.sender][id]>=quantity,"you don't have enought tickets");
        tickets[to][id]=quantity;
    }
}
