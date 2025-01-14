A solidity exploit that inflates shares in a vault and uses integer rounding to allow an attacker to steal all of a victim's fund as long as the attacker has more funds the victim. 

The attack occurs due to shares being respresented by integers in Solidity. After the first depositor is given one share per wei, future shares are calculated by dividing the deposit amount times the total amount of shares over the total Ether. If the total amount of shares times the deposit are less than the total amount of Ether, then the shares given are zero due to the value being rounded down. This issue doesn't occur normally, but if the amount of shares are artificially inflated, then this risk is very real. 

This example uses a donation to simulate the inflation, as the donation doesn't yield shares to anyone and one share becomes equal to 10 Ether + 1 wei. When a victim puts in 10 Ether, their share value (10e18 / 10e18+1) is zero and the attacker can withdraw the entire vault and steal the victim's money (10 Ether profit). 

A potential solution would be to award shares to the vault in a donation in order to increase the amount of shares without giving any depositor access to the donated shares. 
