% This script is a tool to determine how many passes need to be shared
% between two cells in order to see a significant difference between
% two vectors of z-values. The data used in this script where computed by
% do_overdisp_pairs_zt, where the output you want to use are 1) a file 
% containing the overdispersion values for all considered cell pairs and 
% 2) The the number of passes (times animal passed through place fields of
% both cells and meets criteria). Created by Zoe Talbot in 2016.

%{
% FYI import has the format:
% col1: #runs cell pairs meet culling criterion
% col2: correlation between z values for each cell pair in recordings you
considered
% col3: tstatistic that correlation is significantly different from a
% correlation coming from a normal distribution with mean zero.
%}

clear;
cd 'your directory which holds imported data';
r_wt(:,1) = load('overdisp_Npasses_161121_wt');
r_wt(:,2) = load('overdisp_corr_161121_wt');
r_ko(:,1) = load('overdisp_Npasses_161121_ko');
r_ko(:,2) = load('overdisp_corr_161121_ko');

for n_pass=1:60 %
    
    [wt_ind,~] = find(r_wt(:,1)>=n_pass);
    [ko_ind,~] = find(r_ko(:,1)>=n_pass);
    
    z_wt =.5.*log((1+r_wt(wt_ind,2))./(1-r_wt(wt_ind,2)));
    z_ko =.5.*log((1+r_ko(ko_ind,2))./(1-r_ko(ko_ind,2)));

   % x=n_pass
    stats=mwwtest(z_wt, z_ko);
    [H,P,ci,STATS] = ttest2(z_wt, z_ko);
    s(n_pass)=STATS;
    p(n_pass,1)=n_pass;
    p(n_pass,2)=P;  
    h(n_pass,1)=H; 
end

mWT= mean(r_wt(wt_ind,2));
mKO = mean(r_ko(ko_ind,2));
semWT = std(r_wt(wt_ind,2))/sqrt(length(r_wt(wt_ind,2)));
semKO = std(r_ko(ko_ind,2))/sqrt(length(r_ko(ko_ind,2)));
