onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sbqm/sbqm_in_tellers
add wave -noupdate /sbqm/sbqm_in_master_reset
add wave -noupdate /sbqm/sbqm_in_photocell_enterance
add wave -noupdate /sbqm/sbqm_in_photocell_exit
add wave -noupdate /sbqm/sbqm_out_empty_flag
add wave -noupdate /sbqm/sbqm_out_full_flag
add wave -noupdate -radix unsigned /sbqm/sbqm_decoded_tellers_out_sig
add wave -noupdate -radix unsigned /sbqm/sbqm_pcounter_out_sig
add wave -noupdate -radix unsigned /sbqm/Sbqm_rom_out_ones_sig
add wave -noupdate -radix unsigned /sbqm/Sbqm_rom_out_tens_sig
add wave -noupdate /sbqm/sbqm_out_queue_7seg
add wave -noupdate /sbqm/sbqm_out_wtime_7seg_1
add wave -noupdate /sbqm/sbqm_out_wtime_7seg_2
add wave -noupdate /sbqm/sbqm_in_master_reset_sig
add wave -noupdate -color Gold /sbqm/sbqm_clock_sig
add wave -noupdate /sbqm/sbqm_queue_enter_synch_out_sig
add wave -noupdate /sbqm/sbqm_queue_exit_synch_out_sig
add wave -noupdate /sbqm/sbqm_teller_1_synch_out_sig
add wave -noupdate /sbqm/sbqm_teller_2_synch_out_sig
add wave -noupdate /sbqm/sbqm_teller_3_synch_out_sig
add wave -noupdate /sbqm/sbqm_queue_enter_edge_detector_out_sig
add wave -noupdate /sbqm/sbqm_queue_exit_edge_detector_out_sig
add wave -noupdate /sbqm/sbqm_fsm_out_counter_enable_sig
add wave -noupdate /sbqm/sbqm_fsm_out_counter_up_down_sig
add wave -noupdate /sbqm/Sbqm_rom_en_sig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 294
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {233 ps} {1094 ps}
