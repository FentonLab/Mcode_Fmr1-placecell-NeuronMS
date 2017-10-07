% Plots average room and arena information, +/- sem. Computes basic statistics
% to compare spatial information. Data format should be as follows: 
% Column1= timeStep, Column2= Room Ipos, Column3=Arena Ipos, Column4= Delta Ipos.
% Created by Zoe Talbot in 2016.
cd 'yourDirectory';
clear
load 'yourData.mat';

% Groups Ipos of all recordings within a genotype
for j = 1:length(wt_files)
    wt_avgRmIpos(j,1) = mean(wt_data(j).ipos.data(:,2));
    wt_avgArIpos(j,1) = mean(wt_data(j).ipos.data(:,3));
    
    wt_maxRmIpos(j,1) = max(wt_data(j).ipos.data(:,2));
    wt_maxArIpos(j,1) = max(wt_data(j).ipos.data(:,3));
end

for i = 1:length(ko_files)
    ko_avgRmIpos(i,1) = mean(ko_data(i).ipos.data(:,2));
    ko_avgArIpos(i,1) = mean(ko_data(i).ipos.data(:,3));
    
    ko_maxRmIpos(i,1) = max(ko_data(i).ipos.data(:,2));
    ko_maxArIpos(i,1) = max(ko_data(i).ipos.data(:,3));
end

%%%%%%%%%%%%% Bar Plot
lbl = {'WT Room', 'WT Arena', 'KO Room', 'KO Arena'};
figure;
set(gca,'fontSize', 14);
bar(1,mean(wt_avgRmIpos) ,'b');
hold on;
errorbar(1,mean(wt_avgRmIpos), std(wt_avgRmIpos)/sqrt(length(wt_avgRmIpos)));

bar(2,mean(ko_avgRmIpos) ,'r');
errorbar(2,mean(ko_avgRmIpos), std(ko_avgRmIpos)/sqrt(length(ko_avgRmIpos)));

bar(3,mean(wt_avgArIpos) ,'b');
errorbar(3,mean(wt_avgArIpos), std(wt_avgArIpos)/sqrt(length(wt_avgArIpos)));

bar(4,mean(ko_avgArIpos) ,'r');
errorbar(4,mean(ko_avgArIpos), std(ko_avgArIpos)/sqrt(length(ko_avgArIpos)));

ylabel 'Average Ipos';
set(gca,'XTickLabel','');
set(gca,'xticklabel',lbl);

% Normality test
[~,p(1),s(1)]=swtest(wt_avgRmIpos);
[~,p(2),s(2)]=swtest(wt_avgArIpos);
[~,p(3),s(3)]=swtest(ko_avgRmIpos);
[~,p(4),s(4)]=swtest(ko_avgArIpos);

% Parametric and non-parametric tests between genotypes
statsRm = mwwtest(wt_avgRmIpos,ko_avgRmIpos);
statsAr = mwwtest(wt_avgArIpos,ko_avgArIpos);
[~,pRm,~,statsRm] = ttest2(wt_avgRmIpos,ko_avgRmIpos);
[~,pAr,~,statsAr] = ttest2(wt_avgArIpos,ko_avgArIpos);


