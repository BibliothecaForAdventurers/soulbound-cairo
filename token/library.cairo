%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_not_zero, assert_not_equal

#
#   Storage variables
#
@storage_var
func ERC4973_name() -> (name : felt):
end

@storage_var
func ERC4973_symbol() -> (symbol : felt):
end

@storage_var
func ERC4973_owners(tokenId : felt) -> (address : felt):
end

@storage_var
func ERC4973_tokenURIs(tokenId : felt) -> (URIs : felt):
end

#
#   Events
#

@event
func Attest(_to : felt, _tokenId):
end

@event
func Revoke(_to : felt, _tokenId):
end

#
#   Constructor
#

func ERC4973_initializer{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(name_ : felt, symbol_ : felt):
    assert_not_zero(name_)
    assert_not_zero(symbol_)
    ERC4973_name.write(name_)
    ERC4973_symbol.write(symbol_)
    return ()
end

#
# Internals
#
func ERC4973_ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(tokenId : felt) -> (res : felt):
    let (owner : felt) = ERC4973_owners.read(tokenId)
    with_attr error_message("ownerOf: token doesn't exist"):
        assert_not_zero(owner)
    end
    return (owner)
end


func ERC4973_exists{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(tokenId : felt) -> (yes_no : felt):
    let (address : felt) = ERC4973_owners.read(tokenId)
    if address == 0:
        return (FALSE)
    else: 
        return (TRUE)
    end
end

func ERC4973_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(to : felt, tokenId : felt, uri : felt) -> (res : felt):
    with_attr error_message("mint: tokenID exists"):
        let (exist : felt) = ERC4973_exists(tokenId)
        assert_not_equal(exist, TRUE)
    end
    ERC4973_owners.write(tokenId, to)
    ERC4973_tokenURIs.write(tokenId, uri)

    Attest.emit(to, tokenId)
    return (tokenId)
end

func ERC4973_burn{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(to : felt, tokenId : felt, uri : felt):
    let (owner : felt) = ERC4973_ownerOf(tokenId)
    ERC4973_owners.write(tokenId, 0)
    ERC4973_tokenURIs.write(tokenId, 0)

    Revoke.emit(to, tokenId)
    return ()
end
