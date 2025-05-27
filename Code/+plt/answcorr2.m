function [impCorr, estCorr, uniqueRoles] = answcorr2(ans, dgs, sort_cat, lab_sel)

% plots pairwise correlation matrix across participants

% INPUTS: 
% answ      structure with fields: importance, isEstablishes, ifPublic,
%           quetion_labels. Each fiels is a matrix nAnsw*nQ
% dgs       table with demographic data
% sort_cat  string, corresponding to the demographic category to be used
%           for sorting. e.g. 'CurrentRole'
% lab_sel   Cell array of strings of demographic labels. e.g. {'PI', 'PhD',
            % 'Postdoc'}. Default [], considers all the labels in the
            % selected category

% parse inputs
if nargin < 4
    lab_sel = [];
end

importance = ans.importance;
isEstablished = ans.isEstablished;
ifPublic = ans.ifPublic ;
question_labels = ans.question_labels;

which_cat = strcmp(sort_cat, dgs.Properties.VariableNames);
cat_lab = dgs.Properties.VariableNames{which_cat};

if isempty(lab_sel)
    uniqueRoles = unique(dgs{:, which_cat}); % Unique positions
else
    uniqueRoles = lab_sel; % Unique positions

end

% sort answers by demographic category
[sorted_cat, sorted_indices] = sort(dgs{:, which_cat});
importance = importance( sorted_indices, :);
isEstablished = isEstablished(sorted_indices, :);
isEstablished(isnan(isEstablished)) = -1; % 'Not Aware' answers are turned to -1
ifPublic = ifPublic( sorted_indices, :);

% create pairwise correlation matrices sorted by demographic label. Within
% each label block, answers are sorted to have the highest correlations on
% the left (descending corr)

impbycorridx = [];
estbycorridx = [];

for iL = 1: numel(uniqueRoles)

    idx = strcmp(sorted_cat, uniqueRoles{iL});
    boundary(iL) = find(idx, 1,'first') -1;

    data = importance(idx, :);
    datacorr = corr(data', 'Type', 'Pearson', 'rows', 'complete');
    % datacorr(isnan(datacorr(:)))=1; % if answers were all same number, correlation is NaN. Set to 1 now to create NaN band on the left.
    impCorr{iL} = datacorr;

    data = isEstablished(idx, :);
    datacorr = corr(data', 'Type', 'Pearson', 'rows', 'complete');
    % datacorr(isnan(datacorr(:)))=1;
    estCorr{iL} = datacorr;

end

%% plot

% figure('Position', [110 110 1280 660]);
% subplot (1, 2, 1)
% imagesc(impCorr);
% axis square
% caxis([-0.5, 0.5])
% colormap(BlueWhiteRed)
% hold on;
% for iB = 1:length(boundary)-1
%     % Draw horizontal and vertical lines for cluster boundaries
%     line([boundary(iB+1), boundary(iB+1)], [1, size(impCorr, 1)], 'Color', 'k', 'LineWidth', 1.5);
%     line([1, size(impCorr, 1)], [boundary(iB+1), boundary(iB+1)], 'Color', 'k', 'LineWidth', 1.5);
% end
% 
% midpoints = [boundary, numel(impbycorridx)];
% midpoints = midpoints(1:end-1) + diff(midpoints) / 2;
% 
% labelOffset = 5; % Distance above the matrix for the labels
% % Add cluster labels
% for i = 1:length(midpoints)
%     text(midpoints(i), -labelOffset, sprintf('%s', uniqueRoles{i}), 'HorizontalAlignment', 'left', ...
%         'VerticalAlignment', 'middle', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'k', 'Rotation',45);
% end
% 
% hold off;
% xlabel('Correlation of importance score')
% 
% 
% subplot (1, 2, 2)
% imagesc(estCorr);
% axis square
% caxis([-0.5, 0.5])
% colormap(BlueWhiteRed)
% hold on;
% for iB = 1:length(boundary)-1
%     % Draw horizontal and vertical lines for cluster boundaries
%     line([boundary(iB+1), boundary(iB+1)], [1, size(estCorr, 1)], 'Color', 'k', 'LineWidth', 1.5);
%     line([1, size(estCorr, 1)], [boundary(iB+1), boundary(iB+1)], 'Color', 'k', 'LineWidth', 1.5);
% end
% 
% midpoints = [boundary, numel(estbycorridx)];
% midpoints = midpoints(1:end-1) + diff(midpoints) / 2;
% 
% % Add cluster labels
% for i = 1:length(midpoints)
%     text(midpoints(i), -labelOffset, sprintf('%s', uniqueRoles{i}), 'HorizontalAlignment', 'left', ...
%         'VerticalAlignment', 'middle', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'k', 'Rotation',45);
% end
% 
% hold off;
% xlabel('Correlation of isEstablished score')


