% MicrogliaAnalysisGFP_final

clear all
close all

addpath(genpath('\\file.phhp.ufl.edu\data\home\edward.luca\Documents\GitHub\microglia_count_coloc'))
rootfilefolder = 'C:\Users\edward.luca\Desktop\overlay_images_only_green';
CTBfilefolder = 'C:\Users\edward.luca\Desktop\CTBfilefolder_Green';
listing = dir(fullfile(rootfilefolder, '*.tif')); % List only tif files

% New image size 960 x 720 = 691200, 20x
% Binning: 2x2 binning, so 0.37744 x 2 = 0.75488

resolution = 0.75488; % microns/pixel
r = 35; % radius in microns
threshold_percentile = 99.0;
cell_size = 200; % 600du

for file_idx = 83:length(listing)
    currentfile = listing(file_idx);
    XXX = sprintf('%d of %d done.', file_idx, length(listing));
    disp(XXX)

    close all
    clearvars -except resolution r pxl_radius rootfilefolder CTBfilefolder listing currentfile threshold_percentile cell_size

    currentimage = imread(fullfile(rootfilefolder, currentfile.name));
    a = currentimage;

    %% Changing from red to green 
    Contrasttemp = medfilt2(a(:,:,1), [100 100]);
    a(:,:,1) = a(:,:,1) - Contrasttemp;

    Contrasttemp2 = medfilt2(a(:,:,2), [100 100]);
    a(:,:,2) = a(:,:,2) - Contrasttemp2;

    perkfiltGREEN = a;

    %% Setting threshold
    [d1, d2] = size(a(:,:,1));
    zvector = reshape(a(:,:,1), d1*d2, 1);
    y = prctile(zvector, threshold_percentile); % CTB Threshold
    ctb_threshold = im2double(y);

    % We have a threshold
    [r] = selectcells(a(:,:,2), ctb_threshold, cell_size); % changed cell selection to identify green not red

    xystruct = [];

    figure(1),
    grain = zeros(size(a(:,:,1)));
    for i = 1:length(r)
        grain(r{i}) = 1;
        xcoord = ceil(r{i}/d1);
        ycoord = r{i} - floor(r{i}/d1)*d1;
        xycoord = [xcoord, ycoord];
        xystruct(i,:) = xycoord(1,:);
    end 
    imshow(grain);

    for i = 1:length(r)
        ann = text(xystruct(i,1), xystruct(i,2), num2str(i));
        ann.Color = 'red';
        ann.FontSize = 14;
    end

    % Print image name and total binary microglia count
    [~, name, ~] = fileparts(currentfile.name);
    fprintf('Image: %s\n', name);
    fprintf('Total Binary Microglia Count: %d\n', length(r));

    % Save the final binary count image
    [~, name, ~] = fileparts(currentfile.name);
    binarycount_filename = [name, '_binarycount.tif'];
    binarycount_filepath = fullfile(CTBfilefolder, binarycount_filename);
    saveas(gcf, binarycount_filepath);
end
