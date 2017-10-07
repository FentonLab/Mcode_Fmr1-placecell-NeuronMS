% This script imports the raw tau file which has three columns: [tau z-dist. p-value].
% Once you run this script on all sessions you are interested in and save
% the respective output, you can group these files using
% importData_tau_groupNaverage. Created by Zoe Talbot in 2016.

clear
dirIn = 'yourDataDirectory';
cd(dirIn);
folder = dir('*bin*dur300*'); % switch between '*bin*dur300*' and '*bin*dur600*'
durations = 6; % switch between 3 (10 min) and 6 (5min), depedning on duration set during tau calc.
i_data_type = 1; %[tau=1 ztrans=2 pval=3]
session = '*M16*bigbox*'; % tag used to grab certain session files

for i_folder = 1:6 % because there are 6 time bins in this study
    cd(dirIn);
    cd(folder(i_folder).name);
    for i_geno = 1:2
        if i_geno == 1
            cd('WT');
            Nfile = dir(session); 
        elseif i_geno == 2
            cd('../KO');
            Nfile = dir(session);
        end     
        for i_trial = 1:length(Nfile)
            x(i_trial) = importdata(Nfile(i_trial).name);
            firstPCo_len = length(x(i_trial).data)/durations;
            
            % if there is only one element, no need to move durs to columns
            if length(x(i_trial).data(:,i_data_type)) == 1
                split_durations = x(i_trial).data(:,i_data_type);
            else
                split_durations = reshape(x(i_trial).data(:,i_data_type), firstPCo_len, durations);
            end
            
            % remove zero columns, or those with mostly zeros in tau
            for i_col = 1:durations
                if i_data_type == 1 || 2 % tau or z-dist
                    idx = split_durations(:, i_col) == 0;
                elseif i_data_type == 3 % pval
                    idx = split_durations(:, i_col) == 1;
                end
                
                % if at least 75% of a column is zeros, delete column
                if sum(idx) >= (0.81 * firstPCo_len)
                    if exist('list_o_cols_to_delete','var') == 0
                        list_o_cols_to_delete = i_col;
                    else
                        list_o_cols_to_delete = [list_o_cols_to_delete i_col];
                    end
                else
                end
                clearvars idx;
            end
            clearvars i_col;
            
            if exist('list_o_cols_to_delete','var') == 1
                split_durations(:, list_o_cols_to_delete) = [];
                clearvars list_o_cols_to_delete count;
            else
            end
            if strcmp(session, '*pie*track*') && durations == 6
                split_durations = mean(split_durations(:, 1:2),2);
            elseif strcmp(session, '*pie*track*') && durations == 3
                split_durations = split_durations(:, 1);
            elseif strcmp(session, '*bigbox*') && durations == 6
                if size(split_durations,2) == 6
                    split_durations =mean(split_durations(:,1:6), 2);
                elseif size(split_durations,2) == 4                                     
                    split_durations =[mean(split_durations(:,1:3), 2) mean(split_durations(:,4:6), 2)];
                elseif size(split_durations,2) == 4
                    split_durations =[mean(split_durations(:,1:2), 2) mean(split_durations(:,3:4), 2)];
                elseif size(split_durations,2) == 3
                    split_durations =split_durations(:,1:2);
                end
            elseif strcmp(session, '*smallbox*') && durations == 6
                if size(split_durations,2) == 6
                    split_durations =mean(split_durations(:,1:6), 2);
                elseif size(split_durations,2) == 4
                    split_durations =[mean(split_durations(:,1:3), 2) mean(split_durations(:,4:6), 2)];
                elseif size(split_durations,2) == 4
                    split_durations =[mean(split_durations(:,1:2), 2) mean(split_durations(:,3:4), 2)];
                elseif size(split_durations,2) == 3
                    split_durations =split_durations(:,1:2);
                end
            elseif (strcmp(session, '*sleep_pcT*') || strcmp(session,'*awake_pcT*')) && durations == 6
                if size(split_durations,2) == 6
                    split_durations = [mean(split_durations(:,1:3), 2) mean(split_durations(:,4:6), 2)];
                elseif size(split_durations,2) == 4
                    split_durations = [mean(split_durations(:,1:2), 2) mean(split_durations(:,3:4), 2)];
                elseif size(split_durations,2) == 3
                    split_durations =split_durations(:,1:2);
                elseif size(split_durations,2) == 2
                    split_durations =split_durations(:,1:2);
                end
            elseif strcmp(session, '*st1*') && durations == 6
                if size(split_durations,2) == 6
                    split_durations =mean(split_durations(:,1:6), 2);
                elseif size(split_durations,2) == 4
                    split_durations =[mean(split_durations(:,1:3), 2) mean(split_durations(:,4:6), 2)];
                elseif size(split_durations,2) == 4
                    split_durations =[mean(split_durations(:,1:2), 2) mean(split_durations(:,3:4), 2)];
                elseif size(split_durations,2) == 3
                    split_durations =split_durations(:,1:2);
                end
            elseif (strcmp(session,'*awake_pcT*') || strcmp(session, '*sleep_pcT*') || ...
                    strcmp(session, '*bigbox*') || strcmp(session, '*smallbox*') || ...
                    strcmp(session, '*st1*') || strcmp(session, filenameString)) && durations == 3
                split_durations =mean(split_durations, 2);
            end
            if i_trial == 1
                x1 = split_durations;
            else
                x1 = [x1; split_durations];
            end
        end
        clearvars split_durations;
        
        if i_folder == 1
            if i_geno == 1; wt_tau_b1000 = x1; elseif i_geno == 2; ko_tau_b1000 = x1; end
        elseif i_folder == 2
            if i_geno == 1; wt_tau_b125 = x1; elseif i_geno == 2; ko_tau_b125 = x1; end
        elseif i_folder == 3
            if i_geno == 1; wt_tau_b250 = x1; elseif i_geno == 2; ko_tau_b250 = x1; end
        elseif i_folder == 4
            if i_geno == 1; wt_tau_b25 = x1; elseif i_geno == 2; ko_tau_b25 = x1; end
        elseif i_folder == 5
            if i_geno == 1; wt_tau_b40 = x1; elseif i_geno == 2; ko_tau_b40 = x1; end
        elseif i_folder == 6
            if i_geno == 1; wt_tau_b5000 = x1; elseif i_geno == 2; ko_tau_b5000 = x1; end
        end
        clearvars x x1 possible_extra_error new_dur_divisor firstPCo_len error_durs;
    end
end
clearvars Nfile session i_trial i_geno i_folder i_data_type folder dirIn durations;

