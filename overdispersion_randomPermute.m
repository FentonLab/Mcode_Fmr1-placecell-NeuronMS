% This script takes in a list of pairs of z-value vectors that were computed using
% the bash shell script do_overdisp_pairs_zt. It then randomly permutes one
% z vector from the pair. This computation was done as a control for
% Figure4B. Created by Zoe Talbot in 2017.

clear
for ii = 1:2
    if ii == 1
        cd 'Directory location of ONLY the cell pair files, genotype #1';
    else
        cd 'Directory location of ONLY the cell pair files, genotype #2';
    end
    cells = dir('*z_val*'); % this is a common filename tag for my files
    for jj = 1:2 % there are two cell pairs to compare
        cd(cells(jj).name);
        if jj == 1
            zs1 = dir('*zs*');
            len = length(zs1);
            for n = 1:len
                cellA(n).zVec = importdata(zs1(n).name);
            end
        else
            zs2 = dir('*zs*');
            len = length(zs2);
            for n = 1:len
                cellB(n).zVec = importdata(zs2(n).name);
            end
        end
        cd ..;
    end
    
    for jj = 1:length(zs2)% could just as well be zs1
        cell1 = cellA(jj).zVec;
        cell2 = cellB(jj).zVec;
        rand = randperm(length(cell2));
        r = corrcoef(cell1, cell2(rand));
        r1 = corrcoef(cell1,cell2);
        if ii == 1
            if length(r) > 1
                rval_rand_wt(jj) = r(2,1);
                rval_wt(jj) = r1(2,1);
                Npass_wt(jj) = length(cell1);
            else
                rval_rand_wt(jj) = r;
                rval_wt(jj) = r1;
                Npass_wt(jj) = length(cell1);
            end
        elseif ii == 2
            if length(r) > 1
                rval_rand_ko(jj) = r(2,1);
                rval_ko(jj) = r1(2,1);
                Npass_ko(jj) = length(cell1);
            else
                rval_rand_ko(jj) = r;
                rval_ko(jj) = r1;
                Npass_ko(jj) = length(cell1);
            end
        end
    end
    clearvars zs1 zs2 cellA cellB;
end
n_pass = 30;
rval_rand_wt_Thres = rval_rand_wt(Npass_wt>=n_pass);
rval_rand_ko_Thres = rval_rand_ko(Npass_ko>=n_pass);

    z_wt_rand =.5.*log((1+rval_rand_wt_Thres)./(1-rval_rand_wt_Thres));
    z_ko_rand =.5.*log((1+rval_rand_ko_Thres)./(1-rval_rand_ko_Thres));

rval_wt_Thres = rval_wt(Npass_wt>=n_pass);
rval_ko_Thres = rval_ko(Npass_ko>=n_pass);

    z_wt =.5.*log((1+rval_wt_Thres)./(1-rval_wt_Thres));
    z_ko =.5.*log((1+rval_ko_Thres)./(1-rval_ko_Thres));

 [H,P,CI,STATS] = ttest2(z_wt_rand ,z_ko_rand)
 [H,P,CI,STATS] = ttest2(z_wt ,z_ko)


STATS = mwwtest(z_wt_rand ,z_ko_rand)


