function feedbackSummary(data_repo, filename)

data = table2array(readtable(fullfile(data_repo, filename)));

H = readtable(fullfile(data_repo, filename),"FileType",'spreadsheet','Sheet','labels','ReadVariableNames', false);
H.Question(1:7) = repmat({'How much would you agree with the following statements?'},7,1);
H.Question(8:15) = repmat({'How would you rate the following aspects of the conference?'},8,1);
H.Question(16:22) = repmat({'Please indicate how useful you found each of the sessions/topics'},7,1);
u = unique(H.Question);

% plots
for i=1:length(u)
    idx = find(strcmp(H.Question, u{i}));
    Ncat = length(idx);
    figure('Position',[600*(i-1),(8-Ncat)*150,581,Ncat*150])
    for j=1:Ncat
            dataDist = histcounts(data(:, idx(j)), [0.5:1:5.5]);
            % dataDist = impDist(:, iQ) /sum(impDist(:, iQ));
            subplot(Ncat,1,j)
            bar(1:5,dataDist)
            title(H.Var1{idx(j)})
    end
    sgtitle(u{i})
end
