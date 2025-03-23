use dep::std::hash::sha256;

global MAX_SESSION_DURATION: u64 = 24 * 60 * 60;
global MAX_PRICE_PER_MINUTE: u64 = 10_000;

global OPERATION_START: u8 = 1;
global OPERATION_END: u8 = 2;
global OPERATION_EXTEND: u8 = 3;
global OPERATION_DISPUTE: u8 = 4;

fn main(
    operation: u8,
    start_time: u64,
    slot_id: [u8; 16],
    vehicle_id: [u8; 16],
    owner_id: [u8; 32],
    price_per_minute: u64,
    
    deposit_amount: u64,
    
    end_time: u64,
    
    original_end_time: u64,
    new_end_time: u64,
    
    dispute_reason: u8,
    dispute_timestamp: u64,
    evidence_hash: [u8; 32],
    
    session_commitment: pub [u8; 32],
    public_price: pub u64,
    public_deposit: pub u64,
    
    total_charge: pub u64,
    session_id: pub [u8; 32],
    deposit_refund: pub u64,
    
    original_session_id: pub [u8; 32],
    new_session_id: pub [u8; 32],
    additional_charge: pub u64,

    dispute_id: pub [u8; 32],
    disputed_amount: pub u64,
    public_dispute_timestamp: pub u64
) {
    if operation == OPERATION_START {
        start_session(
            start_time,
            slot_id,
            vehicle_id,
            owner_id,
            price_per_minute,
            deposit_amount,
            session_commitment,
            public_price,
            public_deposit
        );
    } else if operation == OPERATION_END {
        end_session(
            start_time,
            end_time,
            price_per_minute,
            slot_id,
            vehicle_id,
            owner_id,
            deposit_amount,
            total_charge,
            session_id,
            deposit_refund
        );
    } else if operation == OPERATION_EXTEND {
        extend_session(
            start_time,
            original_end_time,
            new_end_time,
            price_per_minute,
            slot_id,
            vehicle_id,
            owner_id,
            original_session_id,
            new_session_id,
            additional_charge
        );
    } else if operation == OPERATION_DISPUTE {
        dispute_session(
            start_time,
            end_time,
            price_per_minute,
            slot_id,
            vehicle_id,
            owner_id,
            dispute_reason,
            evidence_hash,
            session_id,
            dispute_id,
            disputed_amount,
            dispute_timestamp,
            public_dispute_timestamp
        );
    } else {
        assert(false);
    }
}

fn start_session(
    start_time: u64,
    slot_id: [u8; 16],
    vehicle_id: [u8; 16],
    owner_id: [u8; 32],
    price_per_minute: u64,
    deposit_amount: u64,

    session_commitment: [u8; 32],
    public_price: u64,
    public_deposit: u64
) {
    assert(price_per_minute <= MAX_PRICE_PER_MINUTE);
    assert(price_per_minute > 0);
    assert(price_per_minute == public_price);
    assert(deposit_amount == public_deposit);
    assert(deposit_amount >= price_per_minute * 60);
    
    let mut raw: [u8; 72] = [0; 72];
    
    let start_time_bytes = u64_to_le_bytes(start_time);
    for i in 0..8 {
        raw[i] = start_time_bytes[i];
    }
    for i in 0..16 {
        raw[8 + i] = slot_id[i];
    }
    for i in 0..16 {
        raw[24 + i] = vehicle_id[i];
    }
    for i in 0..32 {
        raw[40 + i] = owner_id[i];
    }

    let computed_commitment = sha256(raw);
    assert(computed_commitment == session_commitment);
}

fn end_session(
    start_time: u64,
    end_time: u64,
    price_per_minute: u64,
    slot_id: [u8; 16],
    vehicle_id: [u8; 16],
    owner_id: [u8; 32],
    deposit_amount: u64,

    total_charge: u64,
    session_id: [u8; 32],
    deposit_refund: u64
) {
    assert(end_time > start_time);

    let duration = end_time - start_time;
    assert(duration <= MAX_SESSION_DURATION);
    
    let minutes = (duration + 59) / 60;
    let charge = minutes * price_per_minute;
    assert(charge == total_charge);
    assert(deposit_amount >= charge);
    assert(deposit_refund == deposit_amount - charge);

    let mut raw: [u8; 88] = [0; 88];
    let start_bytes = u64_to_le_bytes(start_time);
    let end_bytes = u64_to_le_bytes(end_time);
    let price_bytes = u64_to_le_bytes(price_per_minute);
    
    for i in 0..8 {
        raw[i] = start_bytes[i];
    }
    for i in 0..8 {
        raw[8 + i] = end_bytes[i];
    }
    for i in 0..8 {
        raw[16 + i] = price_bytes[i];
    }
    for i in 0..16 {
        raw[24 + i] = slot_id[i];
    }
    for i in 0..16 {
        raw[40 + i] = vehicle_id[i];
    }
    for i in 0..32 {
        raw[56 + i] = owner_id[i];
    }

    let computed_session_id = sha256(raw);
    assert(computed_session_id == session_id);
}

fn extend_session(
    original_start_time: u64,
    original_end_time: u64,
    new_end_time: u64,
    price_per_minute: u64,
    slot_id: [u8; 16],
    vehicle_id: [u8; 16],
    owner_id: [u8; 32],
    
    original_session_id: [u8; 32],
    new_session_id: [u8; 32],
    additional_charge: u64
) {
    assert(new_end_time > original_end_time);
    assert(original_end_time > original_start_time);

    let new_duration = new_end_time - original_start_time;
    assert(new_duration <= MAX_SESSION_DURATION);

    let mut original_raw: [u8; 88] = [0; 88];
    let start_bytes = u64_to_le_bytes(original_start_time);
    let end_bytes = u64_to_le_bytes(original_end_time);
    let price_bytes = u64_to_le_bytes(price_per_minute);
    for i in 0..8 {
        original_raw[i] = start_bytes[i];
    }
    for i in 0..8 {
        original_raw[8 + i] = end_bytes[i];
    }
    for i in 0..8 {
        original_raw[16 + i] = price_bytes[i];
    }
    for i in 0..16 {
        original_raw[24 + i] = slot_id[i];
    }
    for i in 0..16 {
        original_raw[40 + i] = vehicle_id[i];
    }
    for i in 0..32 {
        original_raw[56 + i] = owner_id[i];
    }
    let computed_original_id = sha256(original_raw);
    assert(computed_original_id == original_session_id);
    let mut new_raw: [u8; 88] = [0; 88];
    let new_end_bytes = u64_to_le_bytes(new_end_time);
    
    for i in 0..8 {
        new_raw[i] = start_bytes[i];
    }
    for i in 0..8 {
        new_raw[8 + i] = new_end_bytes[i];
    }
    for i in 0..8 {
        new_raw[16 + i] = price_bytes[i];
    }
    for i in 0..16 {
        new_raw[24 + i] = slot_id[i];
    }
    for i in 0..16 {
        new_raw[40 + i] = vehicle_id[i];
    }
    for i in 0..32 {
        new_raw[56 + i] = owner_id[i];
    }
    let computed_new_id = sha256(new_raw);
    assert(computed_new_id == new_session_id);

    let original_duration = original_end_time - original_start_time;
    let original_minutes = (original_duration + 59) / 60;
    let new_minutes = (new_duration + 59) / 60;
    let extra_minutes = new_minutes - original_minutes;
    let charge = extra_minutes * price_per_minute;
    assert(charge == additional_charge);
}

fn dispute_session(
    start_time: u64,
    end_time: u64,
    price_per_minute: u64,
    slot_id: [u8; 16],
    vehicle_id: [u8; 16],
    owner_id: [u8; 32],
    dispute_reason: u8,
    evidence_hash: [u8; 32],
    
    session_id: [u8; 32],
    dispute_id: [u8; 32],
    disputed_amount: u64,
    dispute_timestamp: u64,
    public_dispute_timestamp: u64
) {
    assert(dispute_reason > 0);
    assert(dispute_reason <= 5);
    assert(dispute_timestamp == public_dispute_timestamp);
    
    let mut session_raw: [u8; 88] = [0; 88];
    let start_bytes = u64_to_le_bytes(start_time);
    let end_bytes = u64_to_le_bytes(end_time);
    let price_bytes = u64_to_le_bytes(price_per_minute);
    
    for i in 0..8 {
        session_raw[i] = start_bytes[i];
    }
    
    for i in 0..8 {
        session_raw[8 + i] = end_bytes[i];
    }
    
    for i in 0..8 {
        session_raw[16 + i] = price_bytes[i];
    }
    
    for i in 0..16 {
        session_raw[24 + i] = slot_id[i];
    }
    
    for i in 0..16 {
        session_raw[40 + i] = vehicle_id[i];
    }
    
    for i in 0..32 {
        session_raw[56 + i] = owner_id[i];
    }
    
    let computed_session_id = sha256(session_raw);
    assert(computed_session_id == session_id);
    
    let duration = end_time - start_time;
    let minutes = (duration + 59) / 60;
    let total_charge = minutes * price_per_minute;
    assert(disputed_amount <= total_charge);
    
    let mut dispute_raw: [u8; 128] = [0; 128];
    
    for i in 0..88 {
        dispute_raw[i] = session_raw[i];
    }
    
    dispute_raw[88] = dispute_reason;
    dispute_raw[89] = 0;
    dispute_raw[90] = 0;
    dispute_raw[91] = 0;
    
    let timestamp_bytes = u64_to_le_bytes(dispute_timestamp);
    for i in 0..8 {
        dispute_raw[92 + i] = timestamp_bytes[i];
    }
    for i in 0..32 {
        dispute_raw[96 + i] = evidence_hash[i];
    }
    let computed_dispute_id = sha256(dispute_raw);
    assert(computed_dispute_id == dispute_id);
}

fn u64_to_le_bytes(value: u64) -> [u8; 8] {
    let mut bytes: [u8; 8] = [0; 8];
    
    bytes[0] = (value & 0xFF) as u8;
    bytes[1] = ((value >> 8) & 0xFF) as u8;
    bytes[2] = ((value >> 16) & 0xFF) as u8;
    bytes[3] = ((value >> 24) & 0xFF) as u8;
    bytes[4] = ((value >> 32) & 0xFF) as u8;
    bytes[5] = ((value >> 40) & 0xFF) as u8;
    bytes[6] = ((value >> 48) & 0xFF) as u8;
    bytes[7] = ((value >> 56) & 0xFF) as u8;
    
    bytes
}