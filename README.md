# Payment Channel based on Ethereum Smart Contract of Session Dynamics 
Proof of Concept. Ignore all situations of data race.

Tachyon Protocol will use bytes as the equivalent measurement as bandwidth and use Smart Contract for transaction confirmation.

## Let’s say if A is buying bandwidth and is matched to B by XOR operator

- A expects to use nMB bandwidth
- A and B negotiate the Trading channel
  - A puts nMB bandwidth worth of token m as the security deposit, set the bandwidth/token exchange rate and packet loss i, then writes [nMB, Price(/MB), Token(m), Packet Loss(i)] into the smart contract, and pays for smart contract fee;
  - A receives a channel ID and notify B to confirm this ID;
  - B looks up the ID and verify the channel information, then confirms Payment channel and pays for smart contract fee;

- A starts using B's bandwidth after the connection is made:
  - Usage Unit: A rounds up its TX & RX to B, then signs [Sum(TX, RX, n), Tachyon ID(A), Tachyon ID(B), Timestamp] and send them to B in the Packet Header;
  - B receives the usages sign from A, confirms the usage and signs [Sum(TX, RX, n), Tachyon ID(A), Tachyon ID(B), Timestamp] and send them back to A in the Packet header;
  - A and B may now compare the numbers with other parties usage sign;
  - Every 5MB usage, A's session unit needs to include the hash value of B's last session unit; by doing that, it can ensure that both parties can acknowledge that they have received the session unit of the other party to form a chain of evidence.
- When the session is closed and there is no dispute, both parties can choose not to close the Payment channel but only close the connection.
  - If so, A&B don’t need to renegotiate the Payment channel in the future in order to reestablish the connection.
  - If any party requests to close the Payment channel, the last session signed by both parties will be settled to the main chain as the Payment channel is terminated. The equivalent of the tokens will be transferred to B.
 
- If the difference of usage from both parties is greater than Packet Loss(i), then B receives the token based on the lower usage count while A pays for the token based on B's usage count; the difference will also be cleared by the system.
- Either party may choose to blacklist the other party in case of distrust, and no connection will be made in the future. At the same time, this information will be broadcast to the network where other nodes may make their own judgment.
- To prevent Sybil Attack, Payment channel can only be initiated by the client nodes. The Provider nodes have the options to either accept or decline, and each provider nodes can only accept 5 Payment channels at the same time.

## If the transaction involves multiple nodes, there are two things to be considered:
- prevent connection route being exposed; 
- prevent transaction records being exposed. Thus, we will introduce Proxy node in the future which is responsible to handle transactions connection establishment between provider and client nodes.

- Assume client node A wishes to establish a connection with provider C through provider B:

- A expects to use nMB bandwidth from B and C;
  - A negotiates with B to create Payment channel, and puts nMB bandwidth worth of security deposit token m into Payment channel from account balance;
  - B verifies Payment channel and establishes connection with A;
  - The smart contract locks 110%*(nMB bandwidth worth of) tokens m in node F, then request F to establish the connection between B and C and use nMB bandwidth from C;
  - Node F negotiates with C to create payment channel, and puts nMB bandwidth worth of security deposit Token m into Payment channel from account balance;
  - C verifies Payment channel, establishes the connection with B; F then sends C the traffic characteristics of A(hash value of A’s ID and timestamp);
  - After bandwidth is used, A pays B m tokens; node F pays C m tokens, and take extra 10% m tokens as process fee.


## Advantage:
- Avoid service quality issues by using bytes as an equivalent measurement to bps;
The frequent confirmations and information exchanges are the key to prevent fraud between two parties. If the transactions are sent to the main chain, it will greatly consume the TPS. With Lightning Network offline implementation, we can achieve the consensus of two parties and punish the cheating party, as well as ensure the frequent transaction without consuming TPS of the main chain;
- For customer A and supplier B, cheating does not grant any financial returns. (In case of dispute, the usage difference is greater than packet loss (i)) If A purposely claims lower usage, he'd still be paying on B's usage count while if B purposely claims higher usage he'd still be paying on the lower count of usage. Assuming both parties are sane/logical, then cheating/fraud shall not occur.
 - Increase the cost to perform the Sybil attack as it will require a considerable amount of token to execute.
 - The cheating threshold - Packet Loss(i) can be negotiated by both parties. If the threshold is relatively low, the cheating party would not cause a serious loss on the other party.
 - No third party arbitration commission. For arbitration commission to work properly, it will require surveillance of the network, which contradicts our privacy-oriented and surveillance-free belief, and it may also introduce security vulnerabilities.
 - This implementation will ensure the connection between multiple nodes without compromising the route and transaction records.
