function plot_scalp_net_graph(matrix,chanlocs)
 

 % matrix: binary matrix
 %chanlocs: EEG.chanlocs
    figure;
    [tmpeloc labels Th Rd indices] = readlocs(chanlocs);
    Th = pi/180*Th; 
    [x,y] = pol2cart(Th,Rd);  % transform electrode locations from polar to cartesian coordinates
    circ = linspace(0,2*pi,201);
    rx = sin(circ); 
    ry = cos(circ); 
    headx = [rx(:)' rx(1)]*0.4797;
    heady = [ry(:)' ry(1)]*0.4797;
    ringh= plot(headx,heady);
    set(ringh, 'color','c','linewidth', 2); hold on
     EarX  = [.497-.005  .510  .518  .5299 .5419  .54    .547   .532   .510   .489-.005]; % rmax = 0.5
     q = .04; % ear lengthening
     EarY  = [q+.0555 q+.0775 q+.0783 q+.0746 q+.0555 -.0055 -.0932 -.1313 -.1384 -.1199];
     plot3([0.09;0.02;0;-0.02;-0.09]*0.9629,[0.4954;0.57;0.575;0.57;0.4954]*0.9629,...
             2*ones(size([0.09;0.02;0;-0.02;-0.09])),...
             'Color','c','LineWidth',2);                 % plot nose
     plot3(EarX*0.9629,EarY*0.9629,2*ones(size(EarX)),'color','c','LineWidth',2)    % plot left ear
     plot3(-EarX*0.9629,EarY*0.9629,2*ones(size(EarY)),'color','c','LineWidth',2)   % plot right ear
     title('0.01*data','FontSize',14);
     set(gcf, 'color', [1,1,1]);
    axis square                                           % make plotax square
    axis off
    
    G = graph(matrix);
    h = plot(G,'XData',y,'YData',x,'NodeLabel',labels);
    h.EdgeColor = 'g';
    h.NodeColor = 'r';
    h.MarkerSize = 8;
    labels = h.NodeLabel; 
    h.NodeLabel=[];
    for i=1:length(labels) 
        text(h.XData(i)-0.02,h.YData(i)+0.02,labels(i),'FontSize',12); 
    end 
    h.LineWidth = 2;
    h.ArrowSize = 10;
    ax = gca;
    ax.Title.HorizontalAlignment='left';
    try
      set(gcf, 'color', [1,1,1]); 
    catch
    end
    hold off
    axis off
end
