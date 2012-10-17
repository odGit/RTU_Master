%/analyze.pl output80211_500max20_p0.tr
v=[0 5 10 15 20];
AODVdeliveryRatio=[ 0.9925 0.9790 0.9713  0.97213 0.9704];
AODVthrought=[150.13 147.94 147.20 146.94 146.67];
AODVdelay=[23.359287 18.420427 8.9257 13.1048 14.3965];

DSRdeliveryRatio=[0.9998 0.980  0.8574 0.92383  0.85767];
DSRthrought=[151.97 148.63 129.84 140.02 130.1];
DSRdelay=[27.944  38.6368 10.4415 31.3916 32.4827];



%1500x300
AODVdeliveryRatio1500=[ 0.6068 0.82612  0.70918 0.71139 0.7591];
AODVthrought1500=[92.13 125.12 107.70 107.50 115.04];
AODVdelay1500=[ 29.9862 24.582 13.123 12.255 14.089];

DSRdeliveryRatio1500=[ 0.6079 0.8435 0.7330  0.5446 0.6824];
DSRdelay1500=[44.867 56.6122 34.0189 63.6941 34.858];
DSRthrought1500=[91.94 127.85 111.06 81.02 103.67 ];

figure(1)
plot(v, AODVdeliveryRatio, 'g-p',v, DSRdeliveryRatio, 'r-*',v, AODVdeliveryRatio1500, 'b-p',v, DSRdeliveryRatio1500, 'm-*'), grid on;
vleg = legend('AODV 500x300','DSR 500x300','AODV 1500x300','DSR 1500x300','Location','NorthEastOutside');
	xlabel('v, [m/s]')
	ylabel('PDF')
axis([0 21 0 1.1]);
figure(2)
plot(v, AODVthrought, 'g-p',v, DSRthrought, 'r-*',v, AODVthrought1500, 'b-p',v, DSRthrought1500, 'm-*'), grid on;
vleg = legend('AODV 500x300','DSR 500x300','AODV 1500x300','DSR 1500x300','Location','NorthEastOutside');
xlabel('v, [m/s]')	
ylabel('Caurlaidspeja, [kbps]')
axis([0 21 50 180]);
figure(3)
plot(v, AODVdelay, 'g-p',v, DSRdelay, 'r-*',v, AODVdelay1500, 'b-p',v, DSRdelay1500, 'm-*'), grid on;
vleg = legend('AODV [500x300]','DSR [500x300]','AODV 1500x300','DSR 1500x300','Location','NorthEastOutside');
xlabel('v, [m/s]')	
ylabel('Aizkave, [s]')
axis([0 21 0 100]);

rho500=51/(500*300)
rho1500=51/(1500*300)
rho=51/1000
