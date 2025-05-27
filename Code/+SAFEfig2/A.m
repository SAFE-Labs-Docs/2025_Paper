% function A 

% show SAFE labs logo, commitments key word colored by 3 themes, matrix of
% public, internally, establish

loadSurveyData;
%%
default_figure([1 1 8 12]);
clf;
step=0; id=1;
cc=cell(3,1);
ax1 = axes('position',[0.05 0.6 0.15 0.3]);
V1 = get(ax1,'Position');
for i=1:length(answ.question_labels)
    if i~=1 & answ.themes.questions(i-1)~= answ.themes.questions(i)
        step = step + 0;
        id = id+1;
    else
        step = step + 0;
    end
    text(ax1,9,length(answ.question_labels)-i-step,answ.question_labels{i},...
        'Color',colour.(answ.themes.names{answ.themes.questions(i)+1})./256,...
        'HorizontalAlignment','right')
    cc{id} = [cc{id};length(answ.question_labels)-i-step];
end
ylim(ax1,[-1.5 length(answ.question_labels)-1.5])
axis off
ccM = cellfun(@mean,cc);
for j=1:length(ccM)
    text(ax1,-2,ccM(j)-0.5,answ.themes.names{j},'VerticalAlignment','middle',...
        'HorizontalAlignment','center','Rotation',90,'FontSize',16,'FontWeight','bold',...
        'Color',colour.(answ.themes.names{j})./256)
end
xlim(ax1,[-3 6])

%
axC = 0.3*[1 1 1];
ax2 = axes('position',[V1(1) + V1(3) + 0.06 V1(2) 0.05 V1(4)]);
N =  {'Publicly Document','Internally Document','Establish'};
M = zeros(length(answ.question_labels),3);
M(:,1) = contains(comm,'publicly');
M(:,3) = contains(comm,'establish');
M(:,2) = ~contains(comm,'establish') & ~contains(comm,'publicly');
imagesc(ax2,M)
colormap(flipud(gray))
set(gca,'XTick',[],'YTick',[],'XColor',axC,'YColor',axC)
XL = xlim;YL = ylim;
for i=1:size(M,1)
    hold on
    plot(XL,[1 1]*(i-0.5),'Color',axC)
end

for i=1:size(M,2)
    hold on
    plot([1 1]*(i-0.5),YL,'Color',axC)
end
plot([1 1]*(i+0.5),YL,'Color',axC)
set(gca,'XTick',1:3,'XTickLabel',N)
xtickangle(60)
box off