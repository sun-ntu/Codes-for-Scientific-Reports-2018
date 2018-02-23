clear all;
close all;

Folder1='Coagulation_data\'; % heparin data folder
load ([Folder1 'absoprtion_coagulation_clot_1st_min.mat'])
load ([Folder1 'absoprtion_coagulation_exp_1st_min.mat'])
% It's a matrix, each row stand for different frequency and each column stands for each patient
Folder2='Heparin_data\'; % heparin data folder
load ([Folder2 'absorption_heparin.mat'])
% It's a matrix, each row stand for different frequency and each column stands for each patient

freq_s=(0.0681:0.0681:0.0681*15);    % Frequency set
freq_s=freq_s';
% Due to 259 pts in time domain and a time interval of 0.0567 (ps)
% 272GHz at freq_s(4), 817GHz at freq_s(12)

%% T-test for each frequency (Selecting normal patient)
Coagulation_PLT=load([Folder1 'Coagulation_PLT.dat']);   % unit: (K/uL)

load ('Coagulation_data\normal_patient.mat')
% for j=1:length(normal_patient);
% %     A(:,j)=absoprtion_coagulation_clot_1st_min(:,normal_patient(j));
%     % A=absoprtion_coagulation_exp_1st_min;
% 
%     A(:,j)=absoprtion_coagulation_exp_1st_min(:,normal_patient(j));
% end
%% Group high PLT & low PLT among normal patients
for pp=1:length(normal_patient)
    Coagulation_PLT_within(pp,1)=Coagulation_PLT(normal_patient(pp));
end
BB=Coagulation_PLT_within > 200; % temp selection of PLT>200, this output a column vector whereas element =1 if normal_patient's PLT>200, element =0 if not.
H_PLT_patient=normal_patient(find(BB)); % This gives the n-th number of the paitents whose PLT >200. E.g. Transpose is only for later usage as the oringal "normal patient"
CC=Coagulation_PLT_within < 200; % temp selection of PLT<200, this output a column vector whereas element =1 if normal_patient's PLT<200, element =0 if not.
L_PLT_patient=normal_patient(find(CC)); % This gives the n-th number of the paitents whose PLT <200. E.g. Transpose is only for later usage as the oringal "normal patient"

for j=1:length(H_PLT_patient);      % Change "___patient" here to investigate the interested patient type (e.g. high or low PLT)
%     A(:,j)=absoprtion_coagulation_clot_1st_min(:,normal_patient(j));
    % A=absoprtion_coagulation_exp_1st_min;

    A(:,j)=absoprtion_coagulation_exp_1st_min(:,H_PLT_patient(j));
end

%% Group high PLT & low PLT among all patients
% BBB=Coagulation_PLT > 200; % temp selection of PLT>200, this output a column vector whereas element =1 if patient's PLT>200, element =0 if not.
% H_PLT_all_patient=find(BBB)'; % This gives the n-th number of the paitents whose PLT >200. E.g. Transpose is only for later usage as the oringal "normal patient"
% CCC=Coagulation_PLT < 200; % temp selection of PLT<200, this output a column vector whereas element =1 if patient's PLT<200, element =0 if not.
% L_PLT_all_patient=find(CCC)'; % This gives the n-th number of the paitents whose PLT <200. E.g. Transpose is only for later usage as the oringal "normal patient"
% 
% for j=1:length(H_PLT_all_patient);      % Change "___patient" here to investigate the interested patient type (e.g. high or low PLT)
%     A(:,j)=absoprtion_coagulation_clot_1st_min(:,normal_patient(j));
%     A=absoprtion_coagulation_exp_1st_min;
% 
%     A(:,j)=absoprtion_coagulation_exp_1st_min(:,H_PLT_all_patient(j));
% end

   
%% Performing t-test for each frequency

B=absorption_heparin;
[h,p_value,~,stats]=ttest2(A',B'); % Transpose so we can perform t-test on column (different frequency)
%% Mean and standard deviation of both data
mean_A=mean(A,2);
mean_B=mean(B,2);
std_A=std(A,0,2);
std_B=std(B,0,2);
%% Export/plot  data in Origin
    % Obtain Origin COM Server object
    % This will connect to an existing instance of Origin, or create a new one if none exist
    originObj=actxserver('Origin.Application');
    % Make the Origin session visible
    invoke(originObj, 'Execute', 'doc -mc 1;');
    % Clear "dirty" flag in Origin to suppress prompt for saving current project
    % You may want to replace this with code to handling of saving current project
    invoke(originObj, 'IsModified', 'false');
%%
    % Load the custom project CreateOriginPlot.OPJ found in Samples area of Origin installation
    invoke(originObj, 'Execute', 'p_value.OPJ');
%     strPath='';
%     strPath = invoke(originObj, 'LTStr', 'syspath$');
    invoke(originObj, 'Load', strcat([pwd '\p_value.OPJ']));
    % Create some data to send over to Origin - create three vectors
    % This can be replaced with real data such as result of computation in MATLAB
    mdata1 = [freq_s mean_A std_A mean_B std_B p_value'];
    mdata2 = [freq_s A];
    % Send this data over to the Data1 worksheet
    invoke(originObj, 'PutWorksheet', 'Data1', mdata1);
    invoke(originObj, 'PutWorksheet', 'Data2', mdata2);
    % Rescale the two layers in the graph and copy graph to clipboard
    invoke(originObj, 'Execute', 'pageactive = 1; layer - a; pageactive = 2; layer - a;');
    invoke(originObj, 'CopyPage', 'Graph1');
%% 

