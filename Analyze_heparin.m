% Coding by Hui-Yuan 0517 2017
clear all;
close all;

Folder='Heparin_data\'; % heparin data folder
all_files=dir(fullfile(Folder, '*.txt'));                     % select all txt files

Heparin_RBC=load([Folder 'Heparin_RBC.csv']); % unit: (M/uL)
Heparin_PLT=load([Folder 'Heparin_PLT.csv']);   % unit: (K/uL)
Heparin_info=struct;  % Here construct a Matlab Struct to store all 28 patients (heparin) time domain data

for j=1:length(all_files)
tempinfo=textscan(all_files(j).name,'%n_%n'); % 9 items, 7=step distance, 8=up or down, 9=numbering of z stacks
Heparin_info(j).number=tempinfo{1};
Heparin_info(j).patient_ID=tempinfo{2};
Heparin_info(j).RBC=Heparin_RBC(j);
Heparin_info(j).PLT=Heparin_PLT(j);
Heparin_info(j).THz_data=load([Folder all_files(j).name]);
end
freq_s=(0.0681:0.0681:0.0681*15);    % Frequency set as in the cac_heparin file.
% Due to 259 pts in time domain and a time interval of 0.0567 (ps)
freq_s=freq_s';
%% Calculation of absorption constant (cm-1)
for j=1:1:length(all_files)
absorption_heparin(:,j)=cac_heparin(Heparin_info(j).THz_data);
end
%% Save calculated file as .mat 
save([Folder 'absorption_heparin.mat'],'absorption_heparin','-mat');
