clearvars all;
clc;

KRNOCid = 'KRNOC48';
slowFact = 64;
fakeSend =  1;
close all; send_spi_cfg_rst(slowFact,KRNOCid,'fakeSend',fakeSend); % TXrst = 

% Start chain config 1
config = 1;
close all; send_spi_cfg_chain(config,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch1Cfg(1) = 
% Start slaves configuration
close all; send_spi_cfg_slave(2,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch1slCfg(2) = 
close all; send_spi_cfg_slave(1,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch1slCfg(1) = 
% End chain config 1
config = 0;
close all; send_spi_cfg_chain(config,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch1Cfg(2) = 

% Start chain config 2
config = 2;
close all; send_spi_cfg_chain(config,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch2Cfg(1) = 
% Start slaves configuration
close all; send_spi_cfg_slave(3,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch2slCfg(3) = 
close all; send_spi_cfg_slave(2,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch2slCfg(2) = 
close all; send_spi_cfg_slave(1,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch2slCfg(1) = 
% End chain config 2
config = 0;
close all; send_spi_cfg_chain(config,slowFact,KRNOCid,'fakeSend',fakeSend); % TXch2Cfg(2) = 

close all;

spiES.slave1.slaveReg    = hsadc3c_adc2spi_mapping_pos(); spiES.slave1.slaveId    = 1; spiES.slave1.slaveCh    = 1;
spiES.slave2.slaveReg    = hsadc3c_adc2spi_mapping_neg(); spiES.slave2.slaveId    = 2; spiES.slave2.slaveCh    = 1;

spiT3.slave1.slaveReg    = hsadc3c_adc2spi_mapping_pos(); spiT3.slave1.slaveId    = 1; spiT3.slave1.slaveCh    = 2;
spiT3.slave2.slaveReg    = hsadc3c_adc2spi_mapping_neg(); spiT3.slave2.slaveId    = 2; spiT3.slave2.slaveCh    = 2;
spiT3.slaveDITH.slaveReg = hsadc3c_adc2spi_mapping_neg(); spiT3.slaveDITH.slaveId = 3; spiT3.slaveDITH.slaveCh = 2;

disp(' ');
% cell array of control words come first, here foo is not found
% cell array with list of slaves is optional and come after, here bar is not found
% print warning in MATLAB console about stuff not found
get_spi_ctrlWords(spiES,{'D_hdac_calWord2_p','foo'},'slaveList',{'slave1','slave2','bar'},'slowFact',slowFact,'KRNOCid',KRNOCid);
% suppress warnings but print information on whatwent wrong, if any
get_spi_ctrlWords(spiES,{'D_hdac_calWord2_p','foo'},'slaveList',{'slave1','slave2','bar'},'slowFact',slowFact,'KRNOCid',KRNOCid,'quietWarning',1,'debugMSGsummary',1);
% most quiet: no warning at all
get_spi_ctrlWords(spiES,{'D_hdac_calWord2_p','foo'},'slaveList',{'slave1','slave2','bar'},'slowFact',slowFact,'KRNOCid',KRNOCid,'quietWarning',1);
%,'send2chip',1,'fakeSend',1

disp(' ');
% print a bunch of control word in a couple of slaves of ES,
% reporting only the control words actually present in the register
get_spi_ctrlWords(spiES,{'D_hdac_calWord2_p','D_hcmp1_offset_p','D_hcmp0P_offset_m','D_hdac_calMode_m','D_precharge','D_qcmp2_offset'},...
                         'slaveList',{'slave1','slave2'},...
                         'slowFact',slowFact,'KRNOCid',KRNOCid,'quietWarning',1,'debugMSGsummary',1,'foundMSGsummary',1);
% ES, slave 1: update two words at 'max' and 'min', the third has a typo and is ignored
[spiES,~] = set_spi_ctrlWords(spiES,{'D_hdac_calWord2_p','D_hcmp1_offset_p','P_qcmp7_offset'},{'max' 'mid' 6}           ,'slaveList',{'slave1'},'printUpdate',1,'slowFact',slowFact,'KRNOCid',KRNOCid);
% ES, slave 2: update four words and avoid overflow for 1e6 or underflow for -1
[spiES,~] = set_spi_ctrlWords(spiES,{'D_hcmp0P_offset_m','D_hdac_calMode_m','D_precharge','D_qcmp2_offset'},{1 1e6 5 -1},'slaveList',{'slave2'},'printUpdate',1,'slowFact',slowFact,'KRNOCid',KRNOCid);
get_spi_ctrlWords(spiES,{'D_hdac_calWord2_p','D_hcmp1_offset_p','D_hcmp0P_offset_m','D_hdac_calMode_m','D_precharge','D_qcmp2_offset'},...
                         'slaveList',{'slave1','slave2'},...
                         'slowFact',slowFact,'KRNOCid',KRNOCid,'quietWarning',1,'debugMSGsummary',1,'foundMSGsummary',1);

disp(' ');
% T3, slave 3: update one word and plot to MATLAB fig using fakeSend and
% also print verbose debug for comparison
[spiT3,~] = set_spi_ctrlWords(spiT3,{'D_hdac_calWord2_m'},{141},'slaveList',{'slaveDITH'},'printUpdate',1,'send2chip',1,'fakeSend',1,'slowFact',slowFact,'KRNOCid',KRNOCid);
get_spi_ctrlWords(spiT3,{'D_hdac_calWord2_m'},'slaveList',{'slaveDITH'},'slowFact',slowFact,'KRNOCid',KRNOCid,'debugMSGverbose',1);