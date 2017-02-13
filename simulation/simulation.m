clear;
close all;

save_results = true;
plot_results = false;

n_features = 10;
n_samples = 100;    % number of samples per subject

n_subjects = 4;    % needs to be an even number
n_subjects_rep = 10;
n_test = n_subjects/2; % should be an even number

A = 1;  % disease effect size
feature_std = 1;
n_bootstrap = 10;
ntrees = 50;

B0 = .1:.1:2;   % cross-subject noise
C0 = .1:.1:2;   % within-subject noise

diff = zeros(length(B0), length(C0));
acc_rw_ = zeros(length(B0), length(C0));
acc_sw_ = zeros(length(B0), length(C0));
counter = 1;    %to display the iteration 

fprintf('no. features: %d\n', n_features);
fprintf('no. subjects: %d\n', n_subjects);

for k1 = 1:length(B0),
    for k2 = 1:length(C0),
        
        disp([num2str(counter) '/' num2str(length(B0)*length(C0))])

        B = B0(k1)*ones(n_features, 1);    % cross-subject noise
        C = C0(k2)*ones(n_features, 1);   % within-subject noise
        
        feature_noise = feature_std*randn(n_features,1);
        features_disease(1,:) = -A/2 + feature_noise;
        features_disease(2,:) = A/2 + feature_noise;
        %features_disease(1,:) = -A/2 * feature_noise;
        %features_disease(2,:) = A/2 * feature_noise;
        
        features_sample = zeros(2, n_subjects/2, n_samples, n_features);
        for c = 1:2,
            for j = 1:n_subjects/2,
                % adding cross-subject noise
                features_subject = features_disease(c,:)' + B.*randn(n_features,1);
                for k = 1:n_samples,
                    % adding within-subject noise
                    features_sample(c,j,k,:) = features_subject + C.*randn(n_features,1);
                end
            end
        end

        % replication set
        features_sample_rep = zeros(2, n_subjects_rep/2, n_samples, n_features);
        for c = 1:2,
            for j = 1:n_subjects_rep/2,
                % adding cross-subject noise
                features_subject_rep = features_disease(c,:)' + B.*randn(n_features,1);
                for k = 1:n_samples,
                    % adding within-subject noise
                    features_sample_rep(c,j,k,:) = features_subject_rep + C.*randn(n_features,1);
                end
            end
        end
        
        %% Subject-wise
        
        n_test_pergroup = n_test/2;
        n_subjects_pergroup = n_subjects/2;
        n_train_pergroup = n_subjects_pergroup - n_test_pergroup;
        
        acc_sw = zeros(n_bootstrap,1);
        acc_sw_rep = zeros(n_bootstrap,1);
        
        parfor i = 1:n_bootstrap,
            
            subjects_test1 = randsample(n_subjects_pergroup, n_test_pergroup);
            subjects_test2 = randsample(n_subjects_pergroup, n_test_pergroup);
            
            subjects_train1 = find(~ismember(1:n_subjects_pergroup, subjects_test1));
            subjects_train2 = find(~ismember(1:n_subjects_pergroup, subjects_test2));
            
            features_test = [];
            features_train = [];
            
            features_test(1,:,:,:) = features_sample(1,subjects_test1,:,:);
            features_test(2,:,:,:) = features_sample(2,subjects_test2,:,:);
            features_test = reshape(features_test, [2*n_test_pergroup*n_samples n_features]);
            class_test = repmat([0; 1], [n_test_pergroup*n_samples 1]);
            
            features_train(1,:,:,:) = features_sample(1,subjects_train1,:,:);
            features_train(2,:,:,:) = features_sample(2,subjects_train2,:,:);
            features_train = reshape(features_train, [2*n_train_pergroup*n_samples n_features]);
            class_train = repmat([0; 1], [n_train_pergroup*n_samples 1]);
            
            %classifier
            RF = TreeBagger(ntrees, features_train, class_train);
            
            %validation
            [class_pred, ~] = predict(RF, features_test);
            class_pred = str2double(class_pred);
            acc_sw(i) = mean(class_pred==class_test);
            
            %replication
            features_test = reshape(features_sample_rep, [n_subjects_rep*n_samples n_features]);
            class_test = repmat([0; 1], [(n_subjects_rep/2)*n_samples 1]);
            [class_pred, ~] = predict(RF, features_test);
            class_pred = str2double(class_pred);
            acc_sw_rep(i) = mean(class_pred==class_test);
            
            
        end
        
        %% Record-wise
        
        features_subjectsmixed = reshape(features_sample, [2 n_subjects_pergroup*n_samples n_features]);
        
        clear features_test features_train class_test class_train;
        
        acc_rw = zeros(n_bootstrap,1);
        acc_rw_rep = zeros(n_bootstrap,1);
        
        parfor i = 1:n_bootstrap,
            
            samples_test1 = randsample(n_subjects_pergroup*n_samples, n_test_pergroup*n_samples);
            samples_test2 = randsample(n_subjects_pergroup*n_samples, n_test_pergroup*n_samples);
            
            samples_train1 = find(~ismember(1:n_subjects_pergroup*n_samples, samples_test1));
            samples_train2 = find(~ismember(1:n_subjects_pergroup*n_samples, samples_test2));
            
            features_test = [];
            features_train = [];
            
            features_test(1,:,:) = features_subjectsmixed(1,samples_test1,:);
            features_test(2,:,:) = features_subjectsmixed(2,samples_test2,:);
            features_test = reshape(features_test, [2*n_test_pergroup*n_samples n_features]);
            class_test = repmat([0; 1], [n_test_pergroup*n_samples 1]);
            
            features_train(1,:,:) = features_subjectsmixed(1,samples_train1,:);
            features_train(2,:,:) = features_subjectsmixed(2,samples_train2,:);
            features_train = reshape(features_train, [2*n_train_pergroup*n_samples n_features]);
            class_train = repmat([0; 1], [n_train_pergroup*n_samples 1]);
            
            %training
            RF = TreeBagger(ntrees, features_train, class_train);
            
            % validation
            [class_pred, ~] = predict(RF, features_test);
            class_pred = str2double(class_pred);
            acc_rw(i) = mean(class_pred==class_test);
            
            % replication
            features_test = reshape(features_sample_rep, [n_subjects_rep*n_samples n_features]);
            class_test = repmat([0; 1], [(n_subjects_rep/2)*n_samples 1]);
            [class_pred, ~] = predict(RF, features_test);
            class_pred = str2double(class_pred);
            acc_rw_rep(i) = mean(class_pred==class_test);
            
        end
        
        acc_rw_(k1,k2) = mean(acc_rw);
        acc_sw_(k1,k2) = mean(acc_sw);
        acc_rw_rep_(k1,k2) = mean(acc_rw_rep);
        acc_sw_rep_(k1,k2) = mean(acc_sw_rep);
        
        diff(k1,k2) = mean(acc_rw - acc_sw);
        
        if isnan(diff(k1,k2)),
            disp('Warning: NaN value in accuracies');
        end
        
        counter = counter + 1;
    end
end

if plot_results,
    imagesc(diff');
    colormap hot;
    set(gca, 'xtick', 1:length(B0), 'xticklabel', num2str(B0'));
    set(gca, 'ytick', 1:length(C0), 'yticklabel', num2str(C0'));
    xlabel('B_0');
    ylabel('C_0');
    colorbar;
    title('CE_{SWCV} - CE_{RWCV}');
end

if save_results,
    save(sprintf('error_%dsubject',n_subjects), 'diff', 'acc_sw_', 'acc_rw_', 'acc_sw_rep_', 'acc_rw_rep_');
end
