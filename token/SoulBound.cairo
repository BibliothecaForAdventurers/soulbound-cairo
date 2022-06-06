%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.bool import TRUE, FALSE

from token.library import ERC4973_initializer, ERC4973_name, ERC4973_symbol, ERC4973_owners, ERC4973_tokenURIs, ERC4973_exists

#
#   Constructor
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(name_ : felt, symbol_ : felt):
    ERC4973_initializer(name_, symbol_)
    return ()
end


#
#   View functions
#
@view
func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res : felt):
    return ERC4973_name.read()
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (res : felt):
    return ERC4973_symbol.read()
end

@view
func tokenURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(tokenId : felt) -> (res : felt):
    with_attr error_message("tokenURI: token doesn't exist"):
        let (exist : felt) = ERC4973_exists(tokenId)
        assert_not_zero(exist)
    end
    let (res : felt) = ERC4973_tokenURIs.read(tokenId)
    return (res)
end

@view
func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(tokenId : felt) -> (res : felt):
    let (owner : felt) = ERC4973_owners.read(tokenId)
    with_attr error_message("ownerOf: token doesn't exist"):
        assert_not_zero(owner)
    end
    return (owner)
end
