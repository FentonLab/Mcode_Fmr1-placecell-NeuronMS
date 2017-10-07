clear;
cd 'Directory location of ONLY the cell pair files of genotype #1';

x = dir('*zs1');
for i=1:length(x)
    a = importdata(x(i).name);
    b = mean(a,'omitnan');
    c = min(a);
    d = max(a);
    e = std(a);
    if i == 1
        x_wt = a;
        x_wt_avg = b;
        x_wt_min = c;
        x_wt_max = d;
        x_wt_std = e;
    else
        x_wt = [x_wt; a];
        x_wt_avg = [x_wt_avg; b];
        x_wt_min = [x_wt_min; c];
        x_wt_max = [x_wt_max; d];
        x_wt_std = [x_wt_std; e];
    end
    clearvars a b c d e;
end

y = dir('*zs2');
for i=1:length(y);
    a = importdata(y(i).name);
    b = mean(a,'omitnan');
    c = min(a);
    d = max(a);
    e = std(a);
    if i == 1
        y_wt = a;
        y_wt_avg = b;
        y_wt_min = c;
        y_wt_max = d;
        y_wt_std = e;
    else
        y_wt = [y_wt; a];
        y_wt_avg = [y_wt_avg; b];
        y_wt_min = [y_wt_min; c];
        y_wt_max = [y_wt_max; d];
        y_wt_std = [y_wt_std; e];
    end
    clearvars a b c d e;
end
cd 'Directory location of ONLY the cell pair files of genotype #2';

x = dir('*zs1');
for i=1:length(x)
    a = importdata(x(i).name);
    b = mean(a,'omitnan');
    c = min(a);
    d = max(a);
    e = std(a);
    if i == 1
        x_ko = a;
        x_ko_avg = b;
        x_ko_min = c;
        x_ko_max = d;
        x_ko_std = e;
    else
        x_ko = [x_ko; a];
        x_ko_avg = [x_ko_avg; b];
        x_ko_min = [x_ko_min; c];
        x_ko_max = [x_ko_max; d];
        x_ko_std = [x_ko_std; e];
    end
    clearvars a b c d e;
end

y = dir('*zs2');
for i=1:length(y)
    a = importdata(y(i).name);
    b = mean(a,'omitnan');
    c = min(a);
    d = max(a);
    e = std(a);
    if i == 1
        y_ko = a;
                y_ko_avg = b;
        y_ko_min = c;
        y_ko_max = d;
        y_ko_std = e;
    else
        y_ko = [y_ko; a];
        y_ko_avg = [y_ko_avg; b];
        y_ko_min = [y_ko_min; c];
        y_ko_max = [y_ko_max; d];
        y_ko_std = [y_ko_std; e];
    end
    clearvars a b c d e;
end