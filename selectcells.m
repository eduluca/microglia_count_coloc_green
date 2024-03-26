function [r]=selectcells(inputplane, threshold, minimum_cell_size)

a=inputplane;
bw = im2bw(a, threshold); %assumes threshold = 65536*threshold. fixed number
cc = bwconncomp(bw, 26);
tt=1;
r=[];
for i=1:length(cc.PixelIdxList)
if length(cc.PixelIdxList{i})>minimum_cell_size %Get cells of size 2600 pixels or more.
r{tt}=cc.PixelIdxList{i};
tt=tt+1;
end
end
% 
% plot each cell

% figure,
% grain = false(size(bw));
% 
% for i=1:length(r)
% grain(r{i}) = true;
% end
% 
% imshow(grain);
% % hold on
% pause(1)

% close all

% 
% for i=1:length(r)
% grain = false(size(bw));
% grain(r{i}) = true;
% % figure, 
% imshow(grain);
% hold on
% pause(0.01)
% % close all
% end
% close all
