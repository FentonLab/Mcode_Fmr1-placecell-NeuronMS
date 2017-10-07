% This script is used to plot histograms of PCorr vectors of Kendell's 
% tau correlation, compute and organize basic statistics comparing
% tau between two genotypes, compute basic statistics between lower and 
% upper 50% of distributions for each time scale bin and each genotype. 
% Data is expected to come in a structure of the form: 
% tau_averaged_bin(i_bin).genotype(n).data, where i_bin is the nth bin and 
% n is the nth genotype. Created by Zoe Talbot in 2016.
clear;
cd 'dataDirectory';
load 'data.mat';
time_bins={'25ms', '40ms', '125ms', '250ms', '1s', '5s'};
figure;
for i_bin = 1:length(time_bins)
    avg_wt = tau_averaged_bin(i_bin).genotype(1).data;
    avg_ko = tau_averaged_bin(i_bin).genotype(2).data;
    
    % Descriptive statistics 
    meanBoth(:,i_bin) = [mean(avg_wt); mean(avg_ko)];
    stdBoth(:,i_bin) = [std(avg_wt); std(avg_ko)];
    semBoth(:,i_bin) = [std(avg_wt)/sqrt(length(avg_wt)); std(avg_ko)/sqrt(length(avg_ko))];
    medianBoth(:,i_bin) = [median(avg_wt); median(avg_ko)];
    minBoth(:,i_bin) = [min(avg_wt); min(avg_ko)];
    maxBoth(:,i_bin) = [max(avg_wt); max(avg_ko)];
    
    wt_pos =avg_wt(avg_wt > median(avg_wt));
    wt_neg = avg_wt(avg_wt < median(avg_wt));
    ko_pos = avg_ko(avg_ko >median(avg_ko));
    ko_neg = avg_ko(avg_ko <median(avg_ko));
    
    % Plot histograms
    subplot(1,6,i_bin);
    title(time_bins(i_bin));
    hold on;
    h=histogram(avg_wt);
    h.Normalization='probability';
    h.EdgeColor = 'b';
    h.DisplayStyle ='stairs';
    
    h1=histogram(avg_ko);
    h1.DisplayStyle ='stairs';
    h1.EdgeColor = 'r';
    h1.Normalization='probability';
    minBin = min(h.BinWidth,h1.BinWidth);
    h.BinWidth = minBin;
    h1.BinWidth = minBin;
    xlabel '\tau';
    ylabel 'Probability';

    % Fisher z-transform, to use for statistical comparisons
    avg_wt = .5.*log((1+avg_wt)./(1-avg_wt));
    avg_ko = .5.*log((1+avg_ko)./(1-avg_ko));
    wt_pos = .5.*log((1+wt_pos)./(1-wt_pos));
    wt_neg = .5.*log((1+wt_neg)./(1-wt_neg));
    ko_pos = .5.*log((1+ko_pos)./(1-ko_pos));
    ko_neg = .5.*log((1+ko_neg)./(1-ko_neg));
    
    % Check for normality
    [~, normality_wt(i_bin).p, normality_wt(i_bin).stats] = swtest(avg_wt(isfinite(avg_wt)));
    [~, normality_ko(i_bin).p, normality_ko(i_bin).stats] = swtest(avg_ko);
    
    % Statistical tests to compare genotypes
    [~, bet_geno_overall(i_bin).p,~, bet_geno_overall(i_bin).stats] = ttest2(avg_wt(isfinite(avg_wt)), avg_ko);
    mww_overall(i_bin) =mwwtest(avg_wt(isfinite(avg_wt)), avg_ko);
    
    % Statistics between lower and upper 50% of respective distributions
    [~,bin(i_bin).Ppos,~,bin(i_bin).STATSpos] = tstest2(wt_pos, ko_pos);
    [~,bin(i_bin).Pneg,~,bin(i_bin).STATSneg] = tstest2(wt_neg, ko_neg);
    
    clearvars avg_wt avg_ko;
end
