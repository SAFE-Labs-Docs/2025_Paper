function PCAproj(answ, dgs, sort_cat)

% INPUTS: 
% answ      structure with fields: importance, isEstablishes, ifPublic,
%           quetion_labels. Each fiels is a matrix nAnsw*nQ
% dgs       table with demographic data
% sort_cat  string, corresponding to the demographic category to be used
%           for sorting. e.g. 'CurrentRole'

which_cat = strcmp(sort_cat, dgs.Properties.VariableNames);
uniqueRoles = unique(dgs{:, which_cat}); % Unique positions

[Coeff, scores] = pca(answ.importance');
imp_z = zscore(answ.importance');
[Coeff_z, scores_z] = pca(imp_z);

figure('Position', [110 110 1280 660]);
subplot(1,2,1)
hold on;
for i = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{i});
    plot(Coeff(idx , 1), Coeff(idx ,2), 'o', 'MarkerFaceColor', 'auto');
end
title(sprintf('Importance score'))
axis square
legend(uniqueRoles{:})
legend("Position", [0.165,0.13,0.16607,0.14524])
xlabel('PC 1')
ylabel('PC 2')

subplot(1,2,2)
hold on;
for i = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{i});
    plot(Coeff_z(idx , 1), Coeff_z(idx ,2), 'o', 'MarkerFaceColor', 'auto');
end
title(sprintf('Importance score - z-scored'))
axis square
legend(uniqueRoles{:})
legend("Position", [0.165,0.13,0.16607,0.14524])
xlabel('PC 1')
ylabel('PC 2')

figure('Position', [527,76,1493,1119]);

hold on
scatter(scores(:,1),scores(:,2),'.k')
text(scores(:,1),scores(:,2),answ.question_labels)