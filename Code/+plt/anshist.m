function [sorted_imp_indices,sorted_est_indices] = anshist(answ,dgs, sort_cat, lab_sel,sorted_imp_indices,sorted_est_indices, z_flag)
% plots summary histograms and distributions of survey answers in structure
% answ.

% INPUTS:
% answ      structure with fields: importance, isEstablishes, ifPublic,
%           quetion_labels. Each fiels is a matrix nAnsw*nQ
%z_flag     logical, indicates if to zscore data. Default is 0, not zscored.

%TODO: not yet looking at the answers about whether statements should be
%public or private

% parse inputs
if nargin <8
    z_flag = 0;
end
if nargin <2
    sort_cat = [];
end

if ~isempty(sort_cat)
    % parse which column in dgs to query
    which_cat = strcmp(sort_cat, dgs.Properties.VariableNames);
    cat_lab = dgs.Properties.VariableNames{which_cat};
    % add categories
    if isempty(lab_sel)
        uniqueRoles = unique(dgs{:, which_cat}); % Unique positions
    else
        uniqueRoles = lab_sel; % Unique positions
    end
else
    uniqueRoles = 0;
end
for i = 1:length(uniqueRoles)
    if ~isempty(sort_cat)
        idx = strcmp(dgs{:, which_cat}, uniqueRoles{i}); % keep observations for each category
    else
        idx = true(size(answ.importance,1),1); % keep every observations
    end
    importance = answ.importance(idx,:);
    isEstablished = answ.isEstablished(idx,:);
    ifPublic = answ.ifPublic(idx,:) ;
    question_labels = answ.question_labels;

    [nA, nQ] =size(importance);

    % if requested zscore responses for each participant
    if z_flag
        zsc_importance = zscore(importance, [], 2);
    else
        zsc_importance = importance;
    end

    % Compute the average score and standard error for each question
    avg_importance_scores = mean(zsc_importance , 1);
    se_importance_scores = std(zsc_importance , [], 1)/sqrt(nA);

    howmuchEstablished = nanmean(isEstablished, 1);
    seEstablished = nanstd(isEstablished, [],1)/sqrt(nA);


    % compute answer distribution for each question
    for iQ = 1:nQ
        impDist(:, iQ) = histcounts(importance(:, iQ), [-0.5:1:5.5]);
        impDist(:, iQ) = impDist(:, iQ) /sum(impDist(:, iQ));

        dummy = isEstablished(:, iQ);
        dummy(isnan(dummy)) = -1;
        estDist(:, iQ) = histcounts(dummy, [-1.5:1:2.5]);
        estDist(:, iQ) = estDist(:, iQ)/sum(estDist(:, iQ));
    end
    % if isempty(sort_cat)
        [sorted_imp_scores, sorted_imp_indices] = sort(avg_importance_scores);
    % 
    %     % sort answers in ascending order for plotting purposes
        [sorted_hme_scores, sorted_est_indices] = sort(howmuchEstablished);


    sorted_impDist = impDist(:, sorted_imp_indices);
    imp_sorted_labels = question_labels(sorted_imp_indices);
    imp_sorted_std = se_importance_scores(sorted_imp_indices);
    imp_sorted_hme = howmuchEstablished (sorted_imp_indices);

    se_sorted_hme = seEstablished(sorted_imp_indices);
    sorted_estDist = estDist(:, sorted_est_indices);
    est_sorted_labels = question_labels(sorted_est_indices);
    %% compute correlation between imp and est

    lm = fitlm(sorted_imp_scores, imp_sorted_hme, "Intercept",true, "RobustOpts","on");


    %% plot

    figure('Position', [110 110 1280 660]);
    subplot(2,1, 1)
    imagesc(1:length(imp_sorted_labels), 0:5, sorted_impDist); hold on; axis xy
    colormap(1-gray);
    errorbar(sorted_imp_scores, imp_sorted_std, 'or', 'MarkerFaceColor', [ 1 0 0]);
    set(gca, 'XTick', 1:length(imp_sorted_labels), 'XTickLabel', imp_sorted_labels, 'XTickLabelRotation', 45);
    ylabel('Importance score');
    title('Importance score, ascending')

    subplot(2,1, 2)
    imagesc(1:length(imp_sorted_labels), -1:2, sorted_estDist); hold on; axis xy
    colormap(1-gray);
    errorbar(sorted_hme_scores, se_sorted_hme, 'or', 'MarkerFaceColor', [ 1 0 0]);
    set(gca, 'XTick', 1:length(est_sorted_labels), 'XTickLabel', est_sorted_labels, 'XTickLabelRotation', 45);
    set(gca, 'YTick', -1:2, 'YTickLabel', {'Not known' ,'No', 'Partly', 'Yes'}, 'YTickLabelRotation', 45);
    ylabel('How established score');
    title('How much established score, ascending')

    if ~isempty(sort_cat)
        sgtitle(uniqueRoles{i})
    end
    % Plot the histogram
    figure('Position', [110 110 1280 660]);
    subplot(2, 1, 1);
    % bar(sorted_scores); hold on
    errorbar(sorted_imp_scores, imp_sorted_std, 'o', 'MarkerFaceColor', [ 0 0 1]);
    xlim([0 length(imp_sorted_labels)+1])
    set(gca, 'XTick', 1:length(imp_sorted_labels), 'XTickLabel', imp_sorted_labels, 'XTickLabelRotation', 45);
    xlabel('Questions');
    ylabel('Average Importance Score');
    title('Average Importance Score per Question (Sorted by Increasing Score)');

    % Improve layout
    grid on;
    % if z_flag
        ylim([min(sorted_imp_scores) - 0.5, max(sorted_imp_scores) + 0.5]);
    % else
    %     %     ylim([0 5]);
    %     ylim([min(sorted_imp_scores) - 0.5, max(sorted_imp_scores) + 0.5]);
    % 
    % end

    subplot(2, 1, 2);
    bar(imp_sorted_hme ); hold on
    xlim([0 length(imp_sorted_labels)+1])
    set(gca, 'XTick', 1:length(imp_sorted_labels), 'XTickLabel', imp_sorted_labels, 'XTickLabelRotation', 45);
    set(gca, 'YTick', 0:2, 'YTickLabel', {'No', 'Partly', 'Yes'}, 'YTickLabelRotation', 45);
    ylim([0 2])
    xlabel('Questions');
    ylabel('How established');
    title('Average implementation level');

    if ~isempty(sort_cat)
        sgtitle(uniqueRoles{i})
    end

    figure;

    plot(sorted_imp_scores, imp_sorted_hme, 'ok', 'MarkerFaceColor','k');
    hold on;
    plot(lm)
    axis square
    xlim([3.5 5])
    ylim([0 2])
    set(gca, 'YTick', 0:2, 'YTickLabel', {'No', 'Partly', 'Yes'}, 'YTickLabelRotation', 45);
    ylabel('How established');
    xlabel('Importance');

    if ~isempty(sort_cat)
        title(uniqueRoles{i})
    end
end
end