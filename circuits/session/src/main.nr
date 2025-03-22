use dep::std::hash::sha256;

fn main_start_session(
    start_time: u64,
    slot_id: [u8; 16],

    session_commitment: [u8; 32]
) {
    let mut raw = [0; 24];
    
    raw[0] = (start_time & 0xFF) as u8;
    raw[1] = ((start_time >> 8) & 0xFF) as u8;
    raw[2] = ((start_time >> 16) & 0xFF) as u8;
    raw[3] = ((start_time >> 24) & 0xFF) as u8;
    raw[4] = ((start_time >> 32) & 0xFF) as u8;
    raw[5] = ((start_time >> 40) & 0xFF) as u8;
    raw[6] = ((start_time >> 48) & 0xFF) as u8;
    raw[7] = ((start_time >> 56) & 0xFF) as u8;
    
    for i in 0..16 {
        raw[i + 8] = slot_id[i];
    }

    let computed_commitment = sha256(raw);
    assert(computed_commitment == session_commitment);
}

fn main_end_session(
    start_time: u64,
    end_time: u64,
    price_per_minute: u64,
    slot_id: [u8; 16],

    total_reward: u64,
    session_id: [u8; 32]
) {
    assert(end_time > start_time);
    let duration = end_time - start_time;
    let reward = duration * price_per_minute;
    assert(reward == total_reward);

    let mut raw = [0; 32];
    
    raw[0] = (start_time & 0xFF) as u8;
    raw[1] = ((start_time >> 8) & 0xFF) as u8;
    raw[2] = ((start_time >> 16) & 0xFF) as u8;
    raw[3] = ((start_time >> 24) & 0xFF) as u8;
    raw[4] = ((start_time >> 32) & 0xFF) as u8;
    raw[5] = ((start_time >> 40) & 0xFF) as u8;
    raw[6] = ((start_time >> 48) & 0xFF) as u8;
    raw[7] = ((start_time >> 56) & 0xFF) as u8;
    
    raw[8] = (end_time & 0xFF) as u8;
    raw[9] = ((end_time >> 8) & 0xFF) as u8;
    raw[10] = ((end_time >> 16) & 0xFF) as u8;
    raw[11] = ((end_time >> 24) & 0xFF) as u8;
    raw[12] = ((end_time >> 32) & 0xFF) as u8;
    raw[13] = ((end_time >> 40) & 0xFF) as u8;
    raw[14] = ((end_time >> 48) & 0xFF) as u8;
    raw[15] = ((end_time >> 56) & 0xFF) as u8;
    
    raw[16] = (price_per_minute & 0xFF) as u8;
    raw[17] = ((price_per_minute >> 8) & 0xFF) as u8;
    raw[18] = ((price_per_minute >> 16) & 0xFF) as u8;
    raw[19] = ((price_per_minute >> 24) & 0xFF) as u8;
    raw[20] = ((price_per_minute >> 32) & 0xFF) as u8;
    raw[21] = ((price_per_minute >> 40) & 0xFF) as u8;
    raw[22] = ((price_per_minute >> 48) & 0xFF) as u8;
    raw[23] = ((price_per_minute >> 56) & 0xFF) as u8;
    
    for i in 0..8 {
        raw[i + 24] = slot_id[i];
    }

    let computed_session_id = sha256(raw);
    assert(computed_session_id == session_id);
}

fn main(
    start_time: u64,
    slot_id: [u8; 16],
    
    session_commitment: pub [u8; 32],
    
    end_time: pub u64,
    price_per_minute: pub u64,
    total_reward: pub u64,
    session_id: pub [u8; 32],
    
    is_start_session: pub bool
) {
    if is_start_session {
        main_start_session(
            start_time,
            slot_id,
            session_commitment
        );
    } else {
        main_end_session(
            start_time,
            end_time,
            price_per_minute,
            slot_id,
            total_reward,
            session_id
        );
    }
}