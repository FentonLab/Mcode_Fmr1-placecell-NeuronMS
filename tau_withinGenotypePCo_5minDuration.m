% This script is used to 1) plot empirical cumulative distribution function 
% for each time bin of PCorr vectors of Kendell's tau correlation and 
% 2) compute and organize basic statistics comparing tau between two time
% durations withn a genotype. Data is expected to come in a structure of the
% form: tau_averaged_bin(i_bin).genotype(n).data(:,1:2), where i_bin is the 
% nth bin and n is the nth genotype. The script expects each structure 
% element to have two columns (e.g. two 5 minute durations to compare.
% Created by Zoe Talbot in 2016.
clear;
cd 'yourDataDirectory';
load 'yourData.mat';
for i_bin = 1:6
    x1 = tau_averaged_bin(i_bin).genotype(1).data(:,1);
    x2 = tau_averaged_bin(i_bin).genotype(1).data(:,2);
    y1 = tau_averaged_bin(i_bin).genotype(2).data(:,1);
    y2 = tau_averaged_bin(i_bin).genotype(2).data(:,2);
    
    [PCo(1,i_bin), pval(1,i_bin)] = corr(x1, x2);
    [PCo(2,i_bin), pval(2,i_bin)] = corr(y1, y2);
   
    % Fisher z-transform
    x1 = .5.*log((1+x1)./(1-x1));
    x2 = .5.*log((1+x2)./(1-x2));
    y1 = .5.*log((1+y1)./(1-y1));
    y2 = .5.*log((1+y2)./(1-y2));
      
    subplot(1,6,i_bin);
    h =cdfplot(x1); hold on;
    h1 =cdfplot(y1); 
    h.Color ='b';
    h.LineWidth = 1;
    h1.Color ='r';
    h1.LineWidth = 1;
    xlabel 'z-score (\tau)';
    ylabel 'Cumulative distribution';
    set(gca,'Fontsize',12);
    
    % Checking for normality
    [~, normality_wt(i_bin).p(1), normality_wt(i_bin).stats(1)] = swtest(x1);
    [~, normality_wt(i_bin).p(2), normality_wt(i_bin).stats(2)] = swtest(x2);
    [~, normality_ko(i_bin).p(1), normality_ko(i_bin).stats(1)] = swtest(y1);
    [~, normality_ko(i_bin).p(2), normality_ko(i_bin).stats(2)] = swtest(y2);
    
    %paired t-test
    [~, durComp_wt(i_bin).p, ci, durComp_wt(i_bin).stats] = ttest(x1(isfinite(x1)), x2(isfinite(x1)));
    [~, durComp_ko(i_bin).p, ci, durComp_ko(i_bin).stats] = ttest(y1, y2);
    
    % non-parametric paired t test
    [WilcoxonSR_wt(i_bin).p,~,WilcoxonSR_wt(i_bin).stats] = signrank(x1(isfinite(x1)), x2(isfinite(x1)));
    [WilcoxonSR_ko(i_bin).p,~,WilcoxonSR_ko(i_bin).stats] = signrank(y1, y2);
       
    % Descriptive statistics
    meanBoth1(:,i_bin) = [mean(x1); mean(y1)];
    stdBoth1(:,i_bin) = [std(x1); std(y1)];
    semBoth1(:,i_bin) = [std(x1)/sqrt(length(x1)); std(y1)/sqrt(length(y1))];
    medianBoth1(:,i_bin) = [median(x1); median(y1)];
    %}
    meanBoth2(:,i_bin) = [mean(x2); mean(y2)];
    stdBoth2(:,i_bin) = [std(x2); std(y2)];
    semBoth2(:,i_bin) = [std(x2)/sqrt(length(x2)); std(y2)/sqrt(length(y2))];
    medianBoth2(:,i_bin) = [median(x2); median(y2)];
    
    clearvars x1 x2 y1 y2 wt ko;
end
