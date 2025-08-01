# DDS
Direct digital synthesis module implemented in VHDL language.
Look up table values generated in MATLAB and saved in a file.

In DDS Module look up table values read from file and look up table defined as an array in VHDL.
Phase increment input first registerd and then added to phase accumulator register on each clock.

In test bench sine waves with different frequencies generated, output of DDS module wrote in a file and the output plotted in time domain, frequency domain and time-frequency domain in MATLAB.

In `tb_dds_chirp.vhd` Phase increment input changes in each clock to generate Chirp Pulse.

[![delta phase increment](./imgs/generating_Chirp_Pulse_with_DDS.PNG)](https://github.com/sphrk/DDS/blob/main/)

Chirp pulse test bench results:
- in frequency domain:

[![freq domain chirp pulse](./imgs/chirp_freq_domain.jpg)](https://github.com/sphrk/DDS/blob/main/)

- in time-frequency domain:

[![time freq domain chirp pulse](./imgs/chirp_time-freq_domain.jpg)](https://github.com/sphrk/DDS/blob/main/)

