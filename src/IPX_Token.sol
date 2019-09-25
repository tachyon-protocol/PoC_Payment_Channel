pragma solidity ^0.5.0;

import "./GSN_Context.sol";
import "./IERC20.sol";
import "./SafeMath.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract IPX_Token is Context, IERC20 {
    using SafeMath for uint256;

    string public constant name = "IPX Token";
    string public constant symbol = "IPX";
    uint8 public constant decimals = 0;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(_msgSender(), spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
    * @dev Destroys `amount` tokens from `account`, reducing the
    * total supply.
    *
    * Emits a {Transfer} event with `to` set to the zero address.
    *
    * Requirements
    *
    * - `account` cannot be the zero address.
    * - `account` must have at least `amount` tokens.
    */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }

    struct paymentChannel {
        address consumer;
        address provider;
        uint256 fund;
        uint256 pricePreByte;
        bool isConfirmed;
        bool enable;
        uint createTime;
        uint lastExchangeSignTime;
    }

    mapping(bytes32 => paymentChannel) private _paymentChannelMap;
    mapping(address => uint) private _providerToOpenChannelCountMap;

    function getChannelId(address consumer, address provider) public pure returns (bytes32 channelId) {
        return keccak256(abi.encodePacked(consumer, provider));
    }

    function consumerCreatePaymentChannel(address provider, uint256 fund, uint256 pricePreByte) public returns (bytes32 channelId) {
        channelId = getChannelId(msg.sender, provider);
        //TODO check qualification of provider
        require(msg.sender != provider, "can not create channel to self");
        require(fund > 0, "fund = 0");
        require(_providerToOpenChannelCountMap[provider] <= maxChannelCountProvider, "provider can not confirm more channel");
        require(balanceOf(msg.sender) >= fund, "insufficient balance");
        _balances[msg.sender] -= fund;
        paymentChannel storage channel = _paymentChannelMap[channelId];
        require(channel.enable == false, "channel is already enable, can not create it again");
        channel.consumer = msg.sender;
        channel.provider = provider;
        channel.fund = fund;
        channel.pricePreByte = pricePreByte;
        channel.isConfirmed = false;
        channel.enable = true;
        channel.createTime = now;
        channel.lastExchangeSignTime = 0;
        return channelId;
    }

    function verifyPaymentChannel(address consumer, address provider) public view returns (uint256 fund, uint256 pricePreByte, bool isConfirmed, bool enable, uint createTime) {
        paymentChannel memory channel = _paymentChannelMap[getChannelId(consumer, provider)];
        return (channel.fund, channel.pricePreByte, channel.isConfirmed, channel.enable, channel.createTime);
    }

    uint confirmTimeout = 5 hours;
    uint exchangeTimeout = 12 hours;
    uint maxChannelCountProvider = 5;

    function providerConfirmPaymentChannel(address consumer) public {
        paymentChannel storage channel = _paymentChannelMap[getChannelId(consumer, msg.sender)];
        require(channel.enable == true, "channel is not enable");
        require(channel.isConfirmed == false, "channel is already confirmed");
        require(now < channel.createTime + confirmTimeout, "timeout, can not confirm");
        require(_providerToOpenChannelCountMap[msg.sender] < maxChannelCountProvider, "provider can not confirm more channel");
        channel.isConfirmed = true;
        _providerToOpenChannelCountMap[msg.sender]++;
    }

    function consumerRedeemAndClosePaymentChannel(address provider) public {
        paymentChannel storage channel = _paymentChannelMap[getChannelId(msg.sender, provider)];
        require(channel.enable == true, "channel is not enable");
        require(channel.isConfirmed == false, "channel is already confirmed");
        require(now >= channel.createTime + confirmTimeout, "can not redeem now");
        channel.enable = false;
        _balances[channel.consumer] += channel.fund;
    }

    function providerClosePaymentChannel(address consumer) public {
        paymentChannel storage channel = _paymentChannelMap[getChannelId(consumer, msg.sender)];
        require(channel.enable == true, "channel is not enable");
        require(channel.isConfirmed == true, "channel is not confirmed");
        channel.enable = false;
        _balances[consumer] += channel.fund;
        _providerToOpenChannelCountMap[msg.sender]--;
    }

    function hashExchange(address consumer, address provider, uint256 dataBytes) public view returns (bytes32 message, uint signTime){
        signTime = now;
        paymentChannel storage channel = _paymentChannelMap[getChannelId(consumer, provider)];
        require(channel.enable == true, "channel is not enable");
        return (keccak256(abi.encodePacked(this, provider, dataBytes, channel.createTime, signTime)), signTime);
    }

    function checkSign(address consumer, address provider, uint256 dataBytes, uint signTime, bytes memory signature) public view {
        paymentChannel storage channel = _paymentChannelMap[getChannelId(consumer, provider)];
        require(channel.enable == true, "channel is not enable");
        require(recoverSigner(keccak256(abi.encodePacked(this, provider, dataBytes, channel.createTime, signTime)), signature) == consumer,"check signature failed");
    }

    function providerExchangePaymentChannel(
        address consumer,
        bytes memory signature,
        uint signTime,
        uint256 dataBytes) public {
        paymentChannel storage channel = _paymentChannelMap[getChannelId(consumer, msg.sender)];
        require(channel.enable == true, "channel is not enable");
        require(channel.isConfirmed == true, "channel is not confirmed");
        require(channel.createTime <= signTime, "signTime should later than channel's createTime");
        require(channel.lastExchangeSignTime < signTime, "signTime should later than channel.lastExchangeSignTime");
        bytes32 message = keccak256(abi.encodePacked(this, channel.provider, dataBytes, channel.createTime, signTime));
        require(recoverSigner(message, signature) == channel.consumer);
        uint256 amount = dataBytes * channel.pricePreByte;
        if (amount > channel.fund) {
            amount = channel.fund;
        }
        channel.lastExchangeSignTime = signTime;
        channel.fund -= amount;
        _balances[channel.provider] += amount;
    }

    function consumerTerminatePaymentChannel(address provider) public {
        paymentChannel storage channel = _paymentChannelMap[getChannelId(msg.sender, provider)];
        require(channel.enable == true, "channel is not enable");
        require(channel.isConfirmed == true, "channel is not confirmed");
        uint later = channel.createTime;
        if (channel.lastExchangeSignTime > later) {
            later = channel.lastExchangeSignTime;
        }
        require(later + exchangeTimeout <= now, "can not be terminated now");
        channel.enable = false;
        _balances[channel.consumer] += channel.fund;
        _providerToOpenChannelCountMap[channel.provider]--;
    }

    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
        return ecrecover(message, v, r, s);
    }

    function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65);
        assembly {
        // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
        // second 32 bytes.
            s := mload(add(sig, 64))
        // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }
        return (v, r, s);
    }

    //TODO DEBUG
    function debugGetChannelCountToProvider() public view returns (uint) {
        return _providerToOpenChannelCountMap[msg.sender];
    }

    function debugCloseChannelForce(bytes32 channelId) public {
        paymentChannel storage channel = _paymentChannelMap[channelId];
        channel.enable = false;
    }

    function debugMint() public {
        _mint(msg.sender, 100);
    }
}