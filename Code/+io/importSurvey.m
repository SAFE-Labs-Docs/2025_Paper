function data = importSurvey(data_repo, filename)

try
    data = readtable(fullfile(data_repo, filename));
    disp('Data imported successfully.');
catch ME
    disp('Error importing data:');
    disp(ME.message);
    return;
end

% % Display the first few rows of the data
% disp('First few rows of the data:');
% disp(head(data));
% 
% % Display the column names
% disp('Column names in the dataset:');
% disp(data.Properties.VariableNames);
% 
% Optional: Check the dimensions of the table
[numResp, numCols] = size(data);
fprintf('The dataset contains %d rows and %d columns.\n', numResp, numCols);
end