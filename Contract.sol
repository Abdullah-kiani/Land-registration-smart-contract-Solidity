// SPDX-License-Identifier: GPL-3.0
pragma solidity &gt;=0.7.0 &lt;0.9.0;

contract Land_Registration_Project{

//Step 1: Creating landregistry
struct Landreg {
uint id;
uint area;
string city;

string state;
uint landPrice;
uint propertyPID;
}

//Step 2: Buyer details
struct Buyer{
address id;
string name;
uint age;
string city;
uint cnic;
string email;
}

//Step 3: Seller details
struct Seller{
address id;
string name;
uint age;
string city;
uint cnic;
string email;
}

//Step 4: LandInspector details
struct LandInspector {
address id;
string name;

uint age;
string designation;
}

//Step 5: Mappings
mapping(uint =&gt; Landreg) public lands;
mapping(address =&gt; LandInspector) public InspectorMapping;
mapping(address =&gt; Seller) public SellerMapping;
mapping(address =&gt; Buyer) public BuyerMapping;
mapping(uint =&gt; address) public LandOwner;

// Before moving to step 6, introducing Land inspector
address public Land_Inspector;
constructor(){
Land_Inspector = msg.sender;
SetLandInspector(&quot;Aslam&quot;, 26, &quot;Land Inspector grade 18&quot;);
}
// Land inspector function
function SetLandInspector(string memory _name, uint _age, string memory _designation) private{
InspectorMapping[msg.sender] = LandInspector(msg.sender, _name, _age, _designation);
}
// mapping for Registered accounts ........ using bool to indicate presence
mapping(address =&gt; bool) public RegisteredAddressMapping; //one for all adresses
mapping(address =&gt; bool) public RegisteredSellerMapping;
mapping(address =&gt; bool) public RegisteredBuyerMapping;

//Event
event Dropmsg(string _msg, address _id);

// Step 6 : registering Seller
function SetSellerdetails(string memory _name, uint _age, string memory _city, uint _cnicnumber,
string memory _email) public {
require(!RegisteredAddressMapping[msg.sender]); // check user is not already registered
RegisteredAddressMapping[msg.sender] = true;
RegisteredSellerMapping[msg.sender] = true ;
SellerMapping[msg.sender] = Seller(msg.sender, _name, _age, _city, _cnicnumber, _email);
emit Dropmsg(&quot;Registered at &quot;, msg.sender);
}
// Step 7: LandInspector can either verify that seller or reject that seller
function isLandInspector(address _id) public view returns (bool) { //Land inspecter check function
if(Land_Inspector == _id){
return true;
}else{
return false;
}
}
// Mapping for verifications
mapping(address =&gt; bool) public SellerVerification;
mapping(address =&gt; bool) public SellerRejection;
mapping(uint =&gt; bool) public LandVerification;

// seller&#39;s verification
function VerifySeller(address _sellerId) public{
require(isLandInspector(msg.sender));

SellerVerification[_sellerId] = true;
emit Dropmsg(&quot;Verified address&quot;, _sellerId);
}

//seller&#39;s rejection
function RejectSeller(address _sellerId) public{
require(isLandInspector(msg.sender));

SellerRejection[_sellerId] = true;
emit Dropmsg(&quot;Rejected address&quot;, _sellerId);
}
// Step 8: If seller is verified then seller upload land details
function isSeller(address _id) public view returns (bool) {
if(RegisteredSellerMapping[_id]){
return true;
}else
{
return false;
}

}
uint public landID;
event LandID_msg(string _msg, uint);
// Land details uploading function
function setLand(uint _area, string memory _city,string memory _state, uint landPrice, uint
_propertyPID) public {
require(isSeller(msg.sender) &amp;&amp; (SellerVerification[msg.sender] = true));
landID++;
lands[landID] = Landreg(landID, _area, _city, _state, landPrice, _propertyPID);
LandOwner[landID] = msg.sender;
emit LandID_msg(&quot;Land registered at id= &quot;, landID);
}
// Step 9: LandInspector will also verify the land added by seller by landID.

function isLand(uint _landId) public{
require(isLandInspector(msg.sender));

LandVerification[_landId] = true;
}

// Step 10: We can also update the seller details
function updateSeller(string memory _name, uint _age, string memory _City, uint _cnicNumber, string
memory _Email) public {
//For Updating its needed that Seller is already registered
require(RegisteredAddressMapping[msg.sender] &amp;&amp; (SellerMapping[msg.sender].id ==
msg.sender));
// checking in registered mapping &amp; matching seller address in mapping with deploy address
SellerMapping[msg.sender].name = _name;
SellerMapping[msg.sender].age = _age;
SellerMapping[msg.sender].city = _City;
SellerMapping[msg.sender].cnic = _cnicNumber;
SellerMapping[msg.sender].email = _Email;
}
// Step 11: We can check if seller is verified or not (boolean)
function isSellerVerified(address _id) public view returns (bool) {
if(SellerVerification[_id]){
return true;
}
else{
return false;
}
}

//Step 12: We can get land details by landID .
function getLandinfo(uint _id) public view returns(uint, uint , string memory, string memory, uint,
uint) {
Landreg memory L= lands[_id];
return (L.id, L.area, L.city, L.state, L.landPrice, L.propertyPID);
}
// Step 13: We can check who is the owner of this land by landID
function getLandowner(uint id) public view returns (address) {
return LandOwner[id];
}

//Step 14: registerBuyer
function setBuyer(string memory _name, uint _age, string memory _city, uint _cnicnumber, string
memory _email) public {
//require that Buyer is not already registered
require(!RegisteredAddressMapping[msg.sender]);
RegisteredAddressMapping[msg.sender] = true;
RegisteredBuyerMapping[msg.sender] = true ;
BuyerMapping[msg.sender] = Buyer(msg.sender, _name, _age, _city, _cnicnumber, _email);
emit Dropmsg(&quot;Registered at&quot;, msg.sender);
}
//Step 15: If Buyer is registered then landInpector either verify that Buyer or reject that buyer.
//Required verification mappings
mapping(address =&gt; bool) public BuyerVerification;
mapping(address =&gt; bool) public BuyerRejection;

function verifyBuyer(address _buyerId) public{
require(isLandInspector(msg.sender));
BuyerVerification[_buyerId] = true;

emit Dropmsg(&quot;Verified address&quot;, _buyerId);
}

function rejectBuyer(address _buyerId) public{
require(isLandInspector(msg.sender));
BuyerRejection[_buyerId] = true;
emit Dropmsg(&quot;Verified address&quot;, _buyerId);
}
//Step 16: We can also update the Buyer details.
function updateBuyer(string memory _name, uint _age, string memory _City, uint _cnicNumber,
string memory _Email) public {
//require that Buyer is already registered
require(RegisteredAddressMapping[msg.sender] &amp;&amp; (BuyerMapping[msg.sender].id ==
msg.sender));
BuyerMapping[msg.sender].name = _name;
BuyerMapping[msg.sender].age = _age;
BuyerMapping[msg.sender].city = _City;
BuyerMapping[msg.sender].cnic = _cnicNumber;
BuyerMapping[msg.sender].email = _Email;
}
//Step 17: We can check if Buyer is verified or not (boolean).
function isBuyerVerified(address _id) public view returns (bool) {
if(BuyerVerification[_id]){
return true;
}else{
return false;
}
}
//Step 18: We can check who is the current owner of this land.

function getLandOwner(uint id) public view returns (address) {
return LandOwner[id];
}
uint public RequestNo;
//Step 19: Buyer can buy the land only if buyer and land both is verified .buyer need to give the amount
and landid that they wants to buy.
struct TransactionRequeststruct{
uint reqId;
address sellerId;
address buyerId;
uint landId;
}
//Mapping reuired at transactional stage
mapping(uint =&gt; TransactionRequeststruct) public TransactionRequestsMapping;
mapping(uint =&gt; bool) public TransactionStatus;
mapping(uint =&gt; bool) public PaymentRecord;

//function to take request and store in mapping
function buyLand(address _sellerId, uint _landId) public{
require(RegisteredBuyerMapping[msg.sender]= true &amp;&amp; isBuyerVerified(msg.sender));
RequestNo++;
TransactionRequestsMapping[RequestNo] = TransactionRequeststruct(RequestNo, _sellerId,
msg.sender, _landId);
TransactionStatus[RequestNo] = false;
}
// land inspector verifies request
function approveBuyRequest(uint _reqId) public {
require(isLandInspector(msg.sender));
TransactionStatus[_reqId] = true;

}
// Payment function
function Pay(address payable _receiver, uint _landId) public payable {
PaymentRecord[_landId] = true;
_receiver.transfer(msg.value);
}
//Step 20 : Owenrship will change from current owner to newOnwer.
function setNewOwner(uint _landId, address _newOwner) public{
require(isLandInspector(msg.sender) &amp;&amp; PaymentRecord[_landId]);
LandOwner[_landId] = _newOwner;
}
/* Part 3: TransferOwnership

Step 21: Owner of the land can transfer their land to any address if the is land is verified by
LandInspector*/
function transferLand(uint _landId, address _newOwner) public{
require(RegisteredAddressMapping[msg.sender] &amp;&amp; LandVerification[_landId]);
LandOwner[_landId] = _newOwner;
}
/* Part 4:
we can individual check
1. LandsOwner function is already available
2. LandIsVerifed */
function isLandVerified(uint _id) public view returns (bool) {
if(LandVerification[_id]){
return true;
}
else{
return false;

}
}
/* 3. SellerIsVerified function is already available
4. BuyerIsVerified function is already available
5. Land inspector*/
function getLandInspector(address L) public view returns( string memory, uint, string memory){
return (InspectorMapping[L].name, InspectorMapping[L].age, InspectorMapping[L].designation);
}
//seller details
function getSellerDetails(address S) public view returns (string memory, uint, string memory, uint,
string memory) {
return (SellerMapping[S].name, SellerMapping[S].age, SellerMapping[S].city, SellerMapping[S].cnic,
SellerMapping[S].email);
}
//buyers details
function getBuyerDetails(address B) public view returns (string memory, uint, string memory, uint,
string memory) {
return (BuyerMapping[B].name, BuyerMapping[B].age, BuyerMapping[B].city,
BuyerMapping[B].cnic, BuyerMapping[B].email);
}

//6. GetLandCity
function getLandCity(uint i) public view returns (string memory) {
return lands[i].city; }

//7. GetLandPrice
function getLandArea(uint i) public view returns (uint) {
return lands[i].area;
}

//8. GetArea
function getLandPrice(uint i) public view returns (uint) {
return lands[i].landPrice;
}

}
