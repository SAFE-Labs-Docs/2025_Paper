function G
% requires the violin plot function  for matlab which can be found there:
% https://fr.mathworks.com/matlabcentral/fileexchange/170126-violinplot-matlab
loadSurveyData;

MinPersonCountry = 12; % minimum nb of person in a country to be considered in analysis
colours = colororder;
%%
default_figure([1 1 8 12]);
clf;
xh = .5;
yh = .5;

[uniqueS,~,idx] = unique(dgs.Country,'stable');
count = hist(idx,unique(idx));
KeepCountries = count > MinPersonCountry ;
RoleList = uniqueS(KeepCountries);
CList = RoleList;
CList(strcmp(CList,'United Kingdom')) = {'UK'};
NList = CList;
Violin_Mksize = 8;
Violin_Alpha = 0.4;
FontSz = 10;
%% violin plots of the averaged importance score across participants, for each Role
i=1;
hs{i}=my_subplot(5,5,1,[xh yh]);
hs{i}.Position(1) = hs{i}.Position(1)+.02;
hs{i}.Position(2) = hs{i}.Position(2) + .01;
axis off;
hp=hs{i}.Position;
axes('position',[hp(1) hp(2)-.07 2*hp(3) 1.3*hp(4)]);

avg_imp = nanmean(answ.importance,2);

for k=1:length(RoleList)
    dummy = strcmp(RoleList{k},dgs.Country);
    Violin({avg_imp(dummy)}, k , 'ViolinColor',{colours(k,:)},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
end
set(gca,'XTick',1:length(RoleList),'XTickLabel',[],'FontSize',FontSz)
xtickangle(45)
ylabel('Mean importance','FontSize',FontSz)
ylim([1 5])
V0 = get(gca,'Position');
ThisR = ismember(dgs.Country,RoleList);
p = kruskalwallis(avg_imp(ThisR),dgs.Country(ThisR),'off');
S = pRules(p);
title(['Kruskal Wallis ',S])
set(gca,'FontSize',FontSz)
XL = xlim;
plot(XL,[3 3],'--','Color',[0.8 0.8 0.8])
addLetter(gca,'a')
%% violin plots of the averaged established score across participants, for each Role
axes('position',[V0(1) V0(2)-V0(4)-0.04 V0(3) V0(4)]);
avg_imp = nanmean(answ.isEstablished,2);

for k=1:length(RoleList)
    dummy = strcmp(RoleList{k},dgs.Country);
    Violin({100*avg_imp(dummy)}, k , 'ViolinColor',{colours(k,:)},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
end
set(gca,'XTick',1:length(RoleList),'XTickLabel',CList,'FontSize',FontSz)
xtickangle(45)
ylabel('Implementation Rate','FontSize',FontSz)
ylim([0 100])
V = get(gca,'Position');
set(gca, 'YTick', 0:50:100, 'FontSize',FontSz);
ThisR = ismember(dgs.Country,RoleList);
p = kruskalwallis(avg_imp(ThisR),dgs.Country(ThisR),'off');
S = pRules(p);
title(['Kruskal Wallis ',S])
set(gca,'FontSize',FontSz)
XL = xlim;
plot(XL,[50 50],'--','Color',[0.8 0.8 0.8])
addLetter(gca,'c')
%% plot distribution of importance and established scores

% parse which column in dgs to query
which_cat = strcmp('Country', dgs.Properties.VariableNames);
% add categories
uniqueRoles = RoleList; % Unique positions
%% violin plots of the averaged importance score across participants, for each Role
Rl = {'e','f','g','h','i','j','k'};
A1  = axes('position',[V0(1)+V0(3)+ 0.07 V0(2) 0.57 V0(4)]);
A = get(A1,'Position');

A2 = axes('position',[A(1) V(2) A(3) V(4)]);

which_cat2 = strcmp('CurrentRole', dgs.Properties.VariableNames);
% Sort answers based on ascending average importance score
idx = strcmp(dgs{:, which_cat2}, 'PI'); % keep observations for PI
[~, sorted_imp_indices] = sort(mean(answ.importance(idx,:)));

for k = 1:length(uniqueRoles)
    if k==0
        idx = true(size(dgs,1),1);
    else
        idx = strcmp(dgs{:, which_cat}, uniqueRoles{k}) & strcmp(dgs.CurrentRole, 'PI'); % keep observations for each category
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
    sorted_hme_scores = howmuchEstablished(sorted_imp_indices);
    sorted_impDist = impDist(:, sorted_imp_indices);
    imp_sorted_labels = question_labels(sorted_imp_indices);
    imp_sorted_std = se_importance_scores(sorted_imp_indices);
    imp_sorted_hme = howmuchEstablished (sorted_imp_indices);

    se_sorted_hme = seEstablished(sorted_imp_indices);
    sorted_estDist = estDist(:, sorted_imp_indices);
    est_sorted_labels = question_labels(sorted_imp_indices);

    % compute correlation between imp and est
    lm = fitlm(sorted_imp_scores, 100*imp_sorted_hme, "Intercept",true, "RobustOpts","on");

    % plot average importance y role for each question
    hold(A1,'on')
    errorbar(A1,sorted_imp_scores, imp_sorted_std, 'o','Color','none', 'MarkerFaceColor', colours(k,:),'MarkerEdgeColor', colours(k,:),'MarkerSize',3);
    box(A1,'off')
    set(A1, 'XTick',1:length(est_sorted_labels),'XTickLabel',[],'FontSize',FontSz)
    title(A1,'Importance score','FontSize',FontSz)
      ylim(A1,[1 5])
     XL = xlim(A1);
    plot(A1,XL,[3 3],'--','Color',[0.8 0.8 0.8])
    % plot how established by role for each question
    hold(A2,'on')
    errorbar(A2,100*sorted_hme_scores, se_sorted_hme, 'o','Color','none', 'MarkerFaceColor', colours(k,:),'MarkerEdgeColor', colours(k,:),'MarkerSize',3);
    box(A2,'off')
    set(A2, 'XTick', 1:length(est_sorted_labels), 'XTickLabel', est_sorted_labels, 'XTickLabelRotation', 45,'FontSize',FontSz);
    set(A2, 'YTick', 0:50:100, 'FontSize',FontSz);
    title(A2,'Implementation Rate','FontSize',FontSz)
      XL = xlim;
    plot(XL,[50 50],'--','Color',[0.8 0.8 0.8])
    set(gca,'FontSize',FontSz)
      ylim(A2,[0 100])
    %     % plot histograms for importance
    %     i=i+1;
    %     hs{i}=my_subplot(5,5,2,[xh yh]);
    %     hs{i}.Position(1) = hs{i}.Position(1)+.02;
    %     hs{i}.Position(2) = hs{i}.Position(2) + .01;
    %     axis off;
    %     hp=hs{i}.Position;
    %     axes('position',[hp(1)+0.12 hp(2)+0.001 0.57 0.1]);
    %     A = get(gca,'Position');
    %     imagesc(1:length(imp_sorted_labels), 0:5, sorted_impDist); hold on; axis xy
    %     colormap(1-gray);
    %     errorbar(sorted_imp_scores, imp_sorted_std, 'or', 'MarkerFaceColor', [ 1 0 0],'MarkerSize',3);
    %     box off
    %     XL = xlim;
    %     YL = ylim;
    %     line([XL(2) XL(2)],[YL(1) YL(2)],'Color','k')
    %     line([XL(1) XL(2)],[YL(2) YL(2)],'Color','k')
    %     % set(gca, 'XTick', 1:length(imp_sorted_labels), 'XTickLabel', imp_sorted_labels, 'XTickLabelRotation', 45);
    %     title('Importance score, ascending order')
    %     set(gca, 'XTick',1:length(est_sorted_labels),'XTickLabel',[],'FontSize',10)
    %
    %     % plot histograms for importance
    %     axes('position',[A(1) A(2)-A(4)-0.025 A(3) A(4)]);
    %     imagesc(1:length(imp_sorted_labels), -1:2, sorted_estDist); hold on; axis xy
    %     colormap(1-gray);
    %     errorbar(sorted_hme_scores, se_sorted_hme, 'or', 'MarkerFaceColor', [ 1 0 0],'MarkerSize',3);
    %     set(gca, 'XTick', 1:length(est_sorted_labels), 'XTickLabel', est_sorted_labels, 'XTickLabelRotation', 45,'FontSize',10);
    %     set(gca, 'YTick', -1:2, 'YTickLabel', {'Not known' ,'No', 'Partly', 'Yes'}, 'YTickLabelRotation', 45,'FontSize',10);
    %     title('How much established score, sorted by mean importance')
    %     box off
    %     XL = xlim;
    %     YL = ylim;
    %     line([XL(2) XL(2)],[YL(1) YL(2)],'Color','k')
    %     line([XL(1) XL(2)],[YL(2) YL(2)],'Color','k')
    %
    % plot correlation between importance and establish
    if k==1
        A3{k} = axes('position',[V(1) V(2)-V(4)-0.125 V(3)/1.5 V(4)]);
        V = get(A3{k},'Position');
    else
        A3{k} = axes('position',[V2(1)+V2(3)+ 0.05 V2(2) V2(3) V2(4)]);
    end
    plot(A3{k},sorted_imp_scores, 100*imp_sorted_hme, 'o','MarkerFaceColor',colours(k,:), 'MarkerEdgeColor',colours(k,:),'MarkerSize',4);
    [cc,p] = corr(sorted_imp_scores', imp_sorted_hme');S = pRules(p);
    hold(A3{k},'on')
    plot(A3{k},lm,'Marker','.','MarkerEdgeColor','none','MarkerFaceColor','none')
    axis(A3{k},'square')
    xlim(A3{k},[3.5 5])
    ylim(A3{k},[0 100])
    if k==1
        set(A3{k}, 'YTick', 0:50:100,'FontSize',FontSz);
        ylabel(A3{k},'Implementation Rate','FontSize',FontSz);
    else
        ylabel('')
        set(A3{k}, 'YTick', 0:50:100,'YTickLabel', {})
    end
    xlabel(A3{k},'Mean Importance','FontSize',FontSz);
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
%% plot whether participants would implement this Handbook
axes('position',[V(1) V(2)-V(4)-0.06 V0(3)*1.5 V(4)]);

b = bar(impledistbycat');
for i=1:length(b)
    b(i).FaceColor = colours(i,:);
end
ylim([0 100])
ylabel('Percentage (%)','FontSize',FontSz)
set(gca, 'XTick', 1:3, 'XTickLabel', {'No','Maybe','Yes'},'FontSize',FontSz)
title('Implement in your lab?','FontSize',FontSz);
box off;
set(gca,'FontSize',FontSz)
V3 = get(gca,'Position');
addLetter(gca,'j')
 %% response correlation between participants in each country 
% 
% [impCorr, estCorr, uC] = plt.answcorr2(answ, dgs, 'Country');
% [~,ThisC] = ismember(RoleList,uC);
% impCorr = impCorr(ThisC);
% estCorr = estCorr(ThisC);
% 
% axes('position',[V3(1)+V3(3)+ 0.1 V3(2) V(3) V(4)]);
% for k=1:length(RoleList)
%     I = impCorr{k}; T = triu(ones(size(I)),1);
%     I = I(logical(T));
%     Violin({I}, k , 'ViolinColor',{colours(k,:)},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
% end
% set(gca,'XTick',1:length(RoleList),'XTickLabel',CList,'FontSize',FontSz)
% xtickangle(45)
% ylabel('Correlation for importance','FontSize',FontSz)
% ylim([-1 1])
% set(gca,'FontSize',FontSz)
% V3 = get(gca,'Position');
% 
% axes('position',[V3(1)+V3(3)+ 0.1 V3(2) V(3) V(4)]);
% for k=1:length(RoleList)
%     I = estCorr{k}; T = triu(ones(size(I)),1);
%     I = I(logical(T));
%     Violin({I}, k , 'ViolinColor',{colours(k,:)},'ViolinAlpha',{Violin_Alpha },'MarkerSize',Violin_Mksize);
% end
% set(gca,'XTick',1:length(RoleList),'XTickLabel',CList,'FontSize',FontSz)
% xtickangle(45)
% ylabel('Correlation for established','FontSize',FontSz)
% ylim([-1 1])
% set(gca,'FontSize',FontSz)

%%

saveas(gcf, fullfile(OutF,'Figure5.pdf'));
print(gcf, fullfile(OutF,'Figure5.png'),'-dpng','-r600');