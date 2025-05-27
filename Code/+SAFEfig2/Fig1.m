function Fig1

% function Enew
loadSurveyData;
%%
FontSz=6;
default_figure([1 1 8.3 11.7]);
clf;

%% logo
axes('position',[0.05 0.65 0.15 0.15]);
I = imread(fullfile(data_repo,'Logo.png'));
imshow(I)
axis off
addLetter(gca,'a')
%%
step=0; id=1;
cc=cell(3,1);
ax1 = axes('position',[0.24 0.4 0.14 0.4]);
V1 = get(ax1,'Position');
for i=1:length(answ.question_labels)
    if i~=1 & answ.themes.questions(i-1)~= answ.themes.questions(i)
        step = step + 0;
        id = id+1;
    else
        step = step + 0;
    end
    text(ax1,6,length(answ.question_labels)-i-step,answ.question_labels{i},...
        'Color',colour.(answ.themes.names{answ.themes.questions(i)+1})./256,...
        'HorizontalAlignment','right','FontSize',FontSz)
    cc{id} = [cc{id};length(answ.question_labels)-i-step];
end
ylim(ax1,[-1.2 length(answ.question_labels)-1.2])
axis off
ccM = cellfun(@mean,cc);
for j=1:length(ccM)
    text(ax1,-2,ccM(j)-0.5,answ.themes.names{j},'VerticalAlignment','middle',...
        'HorizontalAlignment','center','Rotation',90,'FontSize',FontSz+4,'FontWeight','bold',...
        'Color',colour.(answ.themes.names{j})./256)
end
xlim(ax1,[-3 4.5])
%
axC = 0.3*[1 1 1];
addLetter(ax1,'b')

ax2 = axes('position',[V1(1) + V1(3) + 0.04 V1(2)+0.005 0.05 V1(4)]);
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
set(gca,'XTick',1:3,'XTickLabel',N,'FontSize',FontSz)
xtickangle(45)
set(gca,'XAxisLocation','top')
box off
V2 = get(ax2,'Position');
%% full statements

ax3 = axes('position',[V2(1) + V2(3)+0.01  V1(2) 0.05 V1(4)]);
for i=1:length(answ.question_labels)
    comm{i} = strrep(comm{i},'to document','to internally document');
    text(ax3,0,length(answ.question_labels)-i-step,strrep(comm{i},'I commit to','...'),...
        'Color',colour.(answ.themes.names{answ.themes.questions(i)+1})./256,...
        'HorizontalAlignment','left','FontSize',FontSz)
end
ylim(ax3,[-1.2 length(answ.question_labels)-1.2])
axis off

ax= axes('position',[V2(1)-0.1  V1(2)+V1(4)+0.02 0.1 0.1]);

text(ax,0,0,'I commit to ...',...
    'Color','k',...
    'HorizontalAlignment','left','FontSize',FontSz+2,'FontWeight','normal')
ylim(ax3,[-1.2 length(answ.question_labels)-1.2])
axis off
%%
saveas(gcf, fullfile(OutF,'Fig1.pdf'));
print(gcf, fullfile(OutF,'Fig1.png'),'-dpng','-r600');