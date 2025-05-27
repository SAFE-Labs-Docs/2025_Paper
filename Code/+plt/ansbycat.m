function ansbycat(ans, dgs, sort_cat, lab_sel, options)

% plots summary histograms of survey answers in structure
% answ, split by demographic categories contained in dgs

% INPUTS: 
% answ      structure with fields: importance, isEstablishes, ifPublic,
%           quetion_labels. Each fiels is a matrix nAnsw*nQ
% dgs       table with demographic data
% sort_cat  string, corresponding to the demographic category to be used
%           for sorting. e.g. 'CurrentRole'
% lab_sel   Cell array of strings of demographic labels. e.g. {'PI', 'PhD',
            % 'Postdoc'}. Default [], considers all the labels in the
            % selected category
%z_flag     logical, indicates if to zscore data. Default is 0, not zscored.

%TODO: not yet looking at the answers about whether statements should be
%public or private

% parse inputs
if nargin < 4
    lab_sel = [];
end
if nargin < 5
    options.Sort = 0;
    options.PI_only = 0;
end
importance = ans.importance;
isEstablished = ans.isEstablished;
ifPublic = ans.ifPublic ;
question_labels = ans.question_labels;
implement = ans.implement;
[nA, nQ] =size(importance);

% Sort the questions by increasing average importance score
avg_importance_scores = mean(importance , 1);
[sorted_scores, sorted_indices] = sort(avg_importance_scores);
importance = importance(:, sorted_indices);
isEstablished = isEstablished(:, sorted_indices);
ifPublic = ifPublic(:, sorted_indices);
question_labels = question_labels(sorted_indices);

% parse which column in dgs to query
which_cat = strcmp(sort_cat, dgs.Properties.VariableNames);
cat_lab = dgs.Properties.VariableNames{which_cat};

% Calculate average scores by demographic label
if isempty(lab_sel)
    uniqueRoles = unique(dgs{:, which_cat}); % Unique positions
else
    uniqueRoles = lab_sel; % Unique positions
end

impbycat = zeros(length(uniqueRoles), nQ);
estbycat = zeros(length(uniqueRoles), nQ);
M = mean(importance,2); % average importance score

for i = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{i});
    impbycat (i,:) = nanmean(importance(idx, :), 1); % Average scores across questions for each position
    seimpbycat (i,:) = nanstd(importance(idx, :), [], 1)/sqrt(sum(idx));

    estbycat (i,:) = nanmean(isEstablished(idx, :), 1); % Average scores across questions for each position
    seestbycat (i,:) = nanstd(isEstablished(idx, :), [], 1)/sqrt(sum(idx));

    pubbycat (i,:) = nanmean(ifPublic(idx, :), 1); % Average scores across questions for each position
    sepubbycat (i,:) = nanstd(ifPublic(idx, :), [], 1)/sqrt(sum(idx));

    dummy = importance(idx, :);
    impdistbycat(i,:) = histcounts(dummy(:), [0.5:5.5]);
    impdistbycat(i,:) = impdistbycat(i,:)/sum(impdistbycat(i,:));
    dummy = isEstablished(idx, :);
    dummy(isnan(dummy)) = -1;
    estdistbycat(i,:) = histcounts(dummy(:), [-1.5:2.5]);
    estdistbycat(i,:) = estdistbycat(i,:)/sum(estdistbycat(i,:));

    dummy = ifPublic(idx, :);
    for j=1:size(dummy,2) 
        pubdistbycat(i,:,j) = histcounts(dummy(:,j), [-0.5:2.5]);
        pubdistbycat(i,:,j) = pubdistbycat(i,:,j)/sum(pubdistbycat(i,:,j));
    end

    dummy = implement(idx, :);
    for j=1:size(dummy,2) 
        impledistbycat(i,:,j) = histcounts(dummy(:,j), [-0.5:2.5]);
        impledistbycat(i,:,j) = impledistbycat(i,:,j)/sum(impledistbycat(i,:,j));
    end

    dummy = M(idx, :);
    if options.PI_only
        role_cat = strcmp('CurrentRole',dgs.Properties.VariableNames);
         idxPI = strcmp(dgs{:, role_cat}, 'PI');
         dummy = M(idx & idxPI, :);
    end
    avg_impbycat(i,:) = histcounts(dummy, [0.5:5.5]);
    avg_impbycat(i,:) = avg_impbycat(i,:)/sum(avg_impbycat(i,:));

end

if options.Sort == 1
    % find difference between students and PI to sort the plot
    students = ismember(uniqueRoles,{'PhD Student','Postdoc'});
    PI = strcmp(uniqueRoles,{'PI'});
    D = mean(impbycat(students,:),1) - impbycat(PI,:);
    [sorted_scores_roles, sorted_indices_roles] = sort(D);

    question_labels = question_labels(sorted_indices_roles);
    impbycat = impbycat(:,sorted_indices_roles);
    seimpbycat = seimpbycat(:,sorted_indices_roles);
    estbycat = estbycat(:,sorted_indices_roles);
    seestbycat = seestbycat(:,sorted_indices_roles);
    pubbycat = pubbycat(:,sorted_indices_roles);
    sepubbycat = sepubbycat(:,sorted_indices_roles);
    pubdistbycat = pubdistbycat(:,:,sorted_indices_roles);
end
GoodPub = ~all(isnan(pubbycat),1);
%% stats

group1 = repmat(dgs{:, which_cat}, 1, nQ);
group2 = repmat(question_labels', nA, 1);

[imp_p, imp_anova_table] = anovan(importance(:), {group1(:), group2(:)}, 'model','interaction','varnames',{cat_lab,'Q'});

[est_p, est_anova_table] = anovan(isEstablished(:), {group1(:), group2(:)}, 'model','interaction','varnames',{cat_lab,'Q'});

%%
% put labels asked for public documentation in bold
question_labels_b = question_labels;
question_labels_b(GoodPub) = cellfun(@(x) ['\bf',x],question_labels_b(GoodPub),'UniformOutput',false);
% Plot the average scores
figure('Position', [110 110 1280 660]);

subplot(2,5,5)
plot(1:5, impdistbycat', 'Linewidth', 1);
xlabel('Importance score')
ylabel('P of response')
ylim([0 .6])
xlim([0 6])
title(sprintf('p %s = %03f \n p Q = %03f', cat_lab, imp_p(1), imp_p(2)));

subplot(2,5,1:4)
h = errorbar(1:nQ,impbycat, seimpbycat, 'o', 'MarkerFaceColor','auto');
c = get(h,'Color');
set(gca, 'XTick', 1:length(question_labels), 'XTickLabel', question_labels_b, 'XTickLabelRotation', 45);
xlabel('Questions');
ylabel('Average Importance Score');
title(sprintf('Importance Score by %s', cat_lab));
legend(uniqueRoles);

% Improve layout
% if z_flag
%     ylim([min(sorted_scores) - 0.5, max(sorted_scores) + 0.5]);
% else
% %     ylim([0 5]);
ylim([min(sorted_scores) - 0.5, max(sorted_scores) + 0.5]);
% end

subplot(2,5,10)
plot(-1:2, estdistbycat','Linewidth', 1);
set(gca, 'XTick', [-1 0 1 2], 'XTickLabel', {'Not known', 'No', 'Partly', 'Yes'})
xlabel('How established')
ylabel('P of response')
ylim([0 .6])
xlim([-1 2])
title(sprintf('p %s = %03f \n p Q = %03f', cat_lab, est_p(1), est_p(2)));

subplot(2,5,6:9)
errorbar(1:nQ,estbycat, seestbycat, 'o', 'MarkerFaceColor','auto');
set(gca, 'XTick', 1:length(question_labels), 'XTickLabel', question_labels, 'XTickLabelRotation', 45);
xlabel('Questions');
ylabel('How Established Score');
title(sprintf('How Established Score by %s', cat_lab));
legend(uniqueRoles);

% plot opinion on public documentation for the questions that required it
figure('Position', [254,635,725,473]);
errorbar(1:sum(GoodPub),pubbycat(:,GoodPub), sepubbycat(:,GoodPub), 'o', 'MarkerFaceColor','auto');
set(gca, 'XTick', 1:length(question_labels(GoodPub)), 'XTickLabel', question_labels(GoodPub), 'XTickLabelRotation', 45);
xlabel('Questions');
ylabel('Average Publicly Document score');
legend(uniqueRoles);

figure('Position', [770,81,308,1152]);
pubdistbycat_sub = pubdistbycat(:,[1,3],GoodPub);
for j=1:size(pubdistbycat_sub,3)
    subplot(size(pubdistbycat_sub,3),1,j)
    b = bar( 1:2,pubdistbycat_sub(:,:,j)');
    for i=1:length(b)
        b(i).FaceColor = c{i};
    end
    Lab = question_labels(GoodPub);
    title(Lab{j})
   set(gca, 'XTick', 1:2, 'XTickLabel', {'No','Yes'})
   ylim([0 1])
end

sgtitle('Histogram Publicly Document','FontSize',16);
legend(uniqueRoles,'Position',[0.568242108161609,0.032097502361304,0.353896098283978,0.040798610024568]);

% plot wish to implement the Handbook
figure('Position', [1183,557,464,405]);
b = bar(impledistbycat');
for i=1:length(b)
    b(i).FaceColor = c{i};
end
ylim([0 1])
set(gca, 'XTick', 1:3, 'XTickLabel', {'No','Maybe','Yes'})
sgtitle('Implement in your lab?','FontSize',16);

% plot distribution of average score per category, if we are plotting
% CurrenRole, also checks correlation with years in role for PIs

figure('Position', [543,732,545,304]);
b = bar( 1:5,avg_impbycat');
for i=1:size(avg_impbycat,1)
    b(i).FaceColor = c{i};
end
title('Average importance score','FontSize',16)
set(gca, 'XTick', 1:5)
ylim([0 1])
legend(uniqueRoles,'Position',[0.712162636254389,0.682431020252719,0.220183482465394,0.174342100557528]);
% %%
% 
% figure; 
% 
% plotmatrix(scorebyrole')
% 


end