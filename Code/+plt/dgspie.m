function dgspie(dgs)

% plots pie charts of each of the columns in table dgs.


% plot roles
[roleCounts, roleCats] = groupcounts(dgs.CurrentRole); % Count occurrences of each position
roleLabels= strcat(roleCats, " (", string(roleCounts), ")");

figure( 'Position', [300 200 880 560]);
pie(roleCounts);
title('Distribution of Roles');
legend(roleLabels, 'Location', 'eastoutside');

% plot year in role
[yearCounts, yearCats] = groupcounts(dgs.YearsInRole); % Count occurrences of each position
yearLabels= strcat(yearCats, " (", string(yearCounts), ")");

figure( 'Position', [300 200 880 560]);
pie(yearCounts);
title('Year in role');
legend(yearLabels, 'Location', 'eastoutside');

% plot fileds
[fieldCounts, fieldCats] = groupcounts(dgs.Field); % Count occurrences of each position
fieldLabels= strcat(fieldCats, " (", string(fieldCounts), ")");

figure( 'Position', [300 200 880 560]);
pie(fieldCounts);
title('Distribution of Fields');
legend(fieldLabels, 'Location', 'eastoutside');

% plot countries
[countryCounts, countryCats] = groupcounts(dgs.Country); % Count occurrences of each position
countryLabels= strcat(countryCats, " (", string(countryCounts), ")");

figure( 'Position', [300 200 880 560]);
pie(countryCounts);
title('Distribution of Countries');
legend(countryLabels, 'Location', 'eastoutside');
