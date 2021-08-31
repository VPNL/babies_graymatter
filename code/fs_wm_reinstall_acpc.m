function [] = fs_wm_reinstall_withgrayclass(subj,sess, clean_pial) 
%% usage:
%% [] = fs_wm_reinstall_withgrayclass('bb11', 'mri0',i)
% This function converts the updated segmentation files (usually called something "class file") into wm.mgz. 
% wm.mgz is file contains the white matter information for both left and right hemisphere. 
% Freesurfer uses this file to create all the surface matrices, e.g., lh.white, rh.right..etc.
% We do this step because occasionally the segmentation (wm.mgz) obtained from Freesurfer misses some of the white matter. 
% This is especially true for kids because their heads are small. 
% Therefore, we rerun Freesurfer's recon pipeline from the part where it starts working on the whitematter segmentation, 
% after manually correcting the white matter file.
%% TO RUN THIS FUNCTION:
%% [] = fs_wm_reinstall_withgrayclass(babysubject,session, clean_pial)
%% babysubject = e.g. 'bb01'
%% session = the session name. e.g. 'mri0'
%% clean_pial = 1 (if you want to clean the pial surface)
%% vn 2020

segmentationfilepath = ['/biac2/kgs/projects/babybrains/mri/',subj,'/',sess,'/preprocessed_acpc/']; 
segmentationfilename = 't1_class_gray_acpc.nii.gz';
freesurferfoldername = [subj '_' sess];

display('this code will only run properly for the clas files that are created using the iBEAT. If it created using the ribbon file (values may be 0 , 3 ,4 in the whitematter file) then please talk to vaidehi or mona');
cd (segmentationfilepath);
%%% START %%%%%
segment_niftidata =readFileNifti(segmentationfilename); %% the restored segmented file, it is a generally a class file. It should have 3 three numbers, 0, 3 (left hemisphere white matter), and 4 (right hemishpere white matter). 
vals = unique(segment_niftidata.data) % check the number, usually 0, 192, 255  
 
 if sum(vals == [0 1 2 3 4 5]') == 6
        display('Regular values!');
 else 
        warning('Check your Segmentation File. It has non-regular values');
 end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
       %%%%%%%%%%% making wm.mgz %%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 display('creating NEWWHITEMATTER....')
 %% make sure the class file is the work directory
 %command = ['mri_convert -rt nearest -rl /biac2/kgs/anatomy/freesurferRecon/babySegmentations/', freesurferfoldername, '/mri/norm.nii.gz ', segmentationfilename, ' /biac2/kgs/anatomy/freesurferRecon/babySegmentations/' freesurferfoldername, '/work/NEWWHITEMATTER.nii.gz --conform']; 
 command= ['cp ', segmentationfilename, '  /biac2/kgs/anatomy/freesurferRecon/babySegmentations/', freesurferfoldername, '/work/NEWWHITEMATTER.nii.gz'];
 unix(command);

 cmd = ['sudo chmod -R 777 /share/kalanit/biac2/kgs/anatomy/freesurferRecon/babySegmentations/', freesurferfoldername];
 unix(cmd)
 cd(['/share/kalanit/biac2/kgs/anatomy/freesurferRecon/babySegmentations/' freesurferfoldername '/work/']) % go into freesurfersegmentation/work directory
 
 mkdir surf %% create this directory for the autorecon function as it write temporary files into this work/surf directory.
 !mri_convert ../mri/norm.nii.gz ORIG.nii.gz 
 % copy the norm as ORIG to use to create header files 
 
%%% load these files
 seg =readFileNifti('NEWWHITEMATTER.nii.gz');  
 disp('current segmentation values')
 unique(seg.data)
 origi=readFileNifti('ORIG.nii.gz');
 nii_wmseg=origi;
 nii_wmseg.data=seg.data;
 nii_wmseg.data(find(seg.data==1))=0; % outside and ventricles
 nii_wmseg.data(find(seg.data==2))=0; % gray matter
 nii_wmseg.data(find(seg.data==5))=0; % gray matter
 
 nii_wmseg.data(find(seg.data==3))=110; % left 
 nii_wmseg.data(find(seg.data==4))=110; % right 
 %nii_wmseg.data(find(seg.data==192))=110;
 %nii_wmseg.data(find(seg.data==255))=110;
 
 nii_wmseg.fname = 'WM_VN.seg.nii.gz';
 writeFileNifti(nii_wmseg);
 
 %%%%%%%%% now convert these files to temporary nifits to work with because
 %%%%%%%%% we have reassign 250 or 110 to different cortical structures 
 %%%%%%%%% to create the new white matter file.
 !cp WM_VN.seg.nii.gz fornewwm_cortex.nii.gz;
 %%% now create the rest of the files and update wm.mgz
 forven=readFileNifti('aseg.nii.gz'); % we will use the aseg nifti which has integer labels to all the subcortical and cortical strucutres
 nii_wmfinal = readFileNifti('fornewwm_cortex.nii.gz'); 
 right_label =[43 50 51 52 58 60]; % right sub cortical structures 
 left_label = [4 11 12 13 26 28]; % left sub cortical structures 
 pons_label = [173 174 175]; % pons and stuff
 
 for ll=1:length(right_label)
   nii_wmfinal.data(find(forven.data==right_label(ll)))=250; %% right subcortical labels
 end
  
 for ll=1:length(left_label)
   nii_wmfinal.data(find(forven.data==left_label(ll)))=250; %% left subcortical labels
 end

for ll=1:length(pons_label)
   nii_wmfinal.data(find(forven.data==pons_label(ll)))=110; %% pons labels
end

 %% white the new white matte file
nii_wmfinal.fname='Whitematter.nii.gz'; 
writeFileNifti(nii_wmfinal);
 %% check the whitematter file before creating wm.mgz using it.
!freeview -v Whitematter.nii.gz
%% if all looks good..
!mri_convert Whitematter.nii.gz wm.mgz 
!mri_convert Whitematter.nii.gz wm.asegedit.mgz

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
       %%%%%%%%%%% making filled.mgz %%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 display('creating filled.mgz')
 seg =readFileNifti('NEWWHITEMATTER.nii.gz'); 
 origi=readFileNifti('ORIG.nii.gz');
 nii_filled=origi;
 nii_filled.data=seg.data;
 nii_filled.data(find(seg.data==4))=127; %% right hemi   %SWITCHED 3 AND 4 AFTER LAS FLIP OF T1_CLASS
 nii_filled.data(find(seg.data==3))=255; %% left hemi 

 nii_filled.data(find(seg.data==1))=0; %% other things 
 nii_filled.data(find(seg.data==2))=0; %% left hemi gray
  nii_filled.data(find(seg.data==5))=0; %% right hemi gray

 for ll=1:length(right_label)
   nii_filled.data(find(forven.data==right_label(ll)))=127; %% right subcortical labels
 end
  
 for ll=1:length(left_label)
   nii_filled.data(find(forven.data==left_label(ll)))=255; %% left subcortical labels
 end

 nii_filled.fname = 'filled.nii.gz';
 writeFileNifti(nii_filled);
 %% check the filled  should only have two values one for left and one for right hemi. it is different that the wm.mgz
 !freeview -v filled.nii.gz;
 !mri_convert filled.nii.gz filled.mgz;
 %% FilledWM.mgz is what the autorecon code looks for so rename it.
  !cp filled.mgz FilledWM.mgz 
%% remove all the temporarily created files
 display('all whitematter and associated files created');
 display('deleting all temp files...');
 !rm -f fornewwm_cortex.nii.gz;
 !rm -f NEWWHITEMATTER.nii.gz;
 !rm -f ORIG.nii.gz;
 
 %% chekc all files before running the autorecon file. this part is run on the docker for infant data 
 !freeview -v wm.mgz filled.mgz
 !cp wm.mgz filled.mgz wm.asegedit.mgz ../mri/.
 
 % dublicating the norm.gz file ans save as orig.mgz since infantFS doesnt
 % create one and it is needed for tksurfer. IMPORTANT. assuming norm and
 % orig are identical.
 
 !cp ../mri/norm.mgz ../mri/orig.mgz

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%% run pial cleaner %%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if clean_pial ==1
     cd(['/share/kalanit/biac2/kgs/anatomy/freesurferRecon/babySegmentations/' freesurferfoldername '/mri/']) % go into freesurfersegmentation/work directory

   if ~exist('old_aseg.nii.gz','file')
     
     !cp aseg.nii.gz old_aseg.nii.gz;
     !cp aseg.mgz old_aseg.mgz;
   end
     
     %% copy the grayfile in mri dir
     command= ['cp ', segmentationfilepath, segmentationfilename, ' .'];
     unix(command);
     %% read in the cleaned files that come from ibeat
     newseg = readFileNifti('t1_class_gray.nii.gz');
     %% now create the new cleaned segmentation files. Here both gray and white matter is cleaned for making
     %% good pial and white matter surfaces.
     oldseg = readFileNifti('old_aseg.nii.gz');
     oldseg.fname='cleanaseg.nii.gz';
     oldseg.data(newseg.data==2)=42; % right gray
     oldseg.data(newseg.data==4)=41; %  right white
     oldseg.data(newseg.data==3)=2; %% left white
     oldseg.data(newseg.data==5)=3; %%  left gray
     oldseg.data(newseg.data==1)=0; %%  external hull that comes from ibeat.
     
     writeFileNifti(oldseg);
     !mri_convert cleanaseg.nii.gz cleanaseg.mgz;
     !freeview -v cleanaseg.nii.gz
     
     %% copy the clean files to the aseg file for the reinstall code to use.
     !cp cleanaseg.nii.gz aseg.nii.gz;
     !cp cleanaseg.mgz aseg.mgz;
     
     
 end

display('now run autorecon-vn-mr-final in the docker. See steps in the babybrains/code/freesurfer/docker textfile to run it');
