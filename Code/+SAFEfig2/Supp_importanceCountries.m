function Supp_importanceCountries
% requires the violin plot function  for matlab which can be found there:
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
loadSurveyData;

%%
default_figure([1 1 8.3 11.7]);
clf;
xh = .5;
yh = .5;
MinPersonCountry = 12; % minimum nb of person in a country to be considered in analysis
colours = colororder;

[uniqueS,~,idx] = unique(dgs.Country,'stable');
count = hist(idx,unique(idx));
KeepCountries = count > MinPersonCountry ;
RoleList = uniqueS(KeepCountries);
CList = RoleList;
CList(strcmp(CList,'United Kingdom')) = {'UK'};
NList = CList;
Violin_Mksize = 8;
Violin_Alpha = 0.4;
FontSz = 6;
Stats = {};
%% violin plots of the averaged importance score across participants, for each Role
i=1;
hs{i}=my_subplot(5,5,1,[xh yh]);
hs{i}.Position(1) = hs{i}.Position(1)+.10;
hs{i}.Position(2) = hs{i}.Position(2) + .01;
axis off;
hp=hs{i}.Position;
axes('position',[hp(1) hp(2)-.07 1.5*hp(3) 1.1*hp(4)]);

avg_imp = mean(answ.importance,2);

Violin({avg_imp}, 1, 'ViolinColor',{[0 0 0]},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
for k=1:length(RoleList)
    dummy = strcmp(RoleList{k},dgs.Country);
    Violin({avg_imp(dummy)}, k + 2, 'ViolinColor',{colours(k,:)},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
end

xtickangle(45)
ylabel('Importance score','FontSize',FontSz)
ylim([1 5])
V0 = get(gca,'Position');
ThisR = ismember(dgs.Country,RoleList);
[p,~,stats]= kruskalwallis(avg_imp(ThisR),dgs.Country(ThisR),'off');
[c,~,~,gnames] = multcompare(stats,'display','off');
S = pRules(p);
title(['Kruskal Wallis ',S])
set(gca,'FontSize',FontSz)
XL = xlim;
plot(XL,[3 3],'--','Color',[0.8 0.8 0.8])
camroll(-90)
set(gca,'XTick',1:length(RoleList)+2,'XTickLabel',[{'All';''};NList],'FontSize',FontSz)
set(gca,'YAxisLocation','right')
xtickangle(0)
addLetter(gca,'a')
S = procKWmultcompare(c,gnames);
Stats{1,1} = [{'a'},{p},S];
%% violin plots of the averaged established score across participants, for each Role
axes('position',[V0(1)+V0(3)+0.05 V0(2) V0(3) V0(4)]);
avg_imp = mean(answ.isEstablished,2,"omitnan");

Violin({100*avg_imp}, 1, 'ViolinColor',{[0 0 0]},'ViolinAlpha',{Violin_Alpha},'MarkerSize',Violin_Mksize);
for k=1:length(RoleList)
    dummy = strcmp(RoleList{k},dgs.Country);
    Violin({100*avg_imp(dummy)}, k + 2, 'ViolinColor',{colours(k,:)},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
    % nanmedian(100*avg_imp(dummy))
end

ylabel('Implementation Rate','FontSize',FontSz)
ylim([0 100])
V = get(gca,'Position');
set(gca, 'YTick', 0:50:100, 'FontSize',FontSz);
ThisR = ismember(dgs.Country,RoleList);
[p,~,stats] = kruskalwallis(avg_imp(ThisR),dgs.Country(ThisR),'off');
[c,~,~,gnames] = multcompare(stats,'display','off');
S = pRules(p);
title(['Kruskal Wallis ',S])
set(gca,'FontSize',FontSz)
XL = xlim;
plot(XL,[50 50],'--','Color',[0.8 0.8 0.8])
camroll(-90)
set(gca,'YAxisLocation','right')
set(gca,'XTick',1:length(RoleList)+2,'XTickLabel',[])
addLetter(gca,'c')
S = procKWmultcompare(c,gnames);
Stats{2,1} = [{'c'},{p},S];
%% plot distribution of importance and established scores

% parse which column in dgs to query
which_cat = strcmp('Country', dgs.Properties.VariableNames);
% add categories
uniqueRoles = RoleList; % Unique positions
%% violin plots of the averaged importance score across participants, for each Role
Rl = {'e','f','g','h','i'};
A1  = axes('position',[V0(1) V0(2)-V0(4)-0.32 V0(3) 0.4]);
A = get(A1,'Position');
camroll(A1,-90)
A2 = axes('position',[V(1) A(2) V(3) A(4)]);
camroll(A2,-90)
A3 = {};
% Sort answers based on ascending average importance score
[~, sorted_imp_indices] = sort(mean(answ.importance));

for k = 1:length(uniqueRoles)
    if k==0
        idx = true(size(dgs,1),1);
    else
        idx = strcmp(dgs{:, which_cat}, uniqueRoles{k}) & strcmp(dgs.CurrentRole, 'PI'); % keep observations for PIs only
        sum(idx)
    end
    
    importance = answ.importance(idx,:);
    isEstablished = answ.isEstablished(idx,:);
    question_labels = answ.question_labels;

    [nA, nQ] =size(importance);

    zsc_importance = importance;
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
    dummy = answ.implement(idx, :);
    for j=1:size(dummy,2)
        impledistbycat(k,:,j) = histcounts(dummy(:,j), [-0.1:0.4:1.2]);
        impledistbycat(k,:,j) = impledistbycat(k,:,j)/sum(impledistbycat(k,:,j));
    end
    % if isempty(sort_cat)
    % Sort answers based on ascending average importance score
    sorted_imp_scores = avg_importance_scores(sorted_imp_indices);

    % sort answers in ascending order for plotting purposes
    sorted_hme_scores = 100*howmuchEstablished(sorted_imp_indices);
    sorted_impDist = impDist(:, sorted_imp_indices);
    imp_sorted_labels = question_labels(sorted_imp_indices);
    imp_sorted_std = 100*se_importance_scores(sorted_imp_indices);
    imp_sorted_hme = 100*howmuchEstablished (sorted_imp_indices);

    se_sorted_hme = seEstablished(sorted_imp_indices);
    sorted_estDist = estDist(:, sorted_imp_indices);
    est_sorted_labels = question_labels(sorted_imp_indices);

    % compute correlation between imp and est
    lm = fitlm(sorted_imp_scores, imp_sorted_hme, "Intercept",true, "RobustOpts","on");

    % plot average importance y role for each question
    hold(A1,'on')
    errorbar(A1,sorted_imp_scores, imp_sorted_std, 'o','Color','none', 'MarkerFaceColor', colours(k,:),'MarkerEdgeColor', colours(k,:),'MarkerSize',3);
    box(A1,'off')
    % 
    ylabel(A1,'Importance score')
    ylim(A1,[1 5])
      xlim(A1,[0 31])
    XL = xlim(A1);
    plot(A1,XL,[3 3],'--','Color',[0.8 0.8 0.8])
    set(A1, 'XTick', 1:length(est_sorted_labels), 'XTickLabel', est_sorted_labels, 'XTickLabelRotation', 0,'FontSize',FontSz);
    set(A1,'YAxisLocation','right')
    % plot how established by role for each question
    hold(A2,'on')
    errorbar(A2,sorted_hme_scores, se_sorted_hme, 'o','Color','none', 'MarkerFaceColor', colours(k,:),'MarkerEdgeColor', colours(k,:),'MarkerSize',3);
    box(A2,'off')
    
    set(A2, 'YTick', 0:50:100,'FontSize',FontSz);
    ylabel(A2,'Implementation Rate')
    set(A2,'FontSize',FontSz)
      xlim(A2,[0 31])
    XL = xlim;
    plot(XL,[50 50],'--','Color',[0.8 0.8 0.8])
    ylim(A2,[0 100])
    set(A2, 'XTick',1:length(est_sorted_labels),'XTickLabel',[],'FontSize',FontSz)
    set(A2,'YAxisLocation','right')


    % plot correlation between importance and establish
    if k==1
        A3{k} = axes('position',[V(1)+V(3)+0.09 V(2)+0.03 V(3) V(4)*0.7]);
    else
        A3{k} = axes('position',[V2(1) V2(2)-V2(4)-0.04 V2(3) V2(4)]);
    end
    plot(A3{k},sorted_imp_scores, imp_sorted_hme, 'o','MarkerFaceColor',colours(k,:), 'MarkerEdgeColor',colours(k,:),'MarkerSize',4);
    [cc,p] = corr(sorted_imp_scores', imp_sorted_hme');S = pRules(p);
    Stats{k+2,1} = [Rl(k),{p}];
    hold(A3{k},'on')
    plot(A3{k},lm,'Marker','.','MarkerEdgeColor','none','MarkerFaceColor','none')
    axis(A3{k},'square')
    xlim(A3{k},[3.5 5])
    ylim(A3{k},[0 100])
    if k==length(uniqueRoles)
        set(A3{k}, 'YTick', 0:50:100,'FontSize',FontSz);
        xlabel(A3{k},'Importance score','FontSize',FontSz);
        
    else
        xlabel('')
        set(A3{k}, 'YTick', 0:50:100,'FontSize',FontSz)
    end
    ylabel(A3{k},'Implementation Rate','FontSize',FontSz);
    legend(A3{k},'off')
    title(A3{k},{NList{k},['r = ',num2str(round(cc,4)),S]},'FontSize',FontSz)
    box off;
    V2 = get(A3{k},'Position');
    set(A3{k},'FontSize',FontSz)
end

impledistbycat = 100*impledistbycat;

addLetter(A1,'b')
addLetter(A2,'d')
for k=1:length(RoleList)
    addLetter(A3{k},Rl{k})
end

nS = cellfun(@(x) length(x),Stats);
T = {};
for i=1:length(Stats)
    for j=1:nS
        if j<=length(Stats{i})
        T{i,j} = Stats{i}{j};
        end
    end
end
T = cell2table(T);
%%
writetable(T,fullfile(OutF,'Supp_Fig3_importanceCountries_stats.xlsx'));
saveas(gcf, fullfile(OutF,'Supp_Fig3_importanceCountries.pdf'));
print(gcf, fullfile(OutF,'Supp_Fig3_importanceCountries.png'),'-dpng','-r600');

