% Correlation coefficient
clear all;
close all;

Folder1='Coagulation_data\'; % heparin data folder
load ([Folder1 'absoprtion_coagulation_clot_1st_min.mat'])
load ([Folder1 'absoprtion_coagulation_exp_1st_min.mat'])
% It's a matrix, each row stand for different frequency and each column stands for each patient
Folder2='Heparin_data\'; % heparin data folder
load ([Folder2 'absorption_heparin.mat'])
% It's a matrix, each row stand for different frequency and each column stands for each patient

Coagulation_PLT=load([Folder1 'Coagulation_PLT.dat']);   % unit: (K/uL)

freq_s=(0.0681:0.0681:0.0681*15);    % Frequency set
freq_s=freq_s';
% Due to 259 pts in time domain and a time interval of 0.0567 (ps)
% 272GHz at freq_s(4), 340GHz at freq_s(5), 681GHz at freq_s(10), 817GHz at freq_s(12)
%% Estimate correlation of PLT & absorption for normal patients   (comment next section when using this section)
% patient=[1	3	5	6	7	9	12	13	15	16	18	19	20	24	25	26	27	28]; % patient within the region of 4<RBC<=5 and 100<PLT<300. Or using load ('Coagulation_data\normal_patient.mat').
% for pp=1:length(patient)
%     Coagulation_PLT_within(pp,1)=Coagulation_PLT(patient(pp));
% %     A(:,pp)=absoprtion_coagulation_clot_1st_min(:,patient(pp));
%     A(:,pp)=absoprtion_coagulation_exp_1st_min(:,patient(pp));
% end
% for j=1:length(freq_s)
%     [R_coagulation_PLT(j), p_coagulation_PLT(j)]=corr(Coagulation_PLT_within,A(j,:)');% correlation, R and p-value at all freq.
% end
% 
%     PLT_clot_correlation=[p_coagulation_PLT;R_coagulation_PLT];

%% Estimate correlation of PLT & absorption for all patients    (comment previous section when using this section)

% A=absoprtion_coagulation_clot_1st_min;
A=absoprtion_coagulation_exp_1st_min;

for j=1:length(freq_s)
    [R_coagulation_PLT(j), p_coagulation_PLT(j)]=corr(Coagulation_PLT,A(j,:)');% correlation, R and p-value at all freq.
end

    PLT_clot_correlation=[p_coagulation_PLT;R_coagulation_PLT];

    
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
    invoke(originObj, 'Execute', 'Correlation_PLT.OPJ');
%     strPath='';
%     strPath = invoke(originObj, 'LTStr', 'syspath$');
    invoke(originObj, 'Load', strcat([pwd '\Correlation_PLT_2.OPJ']));
    % Create some data to send over to Origin - create three vectors
    % This can be replaced with real data such as result of computation in MATLAB
    mdata1= [Coagulation_PLT A(2,:)' A(3,:)' A(4,:)' A(5,:)' A(10,:)' A(12,:)' A(13,:)' A(14,:)' A(15,:)'];
    mdata2= [freq_s p_coagulation_PLT' R_coagulation_PLT'];
    % Send this data over to the Data1 worksheet
    invoke(originObj, 'PutWorksheet', 'Data1', mdata1);
    invoke(originObj, 'PutWorksheet', 'Data2', mdata2);
    
    % Rescale the two layers in the graph and copy graph to clipboard
    invoke(originObj, 'Execute', 'pageactive = 1; layer - a; pageactive = 2; layer - a;');
    invoke(originObj, 'CopyPage', 'Graph1');
    
    %%