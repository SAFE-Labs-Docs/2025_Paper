clear;

setPaths;

data = readtable(fullfile(data_repo, internal_handbook_survey),'VariableNamingRule','preserve');

comm_str = table2cell(readtable(fullfile(data_repo, commitment_table),'ReadVariableName',false))';

[numResp, numCols] = size(data);

question_labels = io.getQLab();

publ_idx = find(contains(data.Properties.VariableNames, 'Should it be'));
Q_comm_idx = publ_idx-2;
comm_idx = find(contains(data.Properties.VariableNames, 'I commit'));

[~, comm_order] = intersect(comm_idx, Q_comm_idx);




for iQ = 1:numel(publ_idx)

ifPublic(:, iQ) = io.public2num(data.(data.Properties.VariableNames{publ_idx(iQ)}));

end

Q_comm = question_labels(comm_order);

shouldbeP = sum(ifPublic, 1)./size(ifPublic, 1);
[~, Pidx] = sort(shouldbeP, 'ascend');
shouldbeP_sort =shouldbeP(Pidx);
Q_comm_sort =Q_comm(Pidx);

figure
plot([1, numel(publ_idx)], [0.1 0.1], '--r');hold on
plot([1, numel(publ_idx)], [0.5 0.5], '--r');
bar(1:numel(publ_idx), shouldbeP_sort, 0.9, 'k'); hold on
plot([1, numel(publ_idx)], [0.1 0.1], '--r');
plot([1, numel(publ_idx)], [0.5 0.5], '--r');
set(gca, 'XTick', 1:numel(publ_idx), 'XTickLabel', Q_comm_sort)
ylabel('Publicly document? (%)')
formatAxes
annotation('textbox',[0.05 0.9 0.05 0.05], ...
    'String','a','Fontsize', 14, 'FontWeight', 'bold', 'EdgeColor','none')
