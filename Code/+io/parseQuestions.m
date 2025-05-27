function answ = parseQuestions(data)

[question_labels,themes] = io.getQLab();

[numResp, numCols] = size(data);

nQ = numel(question_labels);
% Loop through each of the 29 pairs
importance = nan(numResp, nQ);
isEstablished = nan(numResp, nQ);
ifPublic = nan(numResp, nQ);


for iQ = 1:nQ
    % Construct the variable names for Import and Estab pairs
    if iQ ==1
        importVar = 'Import_';
        estabVar ='Estab_';
        publicVar ='Public_';
    else
    importVar = sprintf('Import__%d', iQ-1);
    estabVar = sprintf('Estab__%d', iQ-1);

    end
    
    % Check if these columns exist in the table
    if ismember(importVar, data.Properties.VariableNames) && ismember(estabVar, data.Properties.VariableNames)
        % Extract the data for the current pair
     fprintf('Found %s and %s \n', importVar, estabVar);

     [~, columnNumber] = ismember(importVar, data.Properties.VariableNames);
     
        importance(:, iQ) = data.(importVar);
        isEstablished(:, iQ) = io.yesno2num(data.(estabVar));

     if contains(data.Properties.VariableNames(columnNumber+1), 'Public')
        ifPublic(:, iQ) = io.yesno2num(data.(data.Properties.VariableNames{columnNumber+1}));
     end
              
    else
        fprintf('Columns %s and/or %s not found in the table.\n', importVar, estabVar);
    end
end

% add data about implementation (yes, maybe, no)
implement = io.yesno2num(data.Implement_);

% save(fullfile(data_repo, 'genInfo.answer.mat'), 'genInfo'); % nG*nResps
% save(fullfile(data_repo, 'genInfo.labels.mat'), 'general_labels'); % nG*1
% 
% save(fullfile(data_repo, 'question.answer.importance.mat'), 'importance'); % nQ*nResps
% save(fullfile(data_repo,'questions.answer.isEstablished.mat'), 'isEstablished'); % nQ*nResps
% save(fullfile(data_repo,'questions.labels.mat'), 'question_labels'); % nQ*1
answ = struct();
answ.importance = importance;
answ.isEstablished = isEstablished;
answ.ifPublic = ifPublic;
answ.implement = implement;
answ.question_labels = question_labels;
answ.themes = themes;
end