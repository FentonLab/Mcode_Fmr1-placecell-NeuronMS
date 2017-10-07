% This script does "leave-one-out" computation used in Figure 5C, which
% computes Pearson's correlation between the absolute value of delta Ipos for 
% a single cell and the absolute value of delta Ipos for the whole ensemble
% with the cell of interest removed. This is done for all cells within the
% ensemble. This scripte requires four structures, two for each genotype, 
% with the following format: ko{i_file}.deltaIposAbs(:,j_cell) where i_file
% is the ith recordning (ith ensemble) and j_cell is the jth cell. The
% second element in the structure needs to be of the form 
% ko{i_file}.leaveOneout(:,j_cell), where j_cell in this case is the sum of
% delta Ipos for the ensemble without the jth cell. This same structure needs 
% to be present for the other genotype, titled "wt". Created on 9/6/2016 by
% Zoe Talbot.
clear;
cd 'yourDataDirectory';
load 'yourData.mat';
for i_file=1:length(ko)
    for j_cell=1:size(ko{i_file}.deltaIpos,2)
        [r, p] = corrcoef(ko{i_file}.deltaIposAbs(:,j_cell), abs(ko{i_file}.leaveOneout(:,j_cell)));
        if j_cell==1
            x = r(1,2);
        else
            x = [x; r(1,2)];
        end
    end    
    if i_file == 1
        ko_leave1outR_abs = x;
    else
        ko_leave1outR_abs = [ko_leave1outR_abs; x];
    end   
end
clearvars r x i_file j_cell;

for i_file=1:length(wt)
    for j_cell=1:size(wt{i_file}.deltaIpos,2)
        [r, p] = corrcoef(wt{i_file}.deltaIposAbs(:,j_cell), abs(wt{i_file}.leaveOneout(:,j_cell)));
        if j_cell==1
            x = r(1,2);
        else
            x = [x; r(1,2)];
        end
    end
    if i_file == 1
        wt_leave1outR_abs = x;
    else
        wt_leave1outR_abs = [wt_leave1outR_abs; x];
    end
end
clearvars r x i_file j_cell;
