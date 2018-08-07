function plotpriceforecast(year,priceforecast)

D = size(year);
plot(year,priceforecast(1:D(2),1),'-mo','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',6);
title('Annual Price Forecast - Without New Generation');
xlabel('Year');
ylabel('$/MWhr');

return;