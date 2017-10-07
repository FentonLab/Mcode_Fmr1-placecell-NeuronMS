% This script reads a xls file that comprises our database of single-unit
% recordings. You can use it to extract any information you want about the
% data set. In it's current state all basic cell properties are extracted
% and separated based on cell type as defined in the xls document. Some
% descriptive statistics are also included as well as effect size given
% statistical test (in this case d). Created by Zoe Talbot in 2016.

clear;
cd 'yourDirectory';

[num,txt,raw] =  xlsread('OneListToRuleThemAll_161112.xlsx',1);
header ={'width', 'grand_rate',	'pActPix',	'rMapCoh',	'MapIC',	'nSpks',...
    'Burst probability', 'ISI(ms)', 'FldRate', 'pFldSz'};

ts_filename = txt(2:end,10);
genotype = txt(2:end,11);
cell_class = txt(2:end,7);
probe_n = num(:,6);
cluster_n = num(:,7);
field_n = num(:,8); 
width = num(:,9);
rate = num(:,11);
pct_pixels = num(:,12);
mapCoh = num(:,13);
infoCont = num(:,14);
burst_prob = num(:,16);
isi_ms = num(:,17);
fldRate = num(:,19);
pFldSz = num(:,23);

% Use filesIncluded to grab recording you want to include in the statistics. 
% The string should be one that is in the filename of recording of
% interest.
filesIncluded = {'pretrain','blackbox','transferbin','stationary', 'annulus', 'track'};%

ix2 = regexp(genotype,'WT');
ix2 =~ cellfun('isempty',ix2);

ix3 = regexp(genotype,'KO');
ix3 =~ cellfun('isempty',ix3);

for n_cellType = 1:4
    % loop through 3 cell types and get averages pm sem
    if n_cellType == 1
        ix1 = regexp(cell_class,{'PC'});
        ix1 =~ cellfun('isempty',ix1);
    elseif n_cellType == 2
        ix1 = regexp(cell_class,'PYR');
        ix1 =~ cellfun('isempty',ix1);
    elseif n_cellType == 3
        ix1 = regexp(cell_class,'INT');
        ix1 =~ cellfun('isempty',ix1);
    elseif n_cellType == 4
        ix1 = regexp(cell_class,'poorly clustered');
        ix1 =~ cellfun('isempty',ix1);
    end
    
    for i = 1:length(filesIncluded)
        ix = regexp(ts_filename,filesIncluded{i});
        ix =~ cellfun('isempty',ix);
           
        [i_wt,~,~] = find(ix2 == 1 & ix == 1 & ix1 == 1);
        [i_ko,~,~] = find(ix3 == 1 & ix == 1 & ix1 == 1);
               
        w_wt = width(i_wt);
        w_ko = width(i_ko);
        
        r_wt = rate(i_wt);
        r_ko = rate(i_ko);
        
        pPix_wt = pct_pixels(i_wt);
        pPix_ko = pct_pixels(i_ko);
        
        coh_wt = mapCoh(i_wt);
        coh_ko = mapCoh(i_ko);
        
        ic_wt = infoCont(i_wt);
        ic_ko = infoCont(i_ko);
        
        bProb_wt = burst_prob(i_wt);
        bProb_ko = burst_prob(i_ko);
        
        isi_wt = isi_ms(i_wt);
        isi_ko = isi_ms(i_ko);
        
        ts_wt = ts_filename(i_wt);
        ts_ko = ts_filename(i_ko);
        
% this is to get the infield and outfield rates etc.
        if size(ts_wt,1) == 0
            ind_wt = zeros(length(num),1);
        else
            for k = 1:length(ts_wt)
                ix4 = regexp(ts_filename,ts_wt(k));
                ix4 =~ cellfun('isempty',ix4);
                if k == 1
                    ind_wt = ix4;
                else
                    ind_wt = [ind_wt ix4];
                end
                clearvars ix4;
            end
            clearvars k;
        end
        ind_wt1 = sum(ind_wt,2);
        
        if size(ts_ko,1) == 0
            ind_ko = zeros(length(num),1);
        else
            for k1 = 1:length(ts_ko)
                ix5 = regexp(ts_filename,ts_ko(k1));
                ix5 =~ cellfun('isempty',ix5);
                if k1 == 1
                    ind_ko = ix5;
                else
                    ind_ko = [ind_ko ix5];
                end
                clearvars ix5;
            end
            clearvars k1;
        end
        ind_ko1 = sum(ind_ko,2);
        
        in_field = field_n;
        in_field(in_field > 1) = 0;
        in_field(in_field < 0) = 0;
        
        [i_wt2,~,~] = find(ind_wt1 == 1 & in_field == 1);
        [i_ko2,~,~] = find(ind_ko1 == 1 & in_field == 1);
        
        fldRate_wt = fldRate(i_wt2);
        fldRate_ko = fldRate(i_ko2);
        
        pFldSz_wt = pFldSz(i_wt2);
        pFldSz_ko = pFldSz(i_ko2);
        
        out_f = field_n;
        out_f(out_f >= 0) = 0;
        out_f(out_f < 0) = 1;
        
        [i_wt3,~,~] = find(ind_wt1 == 1 & out_f == 1);
        [i_ko3,~,~] = find(ind_ko1 == 1 & out_f == 1);
        
        outfldRate_wt = fldRate(i_wt3);
        outfldRate_ko = fldRate(i_ko3);
        
        if i == 1
            wt_cnt = length(i_wt);
            ko_cnt = length(i_ko);
            width_wt = w_wt;
            x9 = ts_filename(i_wt);
            x8 = isi_wt;
            x7 = bProb_wt;
            x6 = ic_wt;
            x5 = coh_wt;
            x4 = pPix_wt;
            x3 =  r_wt;
            x2 = fldRate_wt;
            x1 = pFldSz_wt;
            x = outfldRate_wt;
            
            width_ko = w_ko;
            y9 = ts_filename(i_ko);
            y8 = isi_ko;
            y7 = bProb_ko;
            y6 = ic_ko;
            y5 = coh_ko;
            y4 = pPix_ko;
            y3 = r_ko;
            y2 = fldRate_ko;
            y1 = pFldSz_ko;
            y = outfldRate_ko;
        else
            wt_cnt = [wt_cnt; length(i_wt)];
            ko_cnt = [ko_cnt; length(i_ko)];
            width_wt = [width_wt; w_wt];
            x9 = [x9; ts_filename(i_wt)];
            x8 = [x8; isi_wt];
            x7 = [x7; bProb_wt];
            x6 = [x6; ic_wt];
            x5 = [x5; coh_wt];
            x4 = [x4; pPix_wt];
            x3 = [x3; r_wt];
            x2 = [x2; fldRate_wt];
            x1 = [x1; pFldSz_wt];
            x = [x; outfldRate_wt];
            
            width_ko = [width_ko; w_ko];
            y9 = [y9; ts_filename(i_ko)];
            y8 = [y8; isi_ko];
            y7 = [y7; bProb_ko];
            y6 = [y6; ic_ko];
            y5 = [y5; coh_ko];
            y4 = [y4; pPix_ko];
            y3 = [y3; r_ko];
            y2 = [y2; fldRate_ko];
            y1 = [y1; pFldSz_ko];
            y = [y; outfldRate_ko];
            
            x(isnan(x))=[];
            y(isnan(y))=[];
            
        end

       clearvars ix ix4 ix5 ix6 i_ko i_wt i_ko2 i_wt2 i_wt3 i_ko3...
           ind_ko1 ind_ko ind_wt ind_wt1 ts_ko ts_wt;
    end
    
    d(1) = (mean(width_wt)-mean(width_ko))/std([width_wt; width_ko]);% width
    d(2) = (mean(x3)-mean(y3))/std([x3; y3]);% rate
    d(3) = (mean(x4)-mean(y4))/std([x4; y4]);% percent active pixels
    d(4) = (mean(x5)-mean(y5))/std([x5; y5]);% map coh.
    d(5) = (mean(x6)-mean(y6))/std([x6; y6]);% map ic
    d(6) = (mean(x7)-mean(y7))/std([x7; y7]);% burst prob
    d(7) = (mean(x8)-mean(y8))/std([x8; y8]);% isi (ms)
    d(8) = (mean(x2)-mean(y2))/std([x2; y2]);% in-field rate
    d(9) = (mean(x3)-mean(y3))/std([x3; y3]);% outfldRate
    
    
        wt_avgs = [mean(width_wt) mean(x3)	mean(x4)	mean(x5)	...
            mean(x6)	mean(x7) mean(x8) mean(x2) mean(x) mean(x1)];
        
        ko_avgs = [mean(width_ko) mean(y3)	mean(y4)	mean(y5)	...
            mean(y6) mean(y7) mean(y8) mean(y2) mean(y) mean(y1)];
        
        wt_sem = [std(width_wt)/sqrt(length(width_wt)) std(x3)/sqrt(length(x3))...
            std(x4)/sqrt(length(x4))	std(x5)/sqrt(length(x5)) std(x6)/sqrt(length(x6))...
            std(x7)/sqrt(length(x7))	 std(x8)/sqrt(length(x8)) std(x2)/sqrt(length(x2))...
            std(x)/sqrt(length(x)) std(x1)/sqrt(length(x1))];
        
        ko_sem = [std(width_ko)/sqrt(length(width_ko)) std(y3)/sqrt(length(y3))...
            std(y4)/sqrt(length(y4))	std(y5)/sqrt(length(y5)) std(y6)/sqrt(length(y6))...
            std(y7)/sqrt(length(y7))	 std(y8)/sqrt(length(y8)) std(y2)/sqrt(length(y2))...
            std(y)/sqrt(length(y)) std(y1)/sqrt(length(y1))];
        
        [~,p(1),~,stats(1)] = ttest2(width_wt, width_ko);
        [~,p(2),~,stats(2)] = ttest2(x3, y3);
        [~,p(3),~,stats(3)] = ttest2(x4, y4);
        [~,p(4),~,stats(4)] = ttest2(x5, y5);
        [~,p(5),~,stats(5)] = ttest2(x6, y6);
        [~,p(6),~,stats(6)] = ttest2(x7, y7);
        [~,p(7),~,stats(7)] = ttest2(x8, y8);
        [~,p(8),~,stats(8)] = ttest2(x2, y2);
        [~,p(9),~,stats(9)] = ttest2(x, y);
        [~,p(10),~,stats(10)] = ttest2(x1, y1);
            
        for t = 1:10
            if t == 1
                ttests = [p(t) stats(t).tstat stats(t).df];
            else
                ttests = [ttests; p(t) stats(t).tstat stats(t).df];
            end
        end
        if n_cellType == 1
            ttest_results.PC = ttests;
            filenameList.PC.wt = x9;
            filenameList.PC.ko = y9;
        elseif n_cellType == 2
            ttest_results.nPC = ttests;
            filenameList.nPC.wt = x9;
            filenameList.nPC.ko = y9;
        elseif n_cellType == 3
            ttest_results.INT = ttests;
            filenameList.INT.wt = x9;
            filenameList.INT.ko = y9;
        end
        clearvars p stats;

        [stats(1)] = mwwtest(width_wt, width_ko);
        [stats(2)] = mwwtest(x3, y3);
        [stats(3)] = mwwtest(x4, y4);
        [stats(4)] = mwwtest(x5, y5);
        [stats(5)] = mwwtest(x6, y6);
        [stats(6)] = mwwtest(x7, y7);
        [stats(7)] = mwwtest(x8, y8);
        [stats(8)] = mwwtest(x2, y2);
        [stats(9)] = mwwtest(x, y);
        [stats(10)] = mwwtest(x1, y1);
        
        for t = 1:10
            if t == 1
                mwwtests = [ stats(t)];
            else
                mwwtests = [mwwtests; stats(t)];
            end
        end
        if n_cellType == 1
            kstest_results.PC = mwwtests;
        elseif n_cellType == 2
            kstest_results.nPC = mwwtests;
        elseif n_cellType == 3
            kstest_results.INT = mwwtests;
        end
        clearvars p stats;
% Do one-way KS test for normality of data set; check each geno separately
        %%% WT
        [h(1),p(1),stats(1)] = swtest(width_wt);
        [h(2),p(2),stats(2)] = swtest(x3);
        [h(3),p(3),stats(3)] = swtest(x4);
        [h(4),p(4),stats(4)] = swtest(x5);
        [h(5),p(5),stats(5)] = swtest(x6);
        [h(6),p(6),stats(6)] = swtest(x7);
        [h(7),p(7),stats(7)] = swtest(x8);
        [h(8),p(8),stats(8)] = swtest(x2);
        [h(9),p(9),stats(9)] = swtest(x);
        [h(10),p(10),stats(10)] = swtest(x1);
        %%% KO
        [h(11),p(11),stats(11)] = swtest(width_ko);
        [h(12),p(12),stats(12)] = swtest(y3);
        [h(13),p(13),stats(13)] = swtest(y4);
        [h(14),p(14),stats(14)] = swtest(y5);
        [h(15),p(15),stats(15)] = swtest(y6);
        [h(16),p(16),stats(16)] = swtest(y7);
        [h(17),p(17),stats(17)] = swtest(y8);
        [h(18),p(18),stats(18)] = swtest(y2);
        [h(19),p(19),stats(19)] = swtest(y);
        [h(20),p(20),stats(20)] = swtest(y1);
        for t = 1:20
            if t == 1
                normtests = [h(t) p(t) stats(t)];
            else
                normtests = [normtests; h(t) p(t) stats(t)];
            end
        end
        if n_cellType == 1
            normtest_results.PC = normtests;
            effectSize.PC = d;
        elseif n_cellType == 2
            normtest_results.nPC = normtests;
            effectSize.nPC = d;
        elseif n_cellType == 3
            normtest_results.INT = normtests;
            effectSize.INT = d;
        end
        clearvars h p stats;
       
        
        fitin1 = [sum(wt_cnt); 0; sum(ko_cnt); 0];
        if n_cellType == 1
            avgs = [wt_avgs; wt_sem; ko_avgs; ko_sem];
            avgs = [avgs fitin1];
        else
            a1 = [[wt_avgs; wt_sem; ko_avgs; ko_sem] fitin1];
            avgs = [avgs; a1];
        end
        clearvars wt_avgs ko_avgs wt_sem ko_sem ttests wt_cnt ko_cnt fitin1;
    
    clearvars i ix1 x x1 x2 x3 x4 x5 x6 x7 x8 x9 y9 width_wt width_ko y ...
        y1 y2 y3 y4 y5 y6 y7 y8 isi_wt bProb_wt ic_wt coh_wt pPix_wt  r_wt ...
        fldRate_wt pFldSz_wt outfldRate_wt isi_ko bProb_ko ic_ko coh_ko pPix_ko  r_ko ...
       fldRate_ko pFldSz_ko outfldRate_ko normtests;
end
clearvars burst_prob cell_class cluster_n field_n file_que fldRate genotype ...
    ix2 ix3 head in_field inforCont isi_ms mapCoh n_cellType num out_f pct_pixels ...
    pFldSz probe_n rate raw t w_ko w_wt width kstests ts_filename txt info_Cont ...
    header filename a1 A infoCont;
columnMeasures = {'width', 'grand_rate','pActPix', 'rMapCoh', 'MapIC', 'Burst prob.',...
 'ISI(ms)', 'in FldRate', 'out FldRate', 'pFldSz'};
savedFilename = 'CellPropertyAverages.xlsx';
A = {avgs};
xlswrite(savedFilename,A);

clearvars avgs A;


