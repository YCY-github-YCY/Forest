%% Global tree recovery version 4 2023 09 14
addpath('E:\科研\useful\cbrewer');
addpath('E:\科研\useful');
addpath('E:\科研\useful2');

%% Figure 1
load('E:\科研\森林恢复\data\data.mat');
lon=cell2mat(data(2:end,1));
lat=cell2mat(data(2:end,2));

dy=cellstr(data(2:end,4));
dye={'80s','90s','2000s','2010s'};
x1=nan(1699,1);
x1(strcmp(dy,dye(1))==1)=1;
x1(strcmp(dy,dye(2))==1)=2;
x1(strcmp(dy,dye(3))==1)=3;
x1(strcmp(dy,dye(4))==1)=4;
%
set(gcf,'paperpositionmode','auto','position',[10 20  800 700]);
axes('position',[0.08 0.55 0.38 0.4],'linewidth',0.8,'box','on')
shpPath='E:\科研\useful\Worldmap\global.shp';
shp=shaperead(shpPath);
    tempx=shp(1,1).X;
    tempy=shp(1,1).Y;
plot(tempx(22990:180187),tempy(22990:180187),'k-','linewidth',.4);hold on;

cm=cbrewer('qual','Set1',9,'Cubic');
cm2=cm([1 2 3 5],:);
for i=1:length(lon)
    plot(lon(i),lat(i),'.','markersize',8,'color',cm2(x1(i),:));hold on
end
ylim([-90 90]);xlim([-185 185]);
%box off
%axis off
text(-185-370*1.5/10,93,'a','fontsize',12,'fontweight','b');
set(gca,'xtick',-180:60:180,'xticklabel',{'180^{o}W','120^{o}W','60^{o}W','0^{o}','60^{o}E','120^{o}E','180^{o}E'});
set(gca,'ytick',-90:30:90,'yticklabel',{'90^{o}S','60^{o}S','30^{o}S','0^{o}','30^{o}N','60^{o}N','90^{o}N'});
xlabel('Longitude');
ylabel('Latitude');
set(gca,'linewidth',0.5,'fontsize',10);

dit=nan(4,1);
for i=1:4
    dit(i)=sum(x1==i)/length(x1)*100;
end
rectangle('position',[-90 -75 25 6],'facecolor',cm2(1,:)); text(-95,-83,'1980s','fontsize',10);
rectangle('position',[-30 -75 25 6],'facecolor',cm2(2,:)); text(-35,-83,'1990s','fontsize',10);
rectangle('position',[30 -75 25 6],'facecolor',cm2(3,:)); text(25,-83,'2000s','fontsize',10);
rectangle('position',[90 -75 25 6],'facecolor',cm2(4,:)); text(85,-83,'2010s','fontsize',10);
%
% b
rt_v=cell2mat(data(2:end,5));%recovery time of ndvi
rt_b=cell2mat(data(2:end,6));%recovery time of ndii

x1=nan(1699,1);
x1(rt_v<=2)=1;
x1(rt_v<=4&rt_v>2)=2;
x1(rt_v<=6&rt_v>4)=3;
x1(rt_v<=8&rt_v>6)=4;
x1(rt_v<=10&rt_v>8)=5;
x1(rt_v<=99&rt_v>10)=6;
x1(rt_v>99)=7;

x2=nan(1699,1);
x2(rt_b<=2)=1;
x2(rt_b<=4&rt_b>2)=2;
x2(rt_b<=6&rt_b>4)=3;
x2(rt_b<=8&rt_b>6)=4;
x2(rt_b<=10&rt_b>8)=5;
x2(rt_b<=99&rt_b>10)=6;
x2(rt_b>99)=7;

axes('position',[0.54 0.55 0.38 0.4],'linewidth',0.8,'box','on')
dat=nan(7,2);
for i=1:7
    dat(i,1)=sum(x1==i);
    dat(i,2)=sum(x2==i);
end
dat2=dat./1699*100;

bar(dat2(:,1),'facecolor',[0.5 0.4 0.4]);hold on; ylim([0 40]);
bar(dat2(:,2),'facecolor',[0.3 0.8 0.5]);hold on; ylim([0 40]);
alpha(0.5)
xlabel('RT (years)');
ylabel('Frequency (%)');
set(gca,'xtick',[1:6 7.4],'xticklabel',{'<2','3-4','5-6','7-8','9-10','>10','unrecovered'});
text(-1.2,41,'b','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
rectangle('position',[2.5 36 0.7 2],'facecolor',[0.75 0.7 0.7]); text(3.4,37,'NDVI','fontsize',10);
rectangle('position',[2.5 32 0.7 2],'facecolor',[166 229 191]/255); text(3.4,33,'NDII','fontsize',10);

%%
dy=cellstr(data(2:end,4));
dye={'80s','90s','2000s','2010s'};

dat=nan(4,5);
rt_v2=rt_v(rt_v<100&rt_b<100);
rt_b2=rt_b(rt_v<100&rt_b<100);
dy2=dy(rt_v<100&rt_b<100);
yy=rt_b2-rt_v2;

%差值的变化
for i=1:4
    yy2=yy(strcmp(dye(i),dy2)==1);
    dat(i,1)=mean(yy2);
    dat(i,2)=std(yy2)/length(yy2)^0.5;
    dat(i,3)=length(yy2);
    
    rt_v3=rt_v2(strcmp(dye(i),dy2)==1);
    dat(i,7)=mean(rt_v3);
    dat(i,8)=std(rt_v3)/length(rt_v3)^0.5;
    
    rt_b3=rt_b2(strcmp(dye(i),dy2)==1);
    dat(i,9)=mean(rt_b3);
    dat(i,10)=std(rt_b3)/length(rt_b3)^0.5;
end

%不能恢复的比例
for i=1:4
    x11=x1(strcmp(dye(i),dy)==1);
    dat(i,5)=sum(x11==7)/length(x11);
    
    x22=x2(strcmp(dye(i),dy)==1);
    dat(i,6)=sum(x22==7)/length(x22);
end
%
cc=[0.5 0.5 0.5;0.4 0.7 0.3; 0.2 0.3 0.5; 0.6 0.3 0.3];
axes('position',[0.08 0.06 0.38 0.4],'linewidth',0.8,'box','on')
plot(rt_v2,rt_b2,'.','markersize',8,'color',cc(1,:));hold on
xlim([0 30]);
ylim([0 30]);
set(gca,'xtick',0:10:30,'ytick',0:10:30);
xlabel('RT for NDVI (year)');
ylabel('RT for NDII (year)');
text(-4.5,30*41/40,'c','fontsize',12,'fontweight','b');
line([0 30],[0 30],'linestyle','--','linewidth',0.5,'color',[.7 .7 .7]);
set(gca,'linewidth',0.5,'fontsize',10);

axes('position',[0.28 0.12 0.17 0.1],'linewidth',0.8,'box','on')
bar(dat(:,5:6),1);
set(gca,'xtick',1:4,'xticklabel',{'1980s','1990s','2000s','2010s'});
xlim([0.5 4.5]);
text(1,0.4,'NDVI','color',[0 .45 .74],'fontsize',7);
text(1,0.32,'NDII','color',[.85 .33 .1],'fontsize',7);
set(gca,'ytick',0:0.2:0.4,'yticklabel',0:20:40);
box off
ylabel('Unrecovered ratio (%)');
set(gca,'linewidth',0.5,'fontsize',7);
%
% d
axes('position',[0.54 0.06 0.38 0.4],'linewidth',0.8,'box','on')
dd=[dat(:,7) dat(:,9)];
ee=[dat(:,8) dat(:,10)];
dd(5,1)=mean(rt_v2);dd(5,2)=mean(rt_b2);
ee(5,1)=std(rt_v2)/length(rt_v2)^0.5;ee(5,2)=std(rt_b2)/length(rt_b2)^0.5;

cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
hb1=barweb(dd,ee,1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
%alpha(0.5)
ylabel('RT (year)');
ylim([0 10]);
set(gca,'xtick',1:5,'xticklabel',{'1980s','1990s','2000s','2010s','Overall'});
text(0.86,8,'***','fontsize',10,'fontweight','b');
text(1.86,8.8,'***','fontsize',10,'fontweight','b');
text(2.86,9,'***','fontsize',10,'fontweight','b');
text(3.86,4,'***','fontsize',10,'fontweight','b');
text(4.86,7,'***','fontsize',10,'fontweight','b');
rectangle('position',[4 9 0.35 0.4],'facecolor',[0.75 0.7 0.7]); text(4.5,9.2,'NDVI','fontsize',10);
rectangle('position',[4 8 0.35 0.4],'facecolor',[0.65 0.9 0.75]); text(4.5,8.2,'NDII','fontsize',10);
hb1.bars(1).FaceColor=[0.5 0.4 0.4];
hb1.bars(2).FaceColor=[0.3 0.8 0.5];
alpha(0.5)
text(-0.115,10.25,'d','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig1');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig1');

%% Figure 2 RT for different decades
load('E:\科研\森林恢复\data\data2.mat');
dat=nan(7,18);dp=nan(6,3);

lie=[5 23 41 6 24 42;14 32 50 15 33 51];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
end

%% 以欧洲为样本进行比较
load('E:\科研\森林恢复\data\data2.mat');
dat=nan(7,18);dp=nan(6,3);

lie=[5 23 41 6 24 42;14 32 50 15 33 51];
ll=[5 23 41 5 23 41;14 32 50 14 32 50];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
lon=cell2mat(data2(2:end,ll(1,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(1,j)-3));lat=lat(~isnan(lat));
x1=x1(lon>=-9&lon<=66&lat>=36&lat<=71);

x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));
lon=cell2mat(data2(2:end,ll(2,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(2,j)-3));lat=lat(~isnan(lat));
x2=x2(lon>=-9&lon<=66&lat>=36&lat<=71);

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
dp(j,6)=std(x11)/length(x11)^0.5;
dp(j,7)=std(x22)/length(x22)^0.5;
end

%% Figure 2-1
cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
set(gcf,'paperpositionmode','auto','position',[10 20  350 600]);
axes('position',[0.15 0.55 0.78 0.4],'linewidth',0.8,'box','on')
barweb(dp(1:2,1:2),dp(1:2,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylabel('RT for NDVI (year)');
text(0.7,-0.35,'1980s','fontsize',10);
text(1.0,-0.35,'1990s','fontsize',10);
text(0.75,6.3,'a','fontsize',10);
text(1.05,6.3,'a','fontsize',10);

text(1.7,-0.35,'1990s','fontsize',10);
text(2.0,-0.35,'2000s','fontsize',10);
text(1.75,5.3,'a','fontsize',10);
text(2.05,6.5,'b','fontsize',10);
line([1.5 1.5],[0 7],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
ylim([0 7]);
set(gca,'linewidth',0.5,'fontsize',10);
%
axes('position',[0.15 0.08 0.78 0.4],'linewidth',0.8,'box','on')
barweb(dp(4:5,1:2),dp(4:5,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylim([0 12]);
ylabel('RT for NDII (year)');
text(0.7,-0.6,'1980s','fontsize',10);
text(1.0,-0.6,'1990s','fontsize',10);
text(0.75,8,'a','fontsize',10);
text(1.05,10.5,'b','fontsize',10);

text(1.7,-0.6,'1990s','fontsize',10);
text(2.0,-0.6,'2000s','fontsize',10);
text(1.75,7.2,'a','fontsize',10);
text(2.05,9.5,'b','fontsize',10);
line([1.5 1.5],[0 12],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
set(gca,'linewidth',0.5,'fontsize',10);
print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig2_1');

%% 北美洲
load('E:\科研\森林恢复\data\data2.mat');
dat=nan(7,18);dp=nan(6,3);

lie=[5 23 41 6 24 42;14 32 50 15 33 51];
ll=[5 23 41 5 23 41;14 32 50 14 32 50];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
lon=cell2mat(data2(2:end,ll(1,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(1,j)-3));lat=lat(~isnan(lat));
x1=x1(lon>=-167&lon<=-20&lat>=10&lat<=81);

x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));
lon=cell2mat(data2(2:end,ll(2,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(2,j)-3));lat=lat(~isnan(lat));
x2=x2(lon>=-167&lon<=-20&lat>=10&lat<=81);

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
dp(j,6)=std(x11)/length(x11)^0.5;
dp(j,7)=std(x22)/length(x22)^0.5;
end

%%
cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
set(gcf,'paperpositionmode','auto','position',[10 20  350 600]);
axes('position',[0.15 0.55 0.78 0.4],'linewidth',0.8,'box','on')
barweb(dp(1:2,1:2),dp(1:2,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylabel('RT for NDVI (year)');
text(0.7,-0.5,'1980s','fontsize',10);
text(1.0,-0.5,'1990s','fontsize',10);
text(0.75,7.5,'a','fontsize',10);
text(1.05,7.5,'a','fontsize',10);

text(1.7,-0.5,'1990s','fontsize',10);
text(2.0,-0.5,'2000s','fontsize',10);
text(1.75,5.3,'a','fontsize',10);
text(2.05,7.5,'b','fontsize',10);
line([1.5 1.5],[0 10],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
ylim([0 10]);
set(gca,'linewidth',0.5,'fontsize',10);
%
axes('position',[0.15 0.08 0.78 0.4],'linewidth',0.8,'box','on')
barweb(dp(4:5,1:2),dp(4:5,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylim([0 12]);
ylabel('RT for NDII (year)');
text(0.7,-0.6,'1980s','fontsize',10);
text(1.0,-0.6,'1990s','fontsize',10);
text(0.75,8.5,'a','fontsize',10);
text(1.05,8.5,'a','fontsize',10);

text(1.7,-0.6,'1990s','fontsize',10);
text(2.0,-0.6,'2000s','fontsize',10);
text(1.75,6,'a','fontsize',10);
text(2.05,9.5,'b','fontsize',10);
line([1.5 1.5],[0 12],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig2_2');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig2_2');

%% 热带
load('E:\科研\森林恢复\data\data2.mat');
dat=nan(7,18);dp=nan(6,3);

lie=[5 23 41 6 24 42;14 32 50 15 33 51];
ll=[5 23 41 5 23 41;14 32 50 14 32 50];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
lon=cell2mat(data2(2:end,ll(1,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(1,j)-3));lat=lat(~isnan(lat));
x1=x1(lat>=-23.5&lat<=23.5);

x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));
lon=cell2mat(data2(2:end,ll(2,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(2,j)-3));lat=lat(~isnan(lat));
x2=x2(lat>=-23.5&lat<=23.5);

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
dp(j,6)=std(x11)/length(x11)^0.5;
dp(j,7)=std(x22)/length(x22)^0.5;
end

%% Figure 2-3
cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
set(gcf,'paperpositionmode','auto','position',[10 20  350 600]);
axes('position',[0.15 0.55 0.78 0.4],'linewidth',0.8,'box','on')
barweb(dp(2,1:2),dp(2,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylabel('RT for NDVI (year)');
text(0.75,-0.3,'1990s','fontsize',10);
text(1.05,-0.3,'2000s','fontsize',10);
text(0.75,3.2,'a','fontsize',10);
text(1.05,5,'a','fontsize',10);

line([1.5 1.5],[0 10],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
ylim([0 6]);
set(gca,'linewidth',0.5,'fontsize',10);
%
axes('position',[0.15 0.08 0.78 0.4],'linewidth',0.8,'box','on')
barweb(dp(5,1:2),dp(5,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylim([0 8]);
%
ylabel('RT for NDII (year)');
text(0.75,-0.4,'1990s','fontsize',10);
text(1.05,-0.4,'2000s','fontsize',10);
text(0.75,6,'a','fontsize',10);
text(1.05,7,'a','fontsize',10);
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig2_3');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig2_3');

%% Figure 2-4 相同温度降水下不同年代的比较
load('E:\科研\森林恢复\data\data2.mat');
lie=[5 23 6 24;14 32 15 33];
tx={'a','b','c','d'};
set(gcf,'paperpositionmode','auto','position',[10 20  750 700]);
py=[0.6 0.6 0.18 0.18];px=[0.15 0.6 0.15 0.6];
for j=1:4
xk1=cell2mat(data2(2:end,lie(1,j)));xk1=xk1(~isnan(xk1));
xk2=cell2mat(data2(2:end,lie(2,j)));xk2=xk2(~isnan(xk2));
if j<3
mat=cell2mat(data2(2:end,lie(1,j)+3));mat=mat(~isnan(mat));
map=cell2mat(data2(2:end,lie(1,j)+2));map=map(~isnan(map));

mat2=cell2mat(data2(2:end,lie(2,j)+3));mat2=mat2(~isnan(mat2));
map2=cell2mat(data2(2:end,lie(2,j)+2));map2=map2(~isnan(map2));
else
mat=cell2mat(data2(2:end,lie(1,j)+2));mat=mat(~isnan(mat));
map=cell2mat(data2(2:end,lie(1,j)+1));map=map(~isnan(map));

mat2=cell2mat(data2(2:end,lie(2,j)+2));mat2=mat2(~isnan(mat2));
map2=cell2mat(data2(2:end,lie(2,j)+1));map2=map2(~isnan(map2));
end

%
dat_cli1=nan(17,19);
dat_num=nan(17,19);

YY=xk1;
pre=map;
temp=mat;
pre=pre(YY<100);
temp=temp(YY<100);
YY=YY(YY<100);
for i=1:16
    for tt=1:18
        yy2=YY(pre>=-200+tt*200&pre<tt*200&temp>=-6+2*i&temp<-4+2*i);
        dat_cli1(i,tt)=mean(yy2);
        dat_num(i,tt)=length(yy2);
    end
end

dat_cli2=nan(17,19);
dat_num=nan(17,19);

YY=xk2;
pre=map2;
temp=mat2;
pre=pre(YY<100);
temp=temp(YY<100);
YY=YY(YY<100);
for i=1:16
    for tt=1:18
        yy2=YY(pre>=-200+tt*200&pre<tt*200&temp>=-6+2*i&temp<-4+2*i);
        dat_cli2(i,tt)=mean(yy2);
        dat_num(i,tt)=length(yy2);
    end
end

axes('position',[px(j) py(j) 0.34 0.35],'linewidth',0.8,'box','on')
dat_cli=(dat_cli2-dat_cli1)';
pcolor(dat_cli)
cm=cbrewer('div','RdYlGn',11,'Cubic');
cm2=cm(11:-2:1,:);
colormap(cm2)
caxis([-6 6]);
%
set(gca,'xtick',1:2:17,'xticklabel',-4:4:28);
xlabel('MAT (^{o}C)');
set(gca,'ytick',1:2:20,'yticklabel',0:400:3600);
ylabel('MAP (mm year^{-1})');
set(gca,'fontsize',10,'linewidth',0.5);
text(-2.2,19.2,tx(j),'fontsize',12,'fontweight','b');
end

h1=colorbar('SouthOutside');
set(h1,'Position',[.35 0.08 0.4 0.03]);
ylabel(h1,'Difference in RT between decades (year)','fontsize',10,'position',[0 -0.8]);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig2_4');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig2_4');

%% Fig. 2_5
load('E:\科研\森林恢复\data\data2.mat');
dat=nan(7,18);dp=nan(6,3);

lie=[5 23 41 6 24 42;14 32 50 15 33 51];
ll=[5 23 41 5 23 41;14 32 50 14 32 50];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
lon=cell2mat(data2(2:end,ll(1,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(1,j)-3));lat=lat(~isnan(lat));
x1=x1(lon>=-167&lon<=-20&lat>=10&lat<=81);

x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));
lon=cell2mat(data2(2:end,ll(2,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(2,j)-3));lat=lat(~isnan(lat));
x2=x2(lon>=-167&lon<=-20&lat>=10&lat<=81);

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
%p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
%dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
dp(j,6)=std(x11)/length(x11)^0.5;
dp(j,7)=std(x22)/length(x22)^0.5;
end

cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
set(gcf,'paperpositionmode','auto','position',[10 20  800 700]);
axes('position',[0.08 0.55 0.38 0.4],'linewidth',0.8,'box','on')
barweb(dp(1:2,1:2),dp(1:2,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylabel('RT for NDVI (year)');
text(0.75,-0.5,'1980s','fontsize',10);
text(1.05,-0.5,'1990s','fontsize',10);
text(0.75,7.5,'a','fontsize',10);
text(1.05,7.5,'a','fontsize',10);

text(1.75,-0.5,'1990s','fontsize',10);
text(2.05,-0.5,'2000s','fontsize',10);
text(1.75,5.3,'a','fontsize',10);
text(2.05,7.5,'b','fontsize',10);
line([1.5 1.5],[0 10],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
ylim([0 10]);
text(0.3,10,'a','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
%
axes('position',[0.08 0.06 0.38 0.4],'linewidth',0.8,'box','on')
barweb(dp(4:5,1:2),dp(4:5,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylim([0 12]);
ylabel('RT for NDII (year)');
text(0.75,-0.6,'1980s','fontsize',10);
text(1.05,-0.6,'1990s','fontsize',10);
text(0.75,8.5,'a','fontsize',10);
text(1.05,8.5,'a','fontsize',10);

text(1.75,-0.6,'1990s','fontsize',10);
text(2.05,-0.6,'2000s','fontsize',10);
text(1.75,6,'a','fontsize',10);
text(2.05,9.5,'b','fontsize',10);
line([1.5 1.5],[0 12],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.3,12,'c','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);

load('E:\科研\森林恢复\data\data2.mat');
dat=nan(7,18);dp=nan(6,3);

lie=[5 23 41 6 24 42;14 32 50 15 33 51];
ll=[5 23 41 5 23 41;14 32 50 14 32 50];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
lon=cell2mat(data2(2:end,ll(1,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(1,j)-3));lat=lat(~isnan(lat));
x1=x1(lat>=-23.5&lat<=23.5);

x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));
lon=cell2mat(data2(2:end,ll(2,j)-4));lon=lon(~isnan(lon));
lat=cell2mat(data2(2:end,ll(2,j)-3));lat=lat(~isnan(lat));
x2=x2(lat>=-23.5&lat<=23.5);

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
%p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
%dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
dp(j,6)=std(x11)/length(x11)^0.5;
dp(j,7)=std(x22)/length(x22)^0.5;
end

cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
axes('position',[0.56 0.55 0.38 0.4],'linewidth',0.8,'box','on')
barweb(dp(2,1:2),dp(2,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylabel('RT for NDVI (year)');
text(0.8,-0.3,'1990s','fontsize',10);
text(1.1,-0.3,'2000s','fontsize',10);
text(0.75,3.2,'a','fontsize',10);
text(1.05,5,'a','fontsize',10);

line([1.5 1.5],[0 10],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
ylim([0 6]);
text(0.38,6,'b','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
%
axes('position',[0.56 0.06 0.38 0.4],'linewidth',0.8,'box','on')
barweb(dp(5,1:2),dp(5,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylim([0 8]);
%
ylabel('RT for NDII (year)');
text(0.8,-0.4,'1990s','fontsize',10);
text(1.1,-0.4,'2000s','fontsize',10);
text(0.75,6,'a','fontsize',10);
text(1.05,7,'a','fontsize',10);
text(0.38,8,'d','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig2_5');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig2_5');

%% Figure 3 影响植被恢复的因素：重新拟合 添加置信区间
[~,~,input]=xlsread('E:\科研\森林恢复\ML_python\data_NDVI.csv');
[~,~,result]=xlsread('E:\科研\森林恢复\ML_python\resul_NDVI.csv');

k1=cellstr(result(1,2:end));
k2=k1;
sh_v=nan(1,22);
for i=1:22
    yy=cell2mat(result(2:end,i+1));
    yy=abs(yy);
    sh_v(i)=mean(yy);
end
sh_v2=sort(sh_v,'descend');

for i=1:22
    for j=1:22
        if sh_v2(i)==sh_v(j)
            k2(i)=k1(j);
        end
    end
end
%
set(gcf,'paperpositionmode','auto','position',[10 20  1200 900]);
col=[200 80 90;120 180 220;80 180 125;254 160 150;190 190 190]/255;
cl2=[1 2 2 5 2 3 4 4 3 3 5 4 2 4 3 5 3 3 4 3 4 4];
axes('position',[0.12 0.56 0.2 0.4],'linewidth',0.8,'box','on')
tt={'Mortality severity','T in RT','MAT','Elevation','P in RT','SLA','Soil pH','Soil Sand','Forest age','LNC','Aspect'...
    'AWC','MAP','STN','Forest Height','Slope','Root depth','LPC','CEC','Tree density','Soil Clay','Soil bulk density'};
for i=1:22
    cc=cl2(23-i);
    barh(i,sh_v2(23-i),'facecolor',col(cc,:),'edgecolor','none');hold on
    kl=strlength(cellstr(tt(i)));
    if kl<4
        k2=kl*-0.003;
    elseif kl<8
        k2=kl*-0.002;
    elseif kl<14
        k2=kl*-0.002;
    else
        k2=kl*-0.0018;
    end
    text(k2-0.002,23-i,cellstr(tt(i)),'fontsize',10);
    set(gca,'ytick',[]);
end
xlabel('Mean (|SHAP| value)');
text(-0.03,23.3,'a','fontsize',12,'fontweight','b')
rectangle('position',[0.04 5 0.01 0.8],'facecolor',col(1,:),'edgecolor','none');
text(0.052,5.4,'Mortality','fontsize',10);

rectangle('position',[0.04 4 0.01 0.8],'facecolor',col(2,:),'edgecolor','none');
text(0.052,4.4,'Climate','fontsize',10);

rectangle('position',[0.04 3 0.01 0.8],'facecolor',col(3,:),'edgecolor','none');
text(0.052,3.4,'Vegetation','fontsize',10);

rectangle('position',[0.04 2 0.01 0.8],'facecolor',col(4,:),'edgecolor','none');
text(0.052,2.4,'Soil','fontsize',10);

rectangle('position',[0.04 1 0.01 0.8],'facecolor',col(5,:),'edgecolor','none');
text(0.052,1.4,'Topography','fontsize',10);
set(gca,'linewidth',0.5,'fontsize',10);

%
axes('position',[0.39 0.78 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,1));
yy=cell2mat(result(2:end,2));
plot(xx,yy,'.','markersize',8,'color',col(1,:));
xlabel('Mortality severity (%)');
ylabel('SHAP value');
text(-20,0.4,'b','fontsize',12,'fontweight','b')
line([0 100],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
set(gca,'linewidth',0.5,'fontsize',10);hold on

xx2=0:0.1:80;
%yy2=2.376e-06*xx2.*xx2.*xx2-0.0003948*xx2.*xx2+0.0219*xx2-0.2892;
%plot(xx2,yy2,'-','linewidth',1.5,'color',[0.38 0.38 0.38]);hold on
%
X=[xx xx.*xx xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2;xx2.*xx2;xx2.*xx2.*xx2]';
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [.8 .5 .5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
 saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
axes('position',[0.6 0.78 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,9));
yy=cell2mat(result(2:end,6));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('T in RT (^{o}C)');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([-4 6],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-6,0.3,'c','fontsize',12,'fontweight','b')
set(gca,'ytick',-0.3:0.1:0.3);
ylim([-0.3 0.3])
xlim([-4 6])
set(gca,'linewidth',0.5,'fontsize',10);hold on
xx2=-1:0.1:3;
%yy2=-0.0001525*k.*k.*k.*k.*k.*k.*k.*k+ 0.001993*k.*k.*k.*k.*k.*k.*k-0.005823*k.*k.*k.*k.*k.*k-0.01728*k.*k.*k.*k.*k+0.08637*k.*k.*k.*k+0.009637*k.*k.*k-0.2664*k.*k+0.1017*k+0.03342;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [.8 .5 .5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
 
%
axes('position',[0.81 0.78 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,3));
yy=cell2mat(result(2:end,4));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('MAT (^{o}C)');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([-10 30],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-18,0.3,'d','fontsize',12,'fontweight','b')
set(gca,'ytick',-0.3:0.1:0.3);
ylim([-0.3 0.3])
xlim([-10 30])
set(gca,'linewidth',0.5,'fontsize',10);

hold on
xx2=-2:0.1:25;
%yy2=-0.000969*k.*k+0.01627*k+-0.01356;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)

%
axes('position',[0.39 0.55 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,28));
yy=cell2mat(result(2:end,21));
plot(xx,yy,'.','markersize',8,'color',col(5,:));
xlabel('Elevation (m)');
ylabel('SHAP value');
text(-800,0.2,'e','fontsize',12,'fontweight','b')
line([0 4000],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
ylim([-0.2 0.2])
xlim([0 4000])
set(gca,'linewidth',0.5,'fontsize',10);
hold on
xx2=0:1:3500;
%yy2=-1.961e-11*k.*k.*k+3.985e-08*k.*k+7.967e-05*k-0.07073;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
axes('position',[0.6 0.55 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,8));
yy=cell2mat(result(2:end,5));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('P in RT (%)');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([-0.5 0.8],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-0.62,0.4,'f','fontsize',12,'fontweight','b')
ylim([-0.4 0.4])
set(gca,'linewidth',0.5,'fontsize',10);
xlim([-0.4 0.8]);
set(gca,'xtick',-0.4:0.2:0.8,'xticklabel',-40:20:80);
hold on
xx2=-0.4:0.01:0.6;
%yy2=14.3*k.*k.*k.*k.*k.*k-20.21*k.*k.*k.*k.*k+ 7.209*k.*k.*k.*k+3.275 *k.*k.*k-2.657*k.*k-0.1819*k+0.03915;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [.8 .5 .5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
axes('position',[0.81 0.55 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,23));
yy=cell2mat(result(2:end,18));
plot(xx,yy,'.','markersize',8,'color',col(3,:));
xlabel('SLA (cm^{2} g^{-1})');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([5 25],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(1,0.3,'g','fontsize',12,'fontweight','b')
ylim([-0.3 0.3])
xlim([5 25])
set(gca,'ytick',-0.3:0.1:0.3);
set(gca,'linewidth',0.5,'fontsize',10);
hold on
xx2=6:0.1:20;
%yy2=3.28e-06*k.*k.*k-0.002464 *k.*k+0.04673 *k-0.2072 ;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
clear
[~,~,input]=xlsread('E:\科研\森林恢复\ML_python\data_NDII.csv');
[~,~,result]=xlsread('E:\科研\森林恢复\ML_python\resul_NDII.csv');

k1=cellstr(result(1,2:end));
k2=k1;
sh_v=nan(1,22);
for i=1:22
    yy=cell2mat(result(2:end,i+1));
    yy=abs(yy);
    sh_v(i)=mean(yy);
end
sh_v2=sort(sh_v,'descend');

for i=1:22
    for j=1:22
        if sh_v2(i)==sh_v(j)
            k2(i)=k1(j);
        end
    end
end
%
set(gcf,'paperpositionmode','auto','position',[10 20  1200 900]);
col=[200 80 90;120 180 220;80 180 125;254 160 150;190 190 190]/255;
cl2=[2 2 2 1 2 3 3 5 5 4 3 3 3 4 4 4 5 4 3 4 3 4];
axes('position',[0.12 0.06 0.2 0.4],'linewidth',0.8,'box','on')
tt={'MAT','P in RT','T in RT','Mortality severity','MAP','Tree density','SLA','Elevation','Slope','STN','Forest age',...
    'Forest Height','LPC','AWC','Soil pH','CEC','Aspect','Soil bulk density','LNC','Soil sand','Root depth','Soil Clay'};
for i=1:22
    cc=cl2(23-i);
    barh(i,sh_v2(23-i),'facecolor',col(cc,:),'edgecolor','none');hold on
    kl=strlength(cellstr(tt(i)));
    if kl<4
        k2=kl*-0.0028*1.5;
    elseif kl<8
        k2=kl*-0.0021*1.5;
    elseif kl<14
        k2=kl*-0.00205*1.5;
    else
        k2=kl*-0.00185*1.5;
    end
    text(k2-0.002,23-i,cellstr(tt(i)),'fontsize',10);
    set(gca,'ytick',[]);
end
xlabel('Mean (|SHAP| value)');
text(-0.03*1.5,23.3,'h','fontsize',12,'fontweight','b')
rectangle('position',[0.04*1.5 5 0.015 0.8],'facecolor',col(1,:),'edgecolor','none');
text(0.052*1.5,5.4,'Mortality','fontsize',10);

rectangle('position',[0.04*1.5 4 0.015 0.8],'facecolor',col(2,:),'edgecolor','none');
text(0.052*1.5,4.4,'Climate','fontsize',10);

rectangle('position',[0.04*1.5 3 0.015 0.8],'facecolor',col(3,:),'edgecolor','none');
text(0.052*1.5,3.4,'Vegetation','fontsize',10);

rectangle('position',[0.04*1.5 2 0.015 0.8],'facecolor',col(4,:),'edgecolor','none');
text(0.052*1.5,2.4,'Soil','fontsize',10);

rectangle('position',[0.04*1.5 1 0.015 0.8],'facecolor',col(5,:),'edgecolor','none');
text(0.052*1.5,1.4,'Topography','fontsize',10);
xlim([0 0.12])
set(gca,'xtick',0:0.02:0.12);
set(gca,'linewidth',0.5,'fontsize',10);
%
%
axes('position',[0.39 0.28 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,3));
yy=cell2mat(result(2:end,4));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('MAT (^{o}C)');
ylabel('SHAP value');
ylim([-0.6 0.6])
xlim([-10 30])
text(-18,0.6,'i','fontsize',12,'fontweight','b')
line([-10 30],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
set(gca,'ytick',-0.6:0.2:0.6);
set(gca,'linewidth',0.5,'fontsize',10);

hold on
xx2=-2:0.1:26;
%yy2=-1.962e-05*k.*k.*k-0.0009064 *k.*k+0.0177 *k+0.03784 ;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
 saveLearnerForCoder(mdl,'QLMMdl');
 [~,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)

%
axes('position',[0.6 0.28 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,8));
yy=cell2mat(result(2:end,5));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('P in RT (%)');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([-0.4 0.8],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-0.64,0.6,'j','fontsize',12,'fontweight','b')
set(gca,'ytick',-0.6:0.2:0.6);
ylim([-0.6 0.6])
xlim([-0.4 0.8])
set(gca,'xtick',-0.4:0.2:0.8,'xticklabel',-40:20:80);
set(gca,'linewidth',0.5,'fontsize',10);

hold on
xx2=-0.35:0.01:0.6;
%yy2=68.84*k.*k.*k.*k.*k.*k-81.13*k.*k.*k.*k.*k+18.67*k.*k.*k.*k+8.592*k.*k.*k-5.265*k.*k-0.1861*k+0.05945;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [.8 .5 .5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
 saveLearnerForCoder(mdl,'QLMMdl');
 [yhat2,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
axes('position',[0.81 0.28 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,9));
yy=cell2mat(result(2:end,6));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('T in RT (^{o}C)');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([-4 6],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-6,0.4,'k','fontsize',12,'fontweight','b')
set(gca,'ytick',-0.4:0.1:0.4);
ylim([-0.4 0.4])
xlim([-4 6])
set(gca,'linewidth',0.5,'fontsize',10);

hold on
xx2=-1:0.01:3;
%yy2=0.003513*k.*k.*k.*k.*k.*k-0.03207*k.*k.*k.*k.*k+0.06977*k.*k.*k.*k+0.08078*k.*k.*k-0.3323*k.*k+0.1489*k+0.0138;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [.8 .5 .5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
   saveLearnerForCoder(mdl,'QLMMdl');
 [yhat2,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
axes('position',[0.39 0.05 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,1));
yy=cell2mat(result(2:end,2));
plot(xx,yy,'.','markersize',8,'color',col(1,:));
xlabel('Mortality severity (%)');
ylabel('SHAP value');
text(-20,0.2,'l','fontsize',12,'fontweight','b')
line([0 100],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
ylim([-0.2 0.2])
xlim([0 100])
set(gca,'linewidth',0.5,'fontsize',10);

hold on
xx2=0:100;
%yy2=7.646e-08 *k.*k.*k -3.949e-05*k.*k+0.00397 *k-0.07534 ;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);
X=[xx xx.*xx xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [yhat2,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%

axes('position',[0.6 0.05 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,2));
yy=cell2mat(result(2:end,3));
plot(xx,yy,'.','markersize',8,'color',col(2,:));
xlabel('MAP (mm year^{-1})');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([0 4000],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-840,0.2,'m','fontsize',12,'fontweight','b')
ylim([-0.2 0.2])
xlim([0 4000]);
set(gca,'linewidth',0.5,'fontsize',10);

hold on
xx2=200:3000;
%yy2=0*k.*k.*k+2.083e-08*k.*k-4.256e-05*k+0.01465;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);

X=[xx xx.*xx xx.*xx.*xx xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx xx.*xx.*xx.*xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2' xx2'.*xx2'.*xx2'.*xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 
  saveLearnerForCoder(mdl,'QLMMdl');
 [yhat2,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)
%
axes('position',[0.81 0.05 0.15 0.18],'linewidth',0.8,'box','on')
xx=cell2mat(input(2:end,19))/10^5;
yy=cell2mat(result(2:end,14));
plot(xx,yy,'.','markersize',8,'color',col(3,:));
xlabel('Tree density (10^5 km^{-2})');
ylabel('SHAP value');
set(gca,'linewidth',0.5,'fontsize',10);
line([0 3],[0 0],'linestyle','--','linewidth',0.6,'color',[0.6 0.6 0.6]);
text(-0.6,0.1,'n','fontsize',12,'fontweight','b')
ylim([-0.1 0.1])
xlim([0 3])
set(gca,'ytick',-0.3:0.1:0.3);
set(gca,'linewidth',0.5,'fontsize',10);
%
hold on
xx2=0:0.1:3;
%yy2=0.01072*k.*k.*k-0.05594 *k.*k+0.0974*k-0.02601 ;
%plot(k,yy2,'-','linewidth',1.5,'color',[0.38 .38 .38]);
X=[xx xx.*xx xx.*xx.*xx];
mdl=fitlm(X,yy); 
K=[xx2' xx2'.*xx2' xx2'.*xx2'.*xx2'];
[ypk,yp2]=predict(mdl, K, 'alpha', 0.05);
yp1=yp2(:,1);
yp2=yp2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 p = fill(xconf,yconf,'red');%定义填充区间
 p.FaceColor = [0.8 0.5 0.5];%定义区间的填充颜色      
 p.EdgeColor = 'none';hold on
 plot(xx2,ypk,'-','linewidth',1,'color',[0.38 0.38 0.38]);hold on
 %
 saveLearnerForCoder(mdl,'QLMMdl');
 [yhat2,ci2] = mypredictQLM_mex(K,'Alpha',0.05,'Simultaneous',true);
 yp1=ci2(:,1);
yp2=ci2(:,2);
xconf = [xx2 xx2(end:-1:1)] ;%构造正反向的x值，作为置信区间的横坐标值
 yconf = [yp1' yp2(end:-1:1)'];
 pp = fill(xconf,yconf,'red');%定义填充区间
 pp.FaceColor = [0.5 0.5 0.5];%定义区间的填充颜色      
 pp.EdgeColor = 'none';hold on
 alpha(pp,0.3)

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig3');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig3');

%% Figure 4 RT_T P 的变化
[~,~,data3]=xlsread('E:\科研\森林恢复\data\数据准备\Global-RT-NDVI-NDII3.xls');

xx=cell2mat(data3(2:end,21))-cell2mat(data3(2:end,12));%global
yy=cell2mat(data3(2:end,21))-cell2mat(data3(2:end,12)); %for Europe
yea=cellstr(data3(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

lon=cell2mat(data3(2:end,1));
lat=cell2mat(data3(2:end,2));
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

yy=yy(lon>=-9&lon<=66&lat>=36&lat<=71);
yea2=yea(lon>=-9&lon<=66&lat>=36&lat<=71);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats); % a a b %global

%[p,tb,stats]=anova1(yy,yea2);
%[c,~,~,f1] = multcompare(stats); % a a b %Europe

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea2,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
    dat(i,6)=length(yy2);
end

set(gcf,'paperpositionmode','auto','position',[10 20  750 380]);
axes('position',[0.08 0.15 0.4 0.75],'linewidth',0.8,'box','on') 
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('T in RT (^{o}C)');
text(0.65,-.6,'1980s','fontsize',10);
text(0.91,-.6,'1990s','fontsize',10);
text(1.17,-.6,'2000s','fontsize',10);

text(0.7,.1,'a','fontsize',10);
text(0.9,.2,'a','fontsize',10);
text(1.15,.4,'b','fontsize',10);

text(1.65,-.6,'1980s','fontsize',10);
text(1.91,-.6,'1990s','fontsize',10);
text(2.17,-.6,'2000s','fontsize',10);

text(1.7,.1,'a','fontsize',10);
text(1.9,.1,'a','fontsize',10);
text(2.15,.9,'b','fontsize',10);
ylim([-.5 1.5]);
line([1.5 1.5],[-0.5 1.5],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,1.42,'Global','fontsize',10);
text(1.65,1.42,'Europe','fontsize',10);
text(0.28,1.54,'a','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);

xx=(cell2mat(data3(2:end,23))-cell2mat(data3(2:end,10)))./cell2mat(data3(2:end,10));%global
yy=(cell2mat(data3(2:end,23))-cell2mat(data3(2:end,10)))./cell2mat(data3(2:end,10)); %for Europe
yea=cellstr(data3(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

lon=cell2mat(data3(2:end,1));
lat=cell2mat(data3(2:end,2));
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

yy=yy(lon>=-9&lon<=66&lat>=36&lat<=71);
yea2=yea(lon>=-9&lon<=66&lat>=36&lat<=71);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats); % a b a %global

%[p,tb,stats]=anova1(yy,yea2);
%[c,~,~,f1] = multcompare(stats); % a b c %Europe

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea2,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
    dat(i,6)=length(yy2);
end

axes('position',[0.56 0.15 0.4 0.75],'linewidth',0.8,'box','on') 
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('P in RT (%)');
text(0.65,-.22,'1980s','fontsize',10);
text(0.91,-.22,'1990s','fontsize',10);
text(1.17,-.22,'2000s','fontsize',10);

text(0.7,.01,'a','fontsize',10);
text(0.9,.12,'b','fontsize',10);
text(1.15,.01,'a','fontsize',10);

text(1.65,-.22,'1980s','fontsize',10);
text(1.91,-.22,'1990s','fontsize',10);
text(2.17,-.22,'2000s','fontsize',10);

text(1.7,.01,'a','fontsize',10);
text(1.9,.1,'b','fontsize',10);
text(2.15,.03,'c','fontsize',10);
ylim([-.2 0.2]);
line([1.5 1.5],[-0.5 1.5],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,0.184,'Global','fontsize',10);
text(1.65,0.184,'Europe','fontsize',10);
text(0.28,0.208,'b','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22],'xticklabel','','ytick',-0.2:0.1:0.4,'yticklabel',-20:10:40);
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig4');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig4');

%% Figure 4-1 死亡严重程度的变化
load('E:\科研\森林恢复\data\data.mat');
xx=cell2mat(data(2:end,9));
yy=cell2mat(data(2:end,10));
yea=cellstr(data(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

%[p,tb,stats]=anova1(yy,yea);
%[c,~,~,f1] = multcompare(stats);

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
end


set(gcf,'paperpositionmode','auto','position',[10 20  750 380]);
axes('position',[0.08 0.15 0.4 0.75],'linewidth',0.8,'box','on') 
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('Decrease in index during mortality events (%)');
text(0.65,-3.5,'1980s','fontsize',10);
text(0.91,-3.5,'1990s','fontsize',10);
text(1.17,-3.5,'2000s','fontsize',10);

text(0.7,26,'a','fontsize',10);
text(0.9,26,'a','fontsize',10);
text(1.15,26,'a','fontsize',10);

text(1.65,-3.5,'1980s','fontsize',10);
text(1.91,-3.5,'1990s','fontsize',10);
text(2.17,-3.5,'2000s','fontsize',10);

text(1.7,32,'a','fontsize',10);
text(1.9,46.4,'b','fontsize',10);
text(2.15,45,'b','fontsize',10);
ylim([0 70]);
line([1.5 1.5],[0 70],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,67,'NDVI','fontsize',10);
text(1.65,67,'NDII','fontsize',10);
text(0.32,74,'a','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);
set(gca,'linewidth',0.5,'fontsize',10);
%
xx=cell2mat(data(2:end,9));
yy=cell2mat(data(2:end,10));
yea=cellstr(data(2:end,4));
lon=cell2mat(data(2:end,1));
lat=cell2mat(data(2:end,2));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

xx=xx(lon>=-9&lon<=66&lat>=36&lat<=71);
yy=yy(lon>=-9&lon<=66&lat>=36&lat<=71);
yea=yea(lon>=-9&lon<=66&lat>=36&lat<=71);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats);

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
end

axes('position',[0.56 0.15 0.4 0.75],'linewidth',0.8,'box','on') 
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('Decrease in index during mortality events (%)');
text(0.65,-3.5,'1980s','fontsize',10);
text(0.91,-3.5,'1990s','fontsize',10);
text(1.17,-3.5,'2000s','fontsize',10);

text(0.7,38,'a','fontsize',10);
text(0.95,22,'b','fontsize',10);
text(1.16,22,'b','fontsize',10);

text(1.65,-3.5,'1980s','fontsize',10);
text(1.91,-3.5,'1990s','fontsize',10);
text(2.17,-3.5,'2000s','fontsize',10);

text(1.7,38,'a','fontsize',10);
text(1.93,25,'a','fontsize',10);
text(2.15,34,'a','fontsize',10);
ylim([0 70]);
line([1.5 1.5],[0 70],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,67,'NDVI','fontsize',10);
text(1.65,67,'NDII','fontsize',10);
text(0.32,74,'b','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig4_1');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig4_1');

%% Fig. 4_2 mortality severity
load('E:\科研\森林恢复\data\data.mat');
xx=cell2mat(data(2:end,9));
yy=cell2mat(data(2:end,10));
yea=cellstr(data(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

%[p,tb,stats]=anova1(yy,yea);
%[c,~,~,f1] = multcompare(stats);

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
end


set(gcf,'paperpositionmode','auto','position',[10 20  800 700]);
axes('position',[0.08 0.55 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('Decrease in index during mortality events (%)');
text(0.65,-3.5,'1980s','fontsize',10);
text(0.91,-3.5,'1990s','fontsize',10);
text(1.17,-3.5,'2000s','fontsize',10);

text(0.7,26,'a','fontsize',10);
text(0.9,26,'a','fontsize',10);
text(1.15,26,'a','fontsize',10);

text(1.65,-3.5,'1980s','fontsize',10);
text(1.91,-3.5,'1990s','fontsize',10);
text(2.17,-3.5,'2000s','fontsize',10);

text(1.7,32,'a','fontsize',10);
text(1.9,46.4,'b','fontsize',10);
text(2.15,45,'b','fontsize',10);
ylim([0 70]);
line([1.5 1.5],[0 70],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,67,'NDVI','fontsize',10);
text(1.65,67,'NDII','fontsize',10);
text(0.32,74,'a','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);
set(gca,'linewidth',0.5,'fontsize',10);
%
xx=cell2mat(data(2:end,9));
yy=cell2mat(data(2:end,10));
yea=cellstr(data(2:end,4));
lon=cell2mat(data(2:end,1));
lat=cell2mat(data(2:end,2));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

xx=xx(lon>=-9&lon<=66&lat>=36&lat<=71);
yy=yy(lon>=-9&lon<=66&lat>=36&lat<=71);
yea=yea(lon>=-9&lon<=66&lat>=36&lat<=71);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats);

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
end

axes('position',[0.54 0.55 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('Decrease in index during mortality events (%)');
text(0.65,-3.5,'1980s','fontsize',10);
text(0.91,-3.5,'1990s','fontsize',10);
text(1.17,-3.5,'2000s','fontsize',10);

text(0.7,38,'a','fontsize',10);
text(0.95,22,'b','fontsize',10);
text(1.16,22,'b','fontsize',10);

text(1.65,-3.5,'1980s','fontsize',10);
text(1.91,-3.5,'1990s','fontsize',10);
text(2.17,-3.5,'2000s','fontsize',10);

text(1.7,38,'a','fontsize',10);
text(1.93,25,'a','fontsize',10);
text(2.15,34,'a','fontsize',10);
ylim([0 70]);
line([1.5 1.5],[0 70],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,67,'NDVI','fontsize',10);
text(1.65,67,'NDII','fontsize',10);
text(0.32,74,'b','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);
set(gca,'linewidth',0.5,'fontsize',10);

%
xx=cell2mat(data(2:end,9));
yy=cell2mat(data(2:end,10));
yea=cellstr(data(2:end,4));
lon=cell2mat(data(2:end,1));
lat=cell2mat(data(2:end,2));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

xx=xx(lon>=-167&lon<=-20&lat>=10&lat<=81);
yy=yy(lon>=-167&lon<=-20&lat>=10&lat<=81);
yea=yea(lon>=-167&lon<=-20&lat>=10&lat<=81);

%[p,tb,stats]=anova1(yy,yea);
%[c,~,~,f1] = multcompare(stats);

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
end

axes('position',[0.08 0.06 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('Decrease in index during mortality events (%)');
text(0.65,-3.5,'1980s','fontsize',10);
text(0.91,-3.5,'1990s','fontsize',10);
text(1.17,-3.5,'2000s','fontsize',10);

text(0.7,20,'a','fontsize',10);
text(0.95,27,'a','fontsize',10);
text(1.16,27,'a','fontsize',10);

text(1.65,-3.5,'1980s','fontsize',10);
text(1.91,-3.5,'1990s','fontsize',10);
text(2.17,-3.5,'2000s','fontsize',10);

text(1.7,25,'a','fontsize',10);
text(1.93,55,'b','fontsize',10);
text(2.15,43,'a','fontsize',10);
ylim([0 70]);
line([1.5 1.5],[0 70],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,67,'NDVI','fontsize',10);
text(1.65,67,'NDII','fontsize',10);
text(0.32,74,'c','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);
set(gca,'linewidth',0.5,'fontsize',10);

%
xx=cell2mat(data(2:end,9));
yy=cell2mat(data(2:end,10));
yea=cellstr(data(2:end,4));
lon=cell2mat(data(2:end,1));
lat=cell2mat(data(2:end,2));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

xx=xx(lat>=-23.5&lat<=23.5);
yy=yy(lat>=-23.5&lat<=23.5);
yea=yea(lat>=-23.5&lat<=23.5);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats);

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
end

%%
axes('position',[0.54 0.06 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(2:3,[1 4])',dat(2:3,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('Decrease in index during mortality events (%)');
text(0.78,-3.5,'1990s','fontsize',10);
text(1.08,-3.5,'2000s','fontsize',10);

text(0.75,20,'a','fontsize',10);
text(1,30,'a','fontsize',10);

text(1.78,-3.5,'1990s','fontsize',10);
text(2.08,-3.5,'2000s','fontsize',10);

text(1.75,30,'a','fontsize',10);
text(2,45,'a','fontsize',10);
ylim([0 70]);
line([1.5 1.5],[0 70],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,67,'NDVI','fontsize',10);
text(1.65,67,'NDII','fontsize',10);
text(0.32,74,'d','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.85 1.15 1.85 2.15]);
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig4_2');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig4_2');

%% Fig. 4_3 T P in RT
[~,~,data3]=xlsread('E:\科研\森林恢复\data\数据准备\Global-RT-NDVI-NDII3.xls');

xx=cell2mat(data3(2:end,21))-cell2mat(data3(2:end,12));%global
yy=cell2mat(data3(2:end,21))-cell2mat(data3(2:end,12)); %for Europe
yea=cellstr(data3(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

lon=cell2mat(data3(2:end,1));
lat=cell2mat(data3(2:end,2));
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

yy=yy(lon>=-9&lon<=66&lat>=36&lat<=71);
yea2=yea(lon>=-9&lon<=66&lat>=36&lat<=71);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats); % a a b %global

%[p,tb,stats]=anova1(yy,yea2);
%[c,~,~,f1] = multcompare(stats); % a a b %Europe

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea2,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
    dat(i,6)=length(yy2);
end

set(gcf,'paperpositionmode','auto','position',[10 20  800 700]);
axes('position',[0.08 0.55 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('T in RT (^{o}C)');
text(0.67,-.6,'1980s','fontsize',10);
text(0.91,-.6,'1990s','fontsize',10);
text(1.15,-.6,'2000s','fontsize',10);

text(0.7,.1,'a','fontsize',10);
text(0.9,.2,'a','fontsize',10);
text(1.15,.4,'b','fontsize',10);

text(1.65,-.6,'1980s','fontsize',10);
text(1.91,-.6,'1990s','fontsize',10);
text(2.17,-.6,'2000s','fontsize',10);

text(1.7,.1,'a','fontsize',10);
text(1.9,.1,'a','fontsize',10);
text(2.15,.9,'b','fontsize',10);
ylim([-.5 1.5]);
line([1.5 1.5],[-0.5 1.5],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,1.42,'Global','fontsize',10);
text(1.65,1.42,'Europe','fontsize',10);
text(0.28,1.54,'a','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);

xx=(cell2mat(data3(2:end,23))-cell2mat(data3(2:end,10)))./cell2mat(data3(2:end,10));%global
yy=(cell2mat(data3(2:end,23))-cell2mat(data3(2:end,10)))./cell2mat(data3(2:end,10)); %for Europe
yea=cellstr(data3(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

lon=cell2mat(data3(2:end,1));
lat=cell2mat(data3(2:end,2));
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

yy=yy(lon>=-9&lon<=66&lat>=36&lat<=71);
yea2=yea(lon>=-9&lon<=66&lat>=36&lat<=71);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats); % a b a %global

%[p,tb,stats]=anova1(yy,yea2);
%[c,~,~,f1] = multcompare(stats); % a b c %Europe

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea2,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
    dat(i,6)=length(yy2);
end

axes('position',[0.08 0.06 0.38 0.4],'linewidth',0.8,'box','on') 
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('P in RT (%)');
text(0.65,-.22,'1980s','fontsize',10);
text(0.91,-.22,'1990s','fontsize',10);
text(1.17,-.22,'2000s','fontsize',10);

text(0.7,.01,'a','fontsize',10);
text(0.9,.12,'b','fontsize',10);
text(1.15,.01,'a','fontsize',10);

text(1.65,-.22,'1980s','fontsize',10);
text(1.91,-.22,'1990s','fontsize',10);
text(2.17,-.22,'2000s','fontsize',10);

text(1.7,.01,'a','fontsize',10);
text(1.9,.1,'b','fontsize',10);
text(2.15,.03,'c','fontsize',10);
ylim([-.2 0.2]);
line([1.5 1.5],[-0.5 1.5],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,0.184,'Global','fontsize',10);
text(1.65,0.184,'Europe','fontsize',10);
text(0.28,0.208,'c','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22],'xticklabel','','ytick',-0.2:0.1:0.4,'yticklabel',-20:10:40);
set(gca,'linewidth',0.5,'fontsize',10);

xx=cell2mat(data3(2:end,21))-cell2mat(data3(2:end,12));%global
yy=cell2mat(data3(2:end,21))-cell2mat(data3(2:end,12)); %for Europe
yea=cellstr(data3(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

lon=cell2mat(data3(2:end,1));
lat=cell2mat(data3(2:end,2));
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

yy=yy(lat>=-23.5&lat<=23.5);
yea2=yea(lat>=-23.5&lat<=23.5);

xx=xx(lon>=-167&lon<=-20&lat>=10&lat<=81);
yea=yea(lon>=-167&lon<=-20&lat>=10&lat<=81);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats); % a a a %NA

%[p,tb,stats]=anova1(yy,yea2);
%[c,~,~,f1] = multcompare(stats); % a a a % tropic

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea2,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
    dat(i,6)=length(yy2);
end
dat(1,4:5)=0;

axes('position',[0.56 0.55 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('T in RT (^{o}C)');
text(0.65,-.6,'1980s','fontsize',10);
text(0.91,-.6,'1990s','fontsize',10);
text(1.17,-.6,'2000s','fontsize',10);

text(0.7,.1,'a','fontsize',10);
text(0.9,.25,'a','fontsize',10);
text(1.15,.32,'a','fontsize',10);

%text(1.67,-.6,'1980s','fontsize',10);
text(1.91,-.6,'1990s','fontsize',10);
text(2.17,-.6,'2000s','fontsize',10);

%text(1.7,.1,'a','fontsize',10);
text(1.9,.22,'a','fontsize',10);
text(2.15,.55,'a','fontsize',10);
ylim([-.5 1.5]);
line([1.5 1.5],[-0.5 1.5],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,1.42,'North Americ','fontsize',10);
text(1.65,1.42,'Tropic','fontsize',10);
text(0.28,1.54,'b','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22]);
%
xx=(cell2mat(data3(2:end,23))-cell2mat(data3(2:end,10)))./cell2mat(data3(2:end,10));%global
yy=(cell2mat(data3(2:end,23))-cell2mat(data3(2:end,10)))./cell2mat(data3(2:end,10)); %for Europe
yea=cellstr(data3(2:end,4));
xx=xx(strcmp(yea,'2010s')==0);
yy=yy(strcmp(yea,'2010s')==0);
yea=yea(strcmp(yea,'2010s')==0);

lon=cell2mat(data3(2:end,1));
lat=cell2mat(data3(2:end,2));
lon=lon(strcmp(yea,'2010s')==0);
lat=lat(strcmp(yea,'2010s')==0);

yy=yy(lat>=-23.5&lat<=23.5);
yea2=yea(lat>=-23.5&lat<=23.5);

xx=xx(lon>=-167&lon<=-20&lat>=10&lat<=81);
yea=yea(lon>=-167&lon<=-20&lat>=10&lat<=81);

%[p,tb,stats]=anova1(xx,yea);
%[c,~,~,f1] = multcompare(stats); % a b a %NA

%[p,tb,stats]=anova1(yy,yea2);
%[c,~,~,f1] = multcompare(stats); % a a %Tropic

dec={'80s','90s','2000s'};
dat=nan(3,7);
for i=1:3
    xx2=xx(strcmp(yea,dec(i))==1);
    yy2=yy(strcmp(yea2,dec(i))==1);
    dat(i,1)=mean(xx2);
    dat(i,2)=std(xx2)/length(xx2)^0.5;
    dat(i,3)=length(xx2);
    dat(i,4)=mean(yy2);
    dat(i,5)=std(yy2)/length(yy2)^0.5;
    dat(i,6)=length(yy2);
end
dat(1,4:5)=0;

axes('position',[0.56 0.06 0.38 0.4],'linewidth',0.8,'box','on') 
cc=[0.1 0.3 0.3;0.3 0.3 0; 1 1 1];gpname={};
barweb(dat(:,[1 4])',dat(:,[2 5])',1,gpname,'','','',cc([1,2,3],:),'none','',2,'none');hold on
alpha(0.5)

ylabel('P in RT (%)');
text(0.65,-.22,'1980s','fontsize',10);
text(0.91,-.22,'1990s','fontsize',10);
text(1.17,-.22,'2000s','fontsize',10);

text(0.7,.01,'a','fontsize',10);
text(0.9,.15,'b','fontsize',10);
text(1.15,.01,'a','fontsize',10);

%text(1.67,-.22,'1980s','fontsize',10);
text(1.89,-.22,'1990s','fontsize',10);
text(2.15,-.22,'2000s','fontsize',10);

%text(1.7,.01,'a','fontsize',10);
text(1.9,.03,'a','fontsize',10);
text(2.15,.05,'a','fontsize',10);
ylim([-.2 0.2]);
line([1.5 1.5],[-0.5 1.5],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.65,0.184,'North America','fontsize',10);
text(1.65,0.184,'Troppic','fontsize',10);
text(0.28,0.208,'d','fontsize',12,'fontweight','b');
set(gca,'xtick',[0.78 1 1.22 1.78 2 2.22],'xticklabel','','ytick',-0.2:0.1:0.4,'yticklabel',-20:10:40);
set(gca,'linewidth',0.5,'fontsize',10);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig4_3');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig4_3');

%%
[~,~,data2]=xlsread('E:\科研\森林恢复\data\NDVI和NDII以及影响因素(5乘以5)\不同年代RT对比\RT对比(5-5).xlsx');
dat3=nan(7,18);dp=nan(6,3);

lie=[5 32 61 6 33 62;17 44 73 18 45 74];
ll=[5 23 41 5 23 41;17 44 73 18 45 74];

for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

for i=1:7
    dat3(i,3*j-2)=sum(xx1==i)/length(xx1);
    dat3(i,3*j-1)=sum(xx2==i)/length(xx2);
end

% Compare RT via ANOVA
x11=x1(x1<100);
x22=x2(x2<100);
xx=[x11;x22];
kk=ones(length(xx),1);kk(1:length(x11))=2;
p=anova1(xx,kk);
dp(j,1)=mean(x11);
dp(j,2)=mean(x22);
dp(j,3)=p;
dp(j,4)=length(x11);
dp(j,5)=length(x22);
dp(j,6)=std(x11)/length(x11)^0.5;
dp(j,7)=std(x22)/length(x22)^0.5;
end

dat4=nan(6,2);
for j=1:6
x1=cell2mat(data2(2:end,lie(1,j)));x1=x1(~isnan(x1));
x2=cell2mat(data2(2:end,lie(2,j)));x2=x2(~isnan(x2));

xx1=nan(length(x1),1);
xx1(x1<=2)=1;
xx1(x1<=4&x1>2)=2;
xx1(x1<=6&x1>4)=3;
xx1(x1<=8&x1>6)=4;
xx1(x1<=10&x1>8)=5;
xx1(x1<=99&x1>10)=6;
xx1(x1>99)=7;

xx2=nan(length(x2),1);
xx2(x2<=2)=1;
xx2(x2<=4&x2>2)=2;
xx2(x2<=6&x2>4)=3;
xx2(x2<=8&x2>6)=4;
xx2(x2<=10&x2>8)=5;
xx2(x2<=99&x2>10)=6;
xx2(x2>99)=7;

dat4(j,1)=sum(xx1==7)/length(xx1);
dat4(j,2)=sum(xx2==7)/length(xx2);
end
dat4([3 6],:)=[];

%% 5*5 验证
% a NDVI vs. NDII
dat=xlsread('E:\科研\森林恢复\data\NDVI和NDII以及影响因素(5乘以5)\1比1线图\1比1线图(5-5).xlsx');
rt_v2=dat(:,1);
rt_b2=dat(:,2);
cc=[0.5 0.5 0.5;0.4 0.7 0.3; 0.2 0.3 0.5; 0.6 0.3 0.3];

set(gcf,'paperpositionmode','auto','position',[10 20  800 700]);
axes('position',[0.08 0.55 0.38 0.4],'linewidth',0.8,'box','on')
plot(rt_v2,rt_b2,'.','markersize',8,'color',cc(1,:));hold on
xlim([0 30]);
ylim([0 30]);
set(gca,'xtick',0:10:30,'ytick',0:10:30);
xlabel('RT for NDVI (year)');
ylabel('RT for NDII (year)');
text(-3,31,'a','fontsize',12,'fontweight','b');
line([0 30],[0 30],'linestyle','--','linewidth',0.5,'color',[.7 .7 .7]);
set(gca,'linewidth',0.5,'fontsize',10);

[~,~,data]=xlsread('E:\科研\森林恢复\data\NDVI和NDII以及影响因素(5乘以5)\RT与驱动因素\Global-RT-NDVI-NDII(5-5).xls');
rt_v=cell2mat(data(2:end,5));%recovery time of ndvi
rt_b=cell2mat(data(2:end,6));%recovery time of ndii

x1=nan(1699,1);
x1(rt_v<=2)=1;
x1(rt_v<=4&rt_v>2)=2;
x1(rt_v<=6&rt_v>4)=3;
x1(rt_v<=8&rt_v>6)=4;
x1(rt_v<=10&rt_v>8)=5;
x1(rt_v<=99&rt_v>10)=6;
x1(rt_v>99)=7;

x2=nan(1699,1);
x2(rt_b<=2)=1;
x2(rt_b<=4&rt_b>2)=2;
x2(rt_b<=6&rt_b>4)=3;
x2(rt_b<=8&rt_b>6)=4;
x2(rt_b<=10&rt_b>8)=5;
x2(rt_b<=99&rt_b>10)=6;
x2(rt_b>99)=7;
dy=cellstr(data(2:end,4));
dye={'80s','90s','2000s','2010s'};

%不能恢复的比例
dat=nan(4,5);
for i=1:4
    x11=x1(strcmp(dye(i),dy)==1);
    dat(i,5)=sum(x11==7)/length(x11);
    
    x22=x2(strcmp(dye(i),dy)==1);
    dat(i,6)=sum(x22==7)/length(x22);
end

axes('position',[0.28 0.59 0.17 0.1],'linewidth',0.8,'box','on')
bar(dat(:,5:6),1);
set(gca,'xtick',1:4,'xticklabel',{'1980s','1990s','2000s','2010s'});
xlim([0.5 4.5]);
text(1,0.4,'NDVI','color',[0 .45 .74],'fontsize',8);
text(1,0.32,'NDII','color',[.85 .33 .1],'fontsize',8);
set(gca,'ytick',0:0.2:0.4,'yticklabel',0:20:40);
box off
ylabel('Unrecovered ratio (%)');
ylim([0 0.5]);
set(gca,'linewidth',0.5,'fontsize',8);

axes('position',[0.54 0.55 0.38 0.4],'linewidth',0.8,'box','on')
cc=[0.1 0.3 0.3;0.3 0.3 0];gpname={};
barweb(dp(1:2,1:2),dp(1:2,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylabel('RT for NDVI (year)');
text(0.75,-0.35,'1980s','fontsize',10);
text(1.05,-0.35,'1990s','fontsize',10);
text(0.75,6.3,'a','fontsize',10);
text(1.05,6.3,'a','fontsize',10);

text(1.75,-0.35,'1990s','fontsize',10);
text(2.05,-0.35,'2000s','fontsize',10);
text(1.75,5.3,'a','fontsize',10);
text(2.05,6.8,'b','fontsize',10);
line([1.5 1.5],[0 7],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
ylim([0 7]);
text(0.28,7*31/30,'b','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);
%
axes('position',[0.08 0.06 0.38 0.4],'linewidth',0.8,'box','on')
barweb(dp(4:5,1:2),dp(4:5,6:7),1,gpname,'','','',cc([1,2],:),'none','',2,'none');hold on
alpha(0.5)
ylim([0 12]);
ylabel('RT for NDII (year)');
text(0.75,-0.6,'1980s','fontsize',10);
text(1.05,-0.6,'1990s','fontsize',10);
text(0.75,8,'a','fontsize',10);
text(1.05,9,'a','fontsize',10);

text(1.75,-0.6,'1990s','fontsize',10);
text(2.05,-0.6,'2000s','fontsize',10);
text(1.75,7.2,'a','fontsize',10);
text(2.05,9.5,'b','fontsize',10);
line([1.5 1.5],[0 12],'linestyle','--','linewidth',0.5,'color',[0.5 0.5 0.5]);
text(0.333,12*31/30,'c','fontsize',12,'fontweight','b');
set(gca,'linewidth',0.5,'fontsize',10);

axes('position',[0.54 0.06 0.38 0.4],'linewidth',0.8,'box','on')
bar(dat4*100,'barwidth',1);
ylabel('Unrecovered ratio (%)');
ylim([0 50]);
text(0.7,46,'NDVI','fontsize',10);
text(2.7,46,'NDII','fontsize',10);
line([2.5 2.5],[0 50],'linewidth',0.5,'linestyle','--','color',[0.5 0.5 0.5]);
set(gca,'linewidth',0.5,'fontsize',10);
set(gca,'xtick','');

text(0.6,-5,'1980s','fontsize',10,'rotation',50);
text(.9,-5,'1990s','fontsize',10,'rotation',50);

text(1.6,-5,'1990s','fontsize',10,'rotation',50);
text(1.9,-5,'2000s','fontsize',10,'rotation',50);

text(2.6,-5,'1980s','fontsize',10,'rotation',50);
text(2.9,-5,'1990s','fontsize',10,'rotation',50);

text(3.6,-5,'1990s','fontsize',10,'rotation',50);
text(3.9,-5,'2000s','fontsize',10,'rotation',50);
text(0.078,50*31/30,'d','fontsize',12,'fontweight','b');

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig5');
%print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig5');

%% Fig. 6 cross validation
data1=xlsread('E:\科研\森林恢复\ML_python\ndvi_train.csv');
data2=xlsread('E:\科研\森林恢复\ML_python\ndvi_test.csv');
col1=[0.2 0.2 0.8];
col2=[0.8 0.2 0.2];

set(gcf,'paperpositionmode','auto','position',[10 20  750 380]);
axes('position',[0.08 0.15 0.4 0.75],'linewidth',0.8,'box','on') 
plot(data1(:,2),data1(:,3),'.','markersize',10,'color',col1);hold on
plot(data2(:,2),data2(:,3),'.','markersize',10,'color',col2);hold on

set(gca,'box','on');
hold on;
line([0 1.2],[0 1.2],'linestyle','--','linewidth',0.8,'color',[0.5 0.5 0.5]);
hold off;
axis([-0.1 1.2 -0.1 1.2]);
set(gca,'fontsize',10);
set(gca,'xtick',0:0.1:1.2);
set(gca,'ytick',0:0.1:1.2);
xlabel('Observed log10(RT for NDVI)','fontsize',10);
ylabel('Predicted log10(RT for NDVI)','fontsize',10);

rr=regstats(data1(:,2),data1(:,3));
text(0.4,0.14,'Training data','color',col1,'fontsize',10);
text(0.4,0.07,strcat('RMSE = ',sprintf('%2.3f',sqrt(rr.mse))),'fontsize',10,'color',col1);
text(0.4,0,strcat('R^2 = ',sprintf('%2.2f',rr.rsquare)),'fontsize',10,'color',col1);hold on

rr=regstats(data2(:,2),data2(:,3));
text(0.8,0.14,'Test data','color',col2,'fontsize',10);
text(0.8,0.07,strcat('RMSE = ',sprintf('%2.3f',sqrt(rr.mse))),'fontsize',10,'color',col2);
text(0.8,0.0,strcat('R^2 = ',sprintf('%2.2f',rr.rsquare)),'fontsize',10,'color',col2);hold on

text(-0.3,1.2,'a','fontsize',12,'fontweight','b');

axes('position',[0.58 0.15 0.4 0.75],'linewidth',0.8,'box','on') 
data1=xlsread('E:\科研\森林恢复\ML_python\ndii_train.csv');
data2=xlsread('E:\科研\森林恢复\ML_python\ndii_test.csv');

plot(data1(:,2),data1(:,3),'.','markersize',10,'color',col1);hold on
plot(data2(:,2),data2(:,3),'.','markersize',10,'color',col2);hold on

set(gca,'box','on');
hold on;
line([0 1.2],[0 1.2],'linestyle','--','linewidth',0.8,'color',[0.5 0.5 0.5]);
hold off;
axis([-0.1 1.2 -0.1 1.2]);
set(gca,'fontsize',10);
set(gca,'xtick',0:0.1:1.2);
set(gca,'ytick',0:0.1:1.2);
xlabel('Observed log10(RT for NDII)','fontsize',10);
ylabel('Predicted log10(RT for NDII)','fontsize',10);

rr=regstats(data1(:,2),data1(:,3));
text(0.4,0.14,'Training data','color',col1,'fontsize',10);
text(0.4,0.07,strcat('RMSE = ',sprintf('%2.3f',sqrt(rr.mse))),'fontsize',10,'color',col1);
text(0.4,0,strcat('R^2 = ',sprintf('%2.2f',rr.rsquare)),'fontsize',10,'color',col1);hold on

rr=regstats(data2(:,2),data2(:,3));
text(0.8,0.14,'Test data','color',col2,'fontsize',10);
text(0.8,0.07,strcat('RMSE = ',sprintf('%2.3f',sqrt(rr.mse))),'fontsize',10,'color',col2);
text(0.8,0.0,strcat('R^2 = ',sprintf('%2.2f',rr.rsquare)),'fontsize',10,'color',col2);hold on

text(-0.3,1.2,'b','fontsize',12,'fontweight','b');

print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig6');
print(gcf,'-dtiff','-r300','E:\科研\森林恢复\Fig_v4\Fig6');

addpath('D:\useful\useful2\cbrewer')

%% Figure 2-4 相同温度降水下不同年代的比较-修改
load('D:\科研\森林恢复\data\data2.mat');
lie=[5 23 6 24;14 32 15 33];
tx={'a','b','c','d'};
set(gcf,'paperpositionmode','auto','position',[10 20  750 700]);
py=[0.6 0.6 0.18 0.18];px=[0.15 0.6 0.15 0.6];
for j=1:4
xk1=cell2mat(data2(2:end,lie(1,j)));xk1=xk1(~isnan(xk1));
xk2=cell2mat(data2(2:end,lie(2,j)));xk2=xk2(~isnan(xk2));
if j<3
mat=cell2mat(data2(2:end,lie(1,j)+3));mat=mat(~isnan(mat));
map=cell2mat(data2(2:end,lie(1,j)+2));map=map(~isnan(map));

mat2=cell2mat(data2(2:end,lie(2,j)+3));mat2=mat2(~isnan(mat2));
map2=cell2mat(data2(2:end,lie(2,j)+2));map2=map2(~isnan(map2));
else
mat=cell2mat(data2(2:end,lie(1,j)+2));mat=mat(~isnan(mat));
map=cell2mat(data2(2:end,lie(1,j)+1));map=map(~isnan(map));

mat2=cell2mat(data2(2:end,lie(2,j)+2));mat2=mat2(~isnan(mat2));
map2=cell2mat(data2(2:end,lie(2,j)+1));map2=map2(~isnan(map2));
end

%
dat_cli1=nan(17,19);
dat_num=nan(17,19);

YY=xk1;
pre=map;
temp=mat;
pre=pre(YY<100);
temp=temp(YY<100);
YY=YY(YY<100);
for i=1:16
    for tt=1:18
        yy2=YY(pre>=-200+tt*200&pre<tt*200&temp>=-6+2*i&temp<-4+2*i);
        dat_cli1(i,tt)=mean(yy2);
        dat_num(i,tt)=length(yy2);
    end
end

dat_cli2=nan(17,19);
dat_num=nan(17,19);

YY=xk2;
pre=map2;
temp=mat2;
pre=pre(YY<100);
temp=temp(YY<100);
YY=YY(YY<100);
for i=1:16
    for tt=1:18
        yy2=YY(pre>=-200+tt*200&pre<tt*200&temp>=-6+2*i&temp<-4+2*i);
        dat_cli2(i,tt)=mean(yy2);
        dat_num(i,tt)=length(yy2);
    end
end

axes('position',[px(j) py(j) 0.34 0.35],'linewidth',0.8,'box','on')
dat_cli=(dat_cli2-dat_cli1)';
pcolor(dat_cli)
cm=cbrewer('div','RdYlGn',11,'Cubic');
cm2=cm(11:-2:1,:);
colormap(cm2)
caxis([-6 6]);
%
set(gca,'xtick',1:2:17,'xticklabel',-4:4:28);
xlabel('MAT (^{o}C)');
set(gca,'ytick',1:2:20,'yticklabel',0:400:3600);
ylabel('MAP (mm year^{-1})');
set(gca,'fontsize',10,'linewidth',0.5);
text(0,13.2,tx(j),'fontsize',12,'fontweight','b');
ylim([1 13])
xlim([3 15])
end

h1=colorbar('SouthOutside');
set(h1,'Position',[.35 0.08 0.4 0.03]);
ylabel(h1,'Difference in RT between decades (year)','fontsize',10,'position',[0 -0.8]);

%print(gcf,'-djpeg','-r300','E:\科研\森林恢复\Fig_v4\Fig2_4');
%print(gcf,'-dtiff','-r300','D:\科研\森林恢复\Fig_v4\Fig2_4-2');
