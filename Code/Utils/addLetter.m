function addLetter(ax,txt)

V = get(ax,'Position');

axes('position',[V(1)-0.03 V(2)+V(4)+0.02 0.01 0.01]);
text(0,0,txt,'FontSize',10,'FontWeight','bold')
axis off