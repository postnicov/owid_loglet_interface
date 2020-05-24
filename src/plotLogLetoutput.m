clear;close all;clc;
FS=14;%Font size for figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Printing options
printfigures=1;% 1 - "print"; 0 - "do not print";
frmt='-dpng';
res=300;%resolution in dpi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read info and Loglet Lab and files
fid = fopen('processed_file_info.txt');
data_info = textscan(fid,'%s');
fclose(fid);

outputfilename=cell2mat(data_info{1,1}(1));
logletoutput_filename=[outputfilename(1:end-4),'_download.xlsx'];
country=cell2mat(data_info{1,1}(2));
date=data_info{1,1}(4:end);

[numdata,~,fulldata] =xlsread(logletoutput_filename);
rec_range=isfinite(numdata(:,1));
fit_range=isfinite(numdata(:,5));
t=numdata(rec_range,1);
cumI=numdata(rec_range,2);
tfit=numdata(fit_range,5);
cumIfit=numdata(fit_range,6);

%% Find the final date of extrapolation
dat0vec=datevec(date{1},'yyyy-mm-dd');
days=datenum(dat0vec);
daysshift=addtodate(days,tfit(end)-1,'day');
datvecshift=datevec(daysshift);
datefitends=datestr(datvecshift,'yyyy-mm-dd');
Tend=tfit(end);
Tdatefitends=datefitends;
%% Analysis of the number of phases and existence of statistics

param1=numdata(isfinite(numdata(:,9)),9);
num_phases=length(param1)/4;
isstat=isfinite(numdata(1,11));
num_intvl=~strcmp(fulldata(1,:),'');
dnum_intvl=[0,diff(num_intvl)];
ndnum_intvl=find(dnum_intvl==1);

for j=1:num_phases
    col_bell=ndnum_intvl(3+2*(j-1));
    col_t=ndnum_intvl(4+2*(j-1));
    bell_rec_range{j}=isfinite(numdata(:,col_bell));
    tfit_range{j}=isfinite(numdata(:,col_t));
    tbell{j}=numdata(bell_rec_range{j}(2:end-1),col_bell);
    bell{j}=numdata(bell_rec_range{j}(2:end-1),col_bell+5);
    tbellfit{j}=numdata(tfit_range{j}(2:end-1),col_t);
    bellfit{j}=numdata(tfit_range{j}(2:end-1),col_t+4);
    
    tphase_rec{j}=numdata(bell_rec_range{j},col_bell);
    phase_rec{j}=numdata(bell_rec_range{j},col_bell+1);
    phase_FP_rec{j}=numdata(bell_rec_range{j},col_bell+4);

    tphase_fit{j}=numdata(tfit_range{j},col_t);
    phase_fit{j}=numdata(tfit_range{j},col_t+1);
    if isstat
        phase_stat{j}=numdata(tfit_range{j},col_t+5:col_t+7);
    end
    phase_FP_fit{j}=numdata(tfit_range{j},col_t+3);
end

Tend=round(tphase_fit{num_phases}(end));
Tdaysshift=addtodate(days,Tend-1,'day');
Tdatvecshift=datevec(Tdaysshift);
Tdatefitends=datestr(Tdatvecshift,'yyyy-mm-dd');

%% Composite plot
figure(1)
plot(t,cumI,'o','color','black','LineWidth',1.5);
hold on
plot(tfit(tfit>t(end)),cumIfit(tfit>t(end)),'--','color','red','LineWidth',1.5);
plot(tfit(tfit<=t(end)),cumIfit(tfit<=t(end)),'-','color','red','LineWidth',1.5);
grid on
ylim([0 inf])
ylabel('Total cases')
title([country,': composite plot'])
set(gca,'XTick',[t(1):14:t(end),tfit(end)],'XTickLabel',[date(1:14:end);datefitends],'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 6],'PaperSize',[10 6])


%% Bell plots
figure(2)
for j=1:num_phases
    p{j}=plot(tbell{j},bell{j},'o','LineWidth',1.5);
    clr{j}=get(p{j},'color');  
    hold on
    plot(tbellfit{j}(tbellfit{j}>tbell{j}(end)),bellfit{j}(tbellfit{j}>tbell{j}(end)),'--','color',clr{j},'LineWidth',1.5);
    plot(tbellfit{j}(tbellfit{j}<=tbell{j}(end)),bellfit{j}(tbellfit{j}<=tbell{j}(end)),'-','color',clr{j},'LineWidth',1.5);
end
grid on
ylim([0 inf])
ylabel('Rate (cases per day)')
title([country,': outbreaks'])
set(gca,'XTick',[t(1):14:t(end),Tend],'XTickLabel',[date(1:14:end);Tdatefitends],'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 6],'PaperSize',[10 6])

%% Components plot

figure(3)
for j=1:num_phases
plot(tphase_rec{j},phase_rec{j},'o','color',clr{j},'LineWidth',1.5);
hold on
plot(tphase_fit{j}(tphase_fit{j}>tphase_rec{j}(end)),phase_fit{j}(tphase_fit{j}>tphase_rec{j}(end)),'--','color',clr{j},'LineWidth',1.5);
plot(tphase_fit{j}(tphase_fit{j}<=tphase_rec{j}(end)),phase_fit{j}(tphase_fit{j}<=tphase_rec{j}(end)),'-','color',clr{j},'LineWidth',1.5);
if isstat
    plot(tphase_fit{j},phase_stat{j}(:,1),':','color',clr{j},'LineWidth',1.5);
    plot(tphase_fit{j},phase_stat{j}(:,2),':','color',clr{j},'LineWidth',1.5);
    plot(tphase_fit{j},phase_stat{j}(:,3),'-.','color',clr{j},'LineWidth',1.5);
end
end
grid on
ylim([0 inf])
ylabel('Total cases by components')
title([country,': components plot'])
set(gca,'XTick',[t(1):14:t(end),Tend],'XTickLabel',[date(1:14:end);Tdatefitends],'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 6],'PaperSize',[10 6])

 
%% Fisher-Pry components plot

figure(4)
for j=1:num_phases
    plot(tphase_rec{j},phase_FP_rec{j},'o','color',clr{j},'LineWidth',1.5);
    hold on
    plot(tphase_fit{j}(tphase_fit{j}>tphase_rec{j}(end)),phase_FP_fit{j}(tphase_fit{j}>tphase_rec{j}(end)),'--','color',clr{j},'LineWidth',1.5);
    plot(tphase_fit{j}(tphase_fit{j}<=tphase_rec{j}(end)),phase_FP_fit{j}(tphase_fit{j}<=tphase_rec{j}(end)),'-','color',clr{j},'LineWidth',1.5);
end
grid on
ylim([-2 2])
ylabel('%')
title([country,': Fisher-Pry plots'])
set(gca,'XTick',[t(1):14:t(end),Tend],'XTickLabel',[date(1:14:end);Tdatefitends],'YTick',[-2 -1 0 1 2],'YTickLabel',[1 10 50 90 99],'FontSize',FS)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 6],'PaperSize',[10 6])

%% Printing figures
if printfigures==1

figure(1)
    print('Composite_plot',frmt,['-r',num2str(res)])    
figure(2)
    print('Bells_plot',frmt,['-r',num2str(res)])
figure(3)
    print('Components_plot',frmt,['-r',num2str(res)])
figure(4)
    print('FisherPry_plot',frmt,['-r',num2str(res)])
end

