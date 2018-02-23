% Coding by Hui-Yuan 0517 2017
clear all;
close all;

Folder='Coagulation_data\'; % Coagulation data folder
all_files=dir(fullfile(Folder, '*.txt'));                     % select all csv files(raw data from mini-Z)

Coagulation_RBC=load([Folder 'Coagulation_RBC.dat']); % unit: (M/uL)
Coagulation_PLT=load([Folder 'Coagulation_PLT.dat']);   % unit: (K/uL)
Coagulation_info=struct;  % Here construct a Matlab Struct to store all 30 patients (no heparin) time domain data

for j=1:length(all_files)
tempinfo=textscan(all_files(j).name,'%n_%n'); % 9 items, 7=step distance, 8=up or down, 9=numbering of z stacks
Coagulation_info(j).number=tempinfo{1};
Coagulation_info(j).patient_ID=tempinfo{2};
Coagulation_info(j).RBC=Coagulation_RBC(j);
Coagulation_info(j).PLT=Coagulation_PLT(j);
Coagulation_info(j).data=load([Folder all_files(j).name]);
end
%%
Coagulation_minute_pad=cell(1,length(Coagulation_info)); % create cell to store later averaged and "padded" data per minute.
absorption_all=cell(1,length(Coagulation_info)); % create cell to store later calculated "absorption" per minute.
for j=1:length(Coagulation_info)
    for k=1:size(Coagulation_info(j).data,2) % zero padding to have same freq set as Heparin data.
          Coagulation_minute_pad{j}(:,k)=padarray(Coagulation_info(j).data(:,k),[259-size(Coagulation_info(j).data,1) 0],'pre');
        % 'pre' instead of 'post' to avoid abrupt change in time domain
    end
    absorption_all{j}=cac_coagulation(Coagulation_minute_pad{j});
end
%%
freq_s=(0.0681:0.0681:0.0681*15);% Frequency set as in the cac_heparin file.
% Due to 259 pts in time domain and a time interval of 0.0567 (ps)
freq_s=freq_s';
% %% Select 1st min clot data
% p=[13 9 12 16 13 13 14 14 12 14 16 14 15 13 11 21 11 14 12 14 13 17 10 13 11 15 13 13 14];  % The 1st min clot time
% for j=1:length(Coagulation_info)
%     absoprtion_coagulation_clot_1st_min(:,j)=absorption_all{j}(:,p(j));
% end
% save([Folder 'absoprtion_coagulation_clot_1st_min.mat'],'absoprtion_coagulation_clot_1st_min','-mat');
%% Select Exp 1st min data
for j=1:length(Coagulation_info)
    absoprtion_coagulation_exp_1st_min(:,j)=absorption_all{j}(:,1);
end
save([Folder 'absoprtion_coagulation_exp_1st_min.mat'],'absoprtion_coagulation_exp_1st_min','-mat');
%%

