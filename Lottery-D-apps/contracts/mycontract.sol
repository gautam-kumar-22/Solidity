// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

// contract Array
// {
//     uint[3] public arr;
//     uint public count;
//     function loop() public{
//         while(count<arr.length)
//         {
//             arr[count] = count;
//             count ++;
//         }
//     }
// }

// contract IfElse
// {
//     function check(int a) public pure returns(string memory)
//     {
//         string memory value;
//         if(a>0)
//         {
//             value = "Greater than zero";
//         }
//         else if (a==0)
//         {
//             value = "Equal to zero";
//         }
//         else{
//             value = "Lesss than zero";
//         }
//         return value;
//     }
// }

// struct Student{
//     uint roll;
//     string name;
// }

// contract structure
// {
//     Student public s1;

//     constructor(uint _roll, string memory name)
//     {
//         s1.roll = _roll;
//         s1.name = name;
//     }

//     function change(uint _roll, string memory _name) public
//     {
//         Student memory new_student=Student({
//             roll: _roll,
//             name: _name
//         });
//         s1 = new_student;
//     }

// }
contract pay
{
    address payable user = payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    function AcceptPayment() public payable
    {
        
    }
    function checkBalance() public view returns(uint)
    {
        return address(this).balance;
    }
    function sendPayment() public
    {
        user.transfer(1 ether);
    }
}