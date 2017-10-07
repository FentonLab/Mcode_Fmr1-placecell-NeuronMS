% Imports raw Ipos data, creating one structure for each genotype: wt_data(i_file).ipos
% ko_data(i_file).ipos, where i_file is the ith recording with whatever 
% filename tag you specified. Column1= timeStep, Column2= Room Ipos, 
% Column3=Arena Ipos, Column4= Delta Ipos. Created by Zoe Talbot in 2016.
clear;
cd 'yourDirectory containing Ipos data for genotype #1';

% Imports files with ipos
wt_files = dir('*RmXAr_4.mpinfo');
for i_file = 1:length(wt_files)
    wt_data(i_file).ipos = importdata(wt_files(i_file).name);
end

cd 'yourDirectory containing Ipos data for genotype #2';
ko_files = dir('*RmXAr_4.mpinfo');
for i_file = 1:length(ko_files)
    ko_data(i_file).ipos = importdata(ko_files(i_file).name);
end