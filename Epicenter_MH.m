% Penentuan Epicenter
% Metropolis-Hasting Algoritm

clear, clc, close all

%Penentuan Ruang Model
xmin=0;
xmax=200;
ymin=0;
ymax=200;
x=linspace(xmin,xmax,50);
y=linspace(ymin,ymax,50);

% posisi episenter sebenarnya
x0=105;
y0=80;

% posisi stasiun gempa
xsts=[20;15;160;170];
ysts=[25;155;150;20];

% cepat rambat gelombang
vp=5;

% Forward Modelling
tobs=1/vp*sqrt((xsts-x0).^2+(ysts-y0).^2);

% Pemilihan model awal secara random uniform
x1 = xmin+rand*(xmax-xmin);
y1 = ymin+rand*(ymax-ymin);

%Jumlah iterasi
niter=1500;

%Proses Iterasi
for i =1:niter
    % perturbasi model dengan radius 0.3
    x2 = x1+randn*(xmax-xmin)*0.3; 
    y2 = y1+randn*(ymax-ymin)*0.3;
       
    % Misfit
    tcal1=1/vp*sqrt((xsts-x1).^2+(ysts-y1).^2);
    tcal2=1/vp*sqrt((xsts-x2).^2+(ysts-y2).^2);
    e1 = mean(sqrt((tcal1-tobs).^2));
    e2 = mean(sqrt((tcal2-tobs).^2));
    
     % step untuk menerima atau menolak model baru
    if rand <= exp(-(e2-e1))
        x1=x2;
        y1=y2;
        e1 = e2;
        xacc(i) = x1;
        yacc(i) = y1;
        eacc(i) = e1;
       
    else
        x1=x1;
        y1=y1;
        e1 = e1;
        xacc(i) = x1;
        yacc(i) = y1;
        eacc(i) = e1;

    end
end

[mine,idx]=min(eacc);
xbest = xacc(idx);
ybest = yacc(idx);

%% Visualisasi
fh=figure(1);
plot(xacc,yacc,'s','color','c','MarkerSize',6,'MarkerFaceColor','#000000')
hold on
plot(x0,y0,'*r','Linewidth',2,'MarkerSize',10)
plot(xsts,ysts,'v','MarkerSize',8,'MarkerFaceColor','k','MarkerEdgeColor','r')
plot(xacc(1),yacc(1),'s','color','k','MarkerSize',8,'MarkerFaceColor','#0000FF')
plot(xbest,ybest,'s','color','k','MarkerSize',8,'MarkerFaceColor','#FF0000')
title('Determination of Earthquake Epicenter using Metropolis-Hasting Algorithm')
ylabel('y-location')
xlabel('x-location')
legend ('Update Model','True Epicenter','Station','Initial Model','Final Model')
axis equal;
axis([xmin xmax ymin ymax]);

fh.WindowState='maximize';
print('-dpng','Epicenter MH Algoritm','-r500');
