use dep::std::hash::sha256;

fn verify_address(
    address_bytes: [u8; 64],

    expected_address_hash: [u8; 32]
) {
    let address_hash = sha256(address_bytes);
    assert(address_hash == expected_address_hash);
}

fn verify_lease(
    lease_bytes: [u8; 128],
    address_bytes: [u8; 64],
    lease_start: u64,
    lease_end: u64,
    
    expected_lease_hash: [u8; 32],
    expected_address_hash: [u8; 32],
    current_date: u64
) {
    let lease_hash = sha256(lease_bytes);
    assert(lease_hash == expected_lease_hash);

    let address_hash = sha256(address_bytes);
    assert(address_hash == expected_address_hash);

    assert(lease_start <= current_date);
    assert(current_date <= lease_end);
}

fn main(
    address_bytes: [u8; 64],
    expected_address_hash: pub [u8; 32],
    
    lease_bytes: [u8; 128],
    lease_start: u64,
    lease_end: u64,
    expected_lease_hash: pub [u8; 32],
    current_date: pub u64,
    
    full_verification: pub bool
) {
    if full_verification {
        verify_lease(
            lease_bytes,
            address_bytes,
            lease_start,
            lease_end,
            expected_lease_hash,
            expected_address_hash,
            current_date
        );
    } else {
        verify_address(
            address_bytes,
            expected_address_hash
        );
    }
}