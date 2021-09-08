Codes folder contains information about the codes and Matlab files required to generate the figures in the manuscript. Each code contains information regarding the figures it will generate. A separate excel file titled “Supplementary Data” has also been provided, which contains all the additional raw data/gene files as well as the supplementary tables for generating figures. 


Information on the codes to generate the linear mixed models: 

Each code generates linear mixed models (LMMs) based on either mean T1 or MD or R1 data files from the following regions 
1. Primary sensory motor areas {'V1', 'M1', 'S1', and 'A1'} -  primary visual, motor, somatosensory, and auditory.
2. Dorsal  {'V1d' 'V2d' 'V3d' 'V3a' 'V3b' 'IPS0' 'IPS1' 'IPS2' 'IPS3'}
3. Ventral {'V1v' 'V2v' 'V3v' 'hV4' 'V01' 'V02' 'PHC1' 'PHC2'}

and provides the estimates and standard errors of intercepts and slopes per model for both the left and right hemispheres. 

%%%%%%%%%%%%%
function []=compute_stats_model_primary()
%% this code generates Figure 1. It produces figures related to development in T1 in the first 6 months of life in the primary sensory-motor regions.
Data matrices required:'All_primary_T1_right' and 'All_primary_T1_left'. (Primary: primary sensory motor, left/right: left and right hemisphere)

%%%%%%%%%%%%%
function []=compute_stats_model_primary_MD()
% this code is useful for generating Figure 1 and Supplementary Figure 4. It produces figures related to development in MD in the first 6 months of life in the primary sensory-motor regions.
Data matrices required:'All_primary_MD_right' and 'All_primary_MD_left'. (Primary: primary sensory motor, left/right: left and right hemisphere)

%%%%%%%%%%%%
function []=compute_stats_model_ventral()
% this code is useful for generating Figure 2 and Supplementary Figure 5. It produces figures related to development in T1 in the first 6 months of life in the ventral visual stream
Data matrices required: 'All_ventral_T1_right' and 'All_ventral_T1_left' (Ventral visual areas, left/right: left and right hemisphere)


%%%%%%%%%%%%
function []=compute_stats_model_dorsal()
% this code is useful for generating Figure 2 and Supplementary Figure 5. It produces figures related to development in T1 in the first 6 months of life in the dorsal visual stream
Data matrices required: 'All_dorsal_T1_right' and 'All_dorsal_T1_left' (Dorsal visual areas, left/right: left and right hemisphere)

%%%%%%%%%%%
function []=compute_stats_model_dorsalR1()
% this code is useful for generating Figure 4 and Supplementary Figure 8. It produces figures related to development in R1 in the first 6 months of life in the dorsal visual stream. 
Data matrices required: 'All_dorsal_R1_right' and 'All_dorsal_R1_left' (Dorsal areas, left/right: left and right hemisphere)

%%%%%%%%%%%
function []=compute_stats_model_ventralR1()
% this code is useful for generating Figure 4 and Supplementary Figure 8. It produces figures related to development in R1 in the first 6 months of life in the ventral visual stream.
Data matrices required: 'All_ventral_R1_right' and 'All_ventral_R1_left' (ventral areas, left/right: left and right hemisphere)


%%%%%%%%%%%
function []=compute_stats_model_MD_dorsal()
% this code is useful for generating Supplementary Figure 6. This produces figures related to development in MD in the first 6 months of life in the dorsal visual stream
Data matrices required: 'All_dorsal_MD_right' and 'All_dorsal_MD_left' (Dorsal areas, left/right: left and right hemisphere)

%%%%%%%%%%%
compute_stats_model_MD_ventral()
% This code is useful for generating Supplementary Figure 6. This produces Figures related to development in MD in the first 6 months of life in the ventral visual stream
Data matrices required: 'All_ventral_MD_right' and 'All_ventral_MD_left' (Ventral areas, left/right: left and right hemisphere)


