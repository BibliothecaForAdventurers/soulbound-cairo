%lang starknet
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ISoulBound:
    func name() -> (name : felt):
    end

    func symbol() -> (symbol : felt):
    end

    func balanceOf(owner : felt) -> (balance : Uint256):
    end

    func ownerOf(token_id : Uint256) -> (owner : felt):
    end

    func SB_URI_(token_id : Uint256) -> (uri : felt):
    end

    func mint(to : felt, token_id : Uint256):
    end

    func burn(token_id : Uint256):
    end
end
