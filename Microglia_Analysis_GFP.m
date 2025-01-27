% MicrogliaAnalysisGFP

clear all
close all

addpath(genpath('\\file.phhp.ufl.edu\data\home\edward.luca\Documents\GitHub\microglia_count_coloc'))
rootfilefolder=fullfile('C:\Users\edward.luca\Desktop');
CTBfilefolder=fullfile(rootfilefolder, 'CTBfilefolder_Green');
listing=dir('C:\Users\edward.luca\Github\microglia_count_coloc\Green_Microglia_overlay\Iba-1_APOE4_R22_92_sect3_20x_2_Overlay.tif')

% addpath(genpath('\\file.phhp.ufl.edu\data\home\edward.luca\Documents\GitHub\microglia_count_coloc'))
% rootfilefolder=fullfile('C:\Users\edward.luca\Desktop');
% CTBfilefolder=fullfile(rootfilefolder, 'Microglia Analysis');
% listing=dir('C:\Users\edward.luca\Desktop\Microglia Analysis\Data IBA1\944426-2CtBCDFITC&IBA1_01\944426-2CtBCDFITC&IBA1_Overlay.tif')

% addpath(genpath('H:\MATLAB'))
% rootfilefolder=fullfile('C:\Users\yasinbseven\Desktop');
% CTBfilefolder=fullfile(rootfilefolder, 'Data');
% listing=dir('C:\Users\yasinbseven\Desktop\Data\**\*Overlay*.tif')

%New image size 960 x 720 = 691200, 20x
%Binning: 2x2 binning, so 0.37744 x 2 = 0.75488

resolution=0.75488; %microns/pixel
r=35; %radius in microns
dilated_r=100;
pxl_radius=round(r/resolution);
threshold_percentile=99.0;
cell_size = 200; %600du

files = {listing.name}';
folders = {listing.folder}';
resultsperimage=[];
circ=[];
props=[];

%%
% iii=2;


for iii=1:length(files)
% for iii=1:3

XXX = sprintf('%d of %d done.',iii,length(files));
disp(XXX)

close all
clearvars -except resultsperimage resultsperimage2 resolution r dilated_r pxl_radius pxl_dilated_radius rootfilefolder ...
    CTBfilefolder listing files iii idx4results ctb_threshold_percentile cell_size R Rm Rf Rthreshold Rthreshold2 folders...
    threshold_percentile

clearvars props circ ortalama_int

idx4results=0;

currentimage=[]; 
currentimage=imread(fullfile(folders{iii},files{iii}));
% currentimage=imread(fullfile('C:\Users\yasinbseven\Desktop\Data',files{iii}));
a=currentimage;

%% Changing from red to green 
Contrasttemp = medfilt2(a(:,:,1),[100 100]);
a(:,:,1)=a(:,:,1)-Contrasttemp;

Contrasttemp2 = medfilt2(a(:,:,2),[100 100]);
a(:,:,2)=a(:,:,2)-Contrasttemp2;

perkfiltGREEN=a;

%% Setting threshold
[d1,d2]=size(a(:,:,1));
zvector=reshape(a(:,:,1),d1*d2,1);
y = prctile(zvector,threshold_percentile); %%%%%%%%%%%% CTB Threshold
ctb_threshold = im2double(y);

% We have a threshold
[r]=selectcells(a(:,:,2), ctb_threshold, cell_size); %changed cell selection to identify green not red

xystruct=[];

figure(1),
grain = zeros(size(a(:,:,1)));
for i=1:length(r)
    grain(r{i}) = 1;
    xcoord=ceil(r{i}/d1);
    ycoord=r{i}-floor(r{i}/d1)*d1;
    xycoord=[xcoord, ycoord];
    xystruct(i,:)=xycoord(1,:);
end 
imshow(grain);

%%
for i=1:length(r)
    ann=text(xystruct(i,1),xystruct(i,2),num2str(i));
    ann.Color = 'red';
    ann.FontSize = 14;
end
%%

[pathstr,name,ext] = fileparts(fullfile(CTBfilefolder,files{iii}));
folder_name=listing(iii).folder;
folder_name2=folder_name(max(strfind(folder_name,'\')):end)
concat_str=strcat(fullfile(CTBfilefolder), folder_name2)
saveas(gcf,sprintf('%s.png', concat_str))
end




