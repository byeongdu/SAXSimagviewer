function GoldSave(filename, R, InHeader)
% 'goldsave' is to save just one Gold detector file at BESSRC
% usage :
%		for example
% 		GoldSave('test.xxx', R, header) : R is data.
%       Header.IC : ionchamber data
%       Header.format : dataformat('uint16' for integer, 'float' for floating point)

fid = fopen(filename, 'w');
if nargin > 2
    if isfield(InHeader, 'IC')
        ICdata = num2str(InHeader.IC);
    else
        ICdata = '10000';
    end

    if isfield(InHeader, 'format')
        datatype = InHeader.format;
    else
        datatype = 'float';
    end

else
    ICdata = '10000';
    datatype = 'float';
end

if strcmp(datatype, 'float')
    StrDatatype = 'float';
    datatype = 'float32';
    StrOffset = '0';
else
    StrDatatype = 'unsigned short int';
    datatype = 'uint16';
    StrOffset = '100';
    R = R + 100;            % data offset value for negative protection
end

Header = {
'{\n'
'HEADER_BYTES= 5632;\n'
'BYTE_ORDER=big_endian;\n'
'COMMENT=Original template editted by mlw 12/10/96;\n'
'COMPRESSION=None;\n'
'DETECTOR_NAMES=GOLD_;\n'
'DETECTOR_NUMBER=1;\n'
'DIM=2;\n'
'DTDISPLAY_ORIENTATION=+X+Y;\n'
['Data_type=',StrDatatype,';\n']   % to save as floating point, Original was 'unsigned short int'
'GOLD_DETECTOR_DESCRIPTION=GOLD in 400;\n'
'GOLD_DETECTOR_GAIN=1.0;\n'
'GOLD_DETECTOR_SIZE=150.0 150.0;\n'
'GOLD_GONIO_DESCRIPTION=A simple detector goniostat;\n'
'GOLD_GONIO_NAMES=RotZ RotX/Swing RotY TransX TransY TransZ/Dist;\n'
'GOLD_GONIO_NUM_VALUES=6;\n'
'GOLD_GONIO_UNITS=deg deg deg mm mm mm;\n'
'GOLD_GONIO_VALUES=0.000 0.000 0.000 0.000 0.000 130.000;\n'
'GOLD_GONIO_VECTORS=0.000 0.000 1.000 1.000 0.000 0.000 0.000 1.000 0.000 1.000 0.000 0.000 0.000 1.000 0.000 0.000 0.000 -1.000;\n'
'GOLD_SPATIAL_DISTORTION_VECTORS=-1 0 0 -1;\n'
'ROTATION=0.0 0.20 0.20 4 0 0 0 100 1 0;\n'
'ROTATION_AXIS_NAME=Omega;\n'
'ROTATION_VECTOR=-1.0 0.0 0.0;\n'
'SATURATED_VALUE=65000;\n'
'SCAN_ROTATION=300.0 360.0 0.20 4 0 0 0 100 1 0;\n'
'SCAN_ROTATION_AXIS_NAME=Omega;\n'
'SCAN_ROTATION_VECTOR=-1.0 0.0 0.0;\n'
'SCAN_TITLE=start end inc time nOsc nDark nDup nDlim nDC nDCup;\n'
'SOURCE_CROSSFIRE=0.0 0.0 0.0 0.0;\n'
'SOURCE_ORIENT_ANGLES= 0 0;\n'
'SOURCE_POLARZ=0.99 0 1 0;\n'
'SOURCE_REFINE_FLAGS=0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;\n'
'SOURCE_SIZE=0.0 0.0 0.0 0.0;\n'
'SOURCE_SPECTRAL_DISPERSION=0.0002 0.0002;\n'
'SOURCE_VECTORS=0.0 0.0 1.0  1 0 0 0 1 0;\n'
'SOURCE_WAVELENGTH=1 1.033;\n'
'TYPE=mad;\n'
'LOGNAME=root;\n'
'SOURCE_INTENSITY=0.000000;\n'
'BEAMLINE_NAME=GOLD_;\n'
'GOLD_MODE=Expose;\n'
'GOLD_EXPOSURE_TIME=0.500;\n'
'GOLD_EXPOSURE_WAIT=0.100;\n'
'GOLD_NUMBERIMAGES=16.000;\n'
'GOLD_IMAGE_SIZE=Binned;\n'
'GOLD_SAMPLE_DESCRIPTION=gold 2004-06-02#006;\n'
'GOLD_EXPERIMENT_ID=12 ID C;\n'
'GOLD_DATAFILENAME=rw060405i85.???;\n'
'GOLD_DATADIR=saxs/Mai04/winans1/;\n'
'GOLD_DATADISK=/net/gold/data1/;\n'
'GOLD_INCRSEQ=1;\n'
'GOLD_STARTSEQ=1;\n'
'GOLD_SR_FILL_NUMBER=14;\n'
'GOLD_SR_ORBIT_CORRECTION=None;\n'
'GOLD_ACIS_SHUTTER_OPEN=Open;\n'
'GOLD_UN_GAP_AVG_MM=26.1633;\n'
'GOLD_UN_GAP_ENERGY_KEV=12.100;\n'
'GOLD_APS1_CCD_BINNING_MODE=Bin;\n'
'GOLD_APS1_CCD_READOUT_MODE=Normal;\n'
'GOLD_APS1_CCD_TRIGGER_SRC=Lemo;\n'
'GOLD_APS1_CCD_TIMING_SRC=External;\n'
'GOLD_APS1_CCD_INTERNAL_TMR=0.00100;\n'
'GOLD_APS1_CCD_PHOSPHOR_TM=50;\n'
'GOLD_APS1_CCD_TEST_PATTERN=Line_Count;\n'
'GOLD_APS1_MUX_DATA_SOURCE=CCD_Head;\n'
'GOLD_APS1_MUX_PING_PONG=On;\n'
'GOLD_GSC_CONTROL_SOURCE=Timer;\n'
'GOLD_GSC_EXPOSURE_DELAY=On;\n'
'GOLD_GSC_GATE_STRETCH=On;\n'
'GOLD_GSC_DELAY_VALUE=20.00;\n'
'GOLD_GSC_STRETCH_VALUE=40.00;\n'
'GOLD_GSC_SHUTTER_GATE=Enabled;\n'
'GOLD_GSC_EXPOSE_GATE=Enabled;\n'
'GOLD_GSC_GATE1_GATE=Enabled;\n'
'GOLD_GSC_GATE2_GATE=Disabled;\n'
'GOLD_GSC_KEVEX_GATE=Disabled;\n'
'GOLD_SCLC1_COUNTS_09=0;\n'
'GOLD_SCLC1_COUNTS_10=0;\n'
'GOLD_SCLC1_COUNTS_11=0;\n'
'GOLD_SCLC1_COUNTS_12=0;\n'
'GOLD_SCLC1_COUNTS_13=0;\n'
'GOLD_SCLC1_COUNTS_14=0;\n'
'GOLD_SCLC1_COUNTS_15=0;\n'
'GOLD_SCLC1_COUNTS_16=0;\n'
'GOLD_SCLC1_TIME_SEC=0.000;\n'
'GOLD_SCLS1_FREQUENCY_HZ=0;\n'
'GOLD_SCLS1_COUNTS_01=0;\n'
'GOLD_SCLS1_COUNTS_02=0;\n'
'GOLD_SCLS1_COUNTS_03=0;\n'
'GOLD_SCLS1_COUNTS_04=0;\n'
'GOLD_SCLS1_COUNTS_05=0;\n'
'GOLD_SCLS1_COUNTS_06=0;\n'
'GOLD_SCLS1_COUNTS_07=0;\n'
'GOLD_SCLS1_COUNTS_08=0;\n'
'GOLD_SCLS1_COUNTS_09=0;\n'
'GOLD_SCLS1_COUNTS_10=0;\n'
'GOLD_SCLS1_COUNTS_11=0;\n'
'GOLD_SCLS1_COUNTS_12=0;\n'
'GOLD_SCLS1_COUNTS_13=0;\n'
'GOLD_SCLS1_COUNTS_14=0;\n'
'GOLD_SCLS1_COUNTS_15=0;\n'
'GOLD_SCLS1_COUNTS_16=0;\n'
'GOLD_SCLS1_TIME_SEC=0.000;\n'
'ID12_AngleToEnergy=12.0000;\n'
'ID12_SLIDE_RBV=12.0001;\n'
'ID12_m1_TopSlit=1.2446;\n'
'ID12_EnergySet=12.0000;\n'
'SIZE1=1536;\n'
'SIZE2=1536;\n'
'GOLD_NONUNF_TYPE=Dark_nonunf;\n'
'GOLD_NONUNF_INFO=nonunf dark;\n'
'GOLD_SPATIAL_DISTORTION_TYPE=Interp_spatial;\n'
'GOLD_SPATIAL_DISTORTION_INFO=distor;\n'
'GOLD_DETECTOR_DIMENSIONS=1536 1536;\n'
'SCAN_MODE=Expose;\n'
'SCAN_SEQ_INFO=1 1 16;\n'
'SCAN_TEMPLATE=/net/gold/data1/saxs/Mai04/winans1/rw060405i85.???;\n'
'GOLD_APS1_MUX_CHANNEL=A;\n'
'GOLD_EXPOSE_TIMESTAMP=06/04/04 12:53:18;\n'
'GOLD_SR_CURRENT_MA=100.2;\n'
'ID12_SCLC1_COUNTS_01=5399865;\n'
['ID12_SCLC1_COUNTS_02=', ICdata, ';\n']
'ID12_SCLC1_COUNTS_03=61451;\n'
'ID12_SCLC1_COUNTS_04=393485;\n'
'FILENAME=/net/gold/data1/saxs/Mai04/winans1/rw060405i85.016;\n'
'GOLD_NONUNF_TYPE=None;\n'
'GOLD_SPATIAL_DISTORTION_TYPE=Simple_spatial;\n'
'GOLD_SPATIAL_DISTORTION_INFO=  768.0000  768.0000   0.09800   0.09800;\n'
['IMAGE_OFFSET=', StrOffset, ';\n']
'}\n'
};


%datatype = 'uint16';
%datatype = 'float32';
fseek(fid, 0, -1);
for i=1:numel(Header)
    fprintf(fid, char(Header(i)));
end
%for i=0:5632
%    fwrite(fid, 'a', 'uchar')';
%end
%R = fix(R);t = find(R) < 0;R(t) = 0;
while ftell(fid) < 5633
    fwrite(fid, ' ', 'uchar');
end

fwrite(fid, R', datatype);
fclose(fid);
