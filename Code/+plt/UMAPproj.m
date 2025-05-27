
function UMAPproj(answ, dgs, sort_cat, pars)

% INPUTS: 
% answ      structure with fields: importance, isEstablishes, ifPublic,
%           quetion_labels. Each fiels is a matrix nAnsw*nQ
% dgs       table with demographic data
% sort_cat  string, corresponding to the demographic category to be used
%           for sorting. e.g. 'CurrentRole'

% pars    3 element cell array, specifying the init pars for UMAP. 
%          uPI.metric = pars{1}; uPI.min_dist = pars{2}; uPI.n_neighbors =pars{3};
%           Default {'euclidean', 0.1, 7}


% Download package:
% https://it.mathworks.com/matlabcentral/fileexchange/71902-uniform-manifold-approximation-and-projection-umap
% consult:
% https://umap-learn.readthedocs.io/en/latest/parameters.html

% addpath(genpath('/Users/federico/Documents/MATLAB/umapFileExchange (4.4)/'));
addpath(genpath('C:\Users\bugeon\Documents\GitHub\UMAP'));

uPI = UMAP;
uPI.verbose = true;

if nargin < 4
uPI.metric = 'euclidean'; % 'correlation'
uPI.min_dist = 0.1; % 0.2; % default is 0.1, I have been running with 0.2.
uPI.n_neighbors =7; % 7 default is 15 which now works better. 40 is awful
else
uPI.metric = pars{1};
uPI.min_dist = pars{2};
uPI.n_neighbors =pars{3};
 
end

which_cat = strcmp(sort_cat, dgs.Properties.VariableNames);
uniqueRoles = unique(dgs{:, which_cat}); % Unique positions

% we run 3 separate models: 1 for importance, 1 for isEstablished, and 1
% for the concatenated max normalised data. 

allAnsw = cat(2, (answ.importance -nanmean(answ.importance(:)))/nanstd(answ.importance(:)), ...
(answ.isEstablished-nanmean(answ.isEstablished(:)))/nanstd(answ.isEstablished(:)));

impU = uPI.fit_transform(answ.importance);
estU = uPI.fit_transform(answ.isEstablished);
allU = uPI.fit_transform(allAnsw);

figure('Position', [110 110 1280 660]);
subplot(1,3,1)
hold on;
for i = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{i});
    plot(impU(idx , 1), impU(idx ,2), 'o', 'MarkerFaceColor', 'auto');

end
title(sprintf('Importance score %s %0.1f %d', pars{:}))
axis square
legend(uniqueRoles{:})
legend("Position", [0.165,0.13,0.16607,0.14524])
xlabel('UMAP 1')
ylabel('UMAP 2')

subplot(1,3,2)
hold on;
for i = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{i});
    plot(estU(idx , 1), estU(idx ,2), 'o', 'MarkerFaceColor', 'auto');

end
title(sprintf('isEsatblished %s %0.1f %d', pars{:}))
axis square
legend(uniqueRoles{:})
legend("Position", [0.445,0.13,0.16607,0.14524])

xlabel('UMAP 1')

subplot(1,3,3)
hold on;
for i = 1:length(uniqueRoles)
    idx = strcmp(dgs{:, which_cat}, uniqueRoles{i});
    plot(allU(idx , 1), allU(idx ,2), 'o', 'MarkerFaceColor', 'auto');

end
title(sprintf('Combined data %s %0.1f %d', pars{:}))
xlabel('UMAP 1')

axis square
legend(uniqueRoles{:})
legend("Position", [0.725,0.13,0.16607,0.14524])

end