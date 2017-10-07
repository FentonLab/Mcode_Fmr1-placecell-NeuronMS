% This script concatenates tau values from different recordings (of any
% duration). Define recordings you want to group in sess2group. Output to
% use in other tau related scripts is the structure named,
% tau_averaged_bin, where tau_averaged_bin(i).genotype(j).data and i is the
% ith time scale bin and j is the jth genotype. Created by Zoe Talbot in
% 2016.
clear;
dirIn = 'yourDataDirectory';
cd(dirIn);
sess2group={'tau_bigbox_5min_M16.mat', 'tau_st1_5min_M16.mat'}; % list as many mat files you want to group
for i_sess = 1:length(sess2group)
    load(sess2group{i_sess});
    if i_sess == 1
        
        x1 = wt_tau_b25;
        x2 = wt_tau_b40;
        x3 = wt_tau_b125;
        x4 = wt_tau_b250;
        x5 = wt_tau_b1000;
        x6 = wt_tau_b5000;
        
        y1 = ko_tau_b25;
        y2 = ko_tau_b40;
        y3 = ko_tau_b125;
        y4 = ko_tau_b250;
        y5 = ko_tau_b1000;
        y6 = ko_tau_b5000;
        
    else
        x1 = [x1; wt_tau_b25];
        x2 = [x2; wt_tau_b40];
        x3 = [x3; wt_tau_b125];
        x4 = [x4; wt_tau_b250];
        x5 = [x5; wt_tau_b1000];
        x6 = [x6; wt_tau_b5000];
        
        y1 = [y1; ko_tau_b25];
        y2 = [y2; ko_tau_b40];
        y3 = [y3; ko_tau_b125];
        y4 = [y4; ko_tau_b250];
        y5 = [y5; ko_tau_b1000];
        y6 = [y6; ko_tau_b5000];
        
    end
end

tau_averaged_bin(1).genotype(1).data = x1;
tau_averaged_bin(2).genotype(1).data = x2;
tau_averaged_bin(3).genotype(1).data = x3;
tau_averaged_bin(4).genotype(1).data = x4;
tau_averaged_bin(5).genotype(1).data = x5;
tau_averaged_bin(6).genotype(1).data = x6;

tau_averaged_bin(1).genotype(2).data = y1;
tau_averaged_bin(2).genotype(2).data = y2;
tau_averaged_bin(3).genotype(2).data = y3;
tau_averaged_bin(4).genotype(2).data = y4;
tau_averaged_bin(5).genotype(2).data = y5;
tau_averaged_bin(6).genotype(2).data = y6;
