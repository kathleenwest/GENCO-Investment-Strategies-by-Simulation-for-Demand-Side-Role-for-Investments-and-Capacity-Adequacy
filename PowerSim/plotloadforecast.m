function plotloadforecast(year,loadforecast)

D = size(year);

subplot(3,3,1)
plot(year,loadforecast(1,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 1');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,2)
plot(year,loadforecast(2,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 2');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,3)
plot(year,loadforecast(3,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 3');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,4)
plot(year,loadforecast(4,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 4');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,5)
plot(year,loadforecast(5,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 5');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,6)
plot(year,loadforecast(6,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 6');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,7)
plot(year,loadforecast(7,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 7');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,8)
plot(year,loadforecast(8,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 8');
xlabel('Year');
ylabel('MW Demand');

subplot(3,3,9)
plot(year,loadforecast(9,1:D(2)),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Load Forecast Bus 9');
xlabel('Year');
ylabel('MW Demand');

return;