% This script makes a color surface plot of two PCorr vectors per genotype,
% as in Figure 4D. The data to input needs to be a structure of the form:
% tau_averaged_bin(i_bin).genotype(i_geno).data, where i_bin is the nth 
% time bin and i_geno is the nth genotype. Created by Zoe Talbot in 2016.
clear;
dirIn = 'yourDataDirectory';
cd(dirIn);
load 'yourData.mat';
geno = {'WT', 'KO'};
timeBin = {'25 ms', '40 ms', '125 ms', '250 ms', '1 s', '5 s'};
n_dur=1; % sorting wrt this column
pct_max = 0.7; % used in setting colorbar
pct_min = 0.7;
minNcors = min(tau_averaged_bin(1).genotype(1).data,...
    tau_averaged_bin(1).genotype(2).data);

for i_bin = 1:length(timeBin)
    for i_geno = 1:2
        x = tau_averaged_bin(i_bin).genotype(i_geno).data;

        % Does a random perm of N id's in KO so # of cells is same for
        % genotypes. Only does this for bin @ 25ms, then tracks same cell
        % for other bins. Purpose is so that both genotypes have the same
        % number of correlation values in the Figure.
        if i_bin == 1
            permX = randperm(size(x,1), minNcors); 
            x = [x(permX,1) x(permX,2)];
        else
            x = [x(permX,1) x(permX,2)];
        end      
        [s, ind] = sort(x(:,n_dur),1);
        y = [x(ind,1) x(ind,2)]; % sort 2nd column wrt to frist column tau
      
        if i_geno == 1
            nplot=1;
        else
            nplot=2; % because there are 6 subplots of bins
        end
        y1 = [y; 1 1];
        y2 = [y1  ones(length(y)+1, 1)];
        
        figure(6+i_bin);
        hold on;
        if i_geno == 1
            subplot(1,2,1)
            wt_max(i_bin) = max(y(:));
            wt_min(i_bin) = min(y(:));
            c1(i_bin) = pct_max*wt_max(i_bin);
            c2(i_bin) = pct_min*wt_min(i_bin);
        elseif i_geno == 2
            subplot(1,2,2)
            % this part is added to see if colorbar will work for ko,
            % before I used the same color scale for both geno but wt has
            % larger values so it drowns out ko differences
            %
            ko_max(i_bin) = max(y(:));
            ko_min(i_bin) = min(y(:));
            c1(i_bin) = pct_max*ko_max(i_bin);
            c2(i_bin) = pct_min*ko_min(i_bin);
            %}
        end
        
        surface(y2, 'EdgeColor','none');
        caxis([c2(i_bin) c1(i_bin)]);
        colormap parula;%jet;
        axis tight;
        h=colorbar;
        t=get(h,'Limits');
        set(h,'Ticks',linspace(t(1),t(2),5));
        title(timeBin(i_bin));
        set(gca,'FontSize', 14, 'XTick',[], 'YTick', [1 length(y)]);
        xlabel('0-5 5-10');
        rotateXLabels(gca,45);
        ylabel('Cell Pairs');
        hold on;
    end
    clearvars x y y1 y2 k n ;
end

