% This script serves as the top module for stage I registeration
clear;clc;
%% USER PARAMETERS

DatasetDirMaster = 'D:\ImageRegisteration\Datasets\Dataset1\RAW';
DatasetDirSlave = DatasetDirMaster;
MasterChannel = 'NIR';
SlaveChannel = 'RED';
Stage1OutputDirMaster = 'D:\ImageRegisteration\Datasets\Dataset1\Output';
Stage1OutputDirSlave = Stage1OutputDirMaster;


% Image params
Handbag.Master.FocalLengthX = 3.98;   % mm - along x axis
Handbag.Master.FocalLengthY = 3.98;   % mm - along y axis
Handbag.Master.PPX = 2.48328;        % mm - X principal point 
Handbag.Master.PPY = 1.83502;        % mm - Y principal point 
Handbag.Master.CCDX = 4.8;            % mm - CCD width (along X)
Handbag.Master.CCDY = 3.6;            % mm - CCD height (along Y)
Handbag.Master.nPixelX = 1280;        % pixels - along X axis
Handbag.Master.nPixelY = 960;         % pixels - along Y axis
Handbag.Master.FisheyeAffineMat = [1667.1345,0;0,1666.98772];
Handbag.Master.FisheyePoly = [0,1,0.008259873,-0.243498654];
Handbag.Master.RigRelatives = [0.0789193623702853,0.277227087194982,-0.19312133608997];

Handbag.Slave.FocalLengthX = 3.98;   % mm - along x axis
Handbag.Slave.FocalLengthY = 3.98;   % mm - along y axis
Handbag.Slave.PPX = 2.460013;        % mm - X principal point 
Handbag.Slave.PPY = 1.608237;        % mm - Y principal point 
Handbag.Slave.CCDX = 4.8;            % mm - CCD width (along X)
Handbag.Slave.CCDY = 3.6;            % mm - CCD height (along Y)
Handbag.Slave.nPixelX = 1280;        % pixels - along X axis
Handbag.Slave.nPixelY = 960;         % pixels - along Y axis
Handbag.Slave.FisheyeAffineMat = [1666.788691348,0,0,1664.780616728];
Handbag.Slave.FisheyePoly = [0,1,0.009280102,-0.147406116];
Handbag.Slave.RigRelatives = [-0.00243169504857684,-0.291106828562826,-0.0380501642393399];


%% INITIALIZATION
FilelistMaster = dir([DatasetDirMaster '\*' MasterChannel '*']);
FilelistSlave = dir([DatasetDirSlave '\*' SlaveChannel '*']);

if length(FilelistMaster)~=length(FilelistSlave)
    error('unequal no. of master and slave images');
end

%% ALGORITHM

for k=1:length(FilelistMaster)
    
    % READ THE IMAGE
    MasterImg = ReadImageS1([DatasetDirMaster '\' FilelistMaster(k).name]);
    SlaveImg = ReadImageS1([DatasetDirSlave '\' FilelistSlave(k).name]);
    
    % PROCESS IMAGES
    [MasterImgS1,SlaveImgS1] = StageIReg(MasterImg,SlaveImg,Handbag);
    
    % SAVE TO DISK
    WriteImageS1(MasterImgS1,Stage1OutputDirMaster,FilelistMaster(k).name,'_S1');
    WriteImageS1(SlaveImgS1,Stage1OutputDirSlave,FilelistSlave(k).name,'_S1');
    
    % UPDATE THE USER
    fprintf('%.0f%% done - %s processed\n',k/length(FilelistMaster)*100,FilelistSlave(k).name);
end


%% VISUALIZATION

