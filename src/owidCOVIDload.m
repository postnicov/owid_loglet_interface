clear;close all;clc
FS=14;%Font size for figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify country
iso_code='RUS';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimal total cases 
mintot=100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load file and convert to cells
v=ver;
if strcmp(v(1).Name,'Octave')
  urlwrite('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv','owid-covid-data.csv');
  filename='owid-covid-data.csv';
  TBL=csv2cell(filename,0);
else
  urlwrite('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.xlsx','owid-covid-data.xlsx');
  filename='owid-covid-data.xlsx';
  [~,~,TBL]=xlsread(filename);
end
%% Extract data for the designated country
id=find(strcmp(TBL(:,1),iso_code));
%% Data extraction
dataid=cell2mat(TBL(id,5));
idx=id(dataid>mintot);
t=[0:length(idx)-1];
country=cell2mat(TBL(idx(1),3));
date=TBL(idx,4);
total_cases=cell2mat(TBL(idx,5));
new_cases=cell2mat(TBL(idx,6));

figure
semilogy(t,total_cases,'o')
grid on
ylabel('Total cases')
title([country, ' (',cell2mat(date(end)),')'])
set(gca,'XTick',[t(1):14:t(end)],'XTickLabel',date(1:14:end),'FontSize',FS)


A=['Days since ',date{1}];
u=[t',total_cases];
textHeader = cell2mat({A,',Total cases'});
outfilename=[country,'(',date{end},').csv'];
fid = fopen(outfilename,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
dlmwrite(outfilename,u,'-append');
save('processed_file_info.mat','outfilename','date','country');

%%%%
fid = fopen('processed_file_info.txt','w'); 
fprintf(fid,'%s\r\n',outfilename);
fprintf(fid,'%s\r\n',country);
for j=1:length(idx);
    fprintf(fid,'%10s\r\n',char(date(j)));
end
fclose(fid);

