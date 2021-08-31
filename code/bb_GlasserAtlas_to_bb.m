% this code will align the cytoarchitectonic atlas of the ventral stream
% from the fsaverage brain to individual brains specificed in 'subj'. the
% ROIs will then be transformed to nifti files and saved in */label/nii/
% lastly, for each of the subjects an annotation file with all 8 labels
% will be created for each hemisphere
%
%% specify subjects in line 12
%%
% MR May 2020
%%

%subj = {'bb02_mri0','bb04_mri0','bb05_mri0','bb07_mri0','bb11_mri0','bb12_mri0','bb14_mri0','bb17_mri0','bb18_mri0','bb22_mri0', ...
 %           'bb02_mri3','bb04_mri3','bb05_mri3','bb07_mri3','bb08_mri3','bb11_mri3','bb12_mri3','bb14_mri3','bb15_mri3','bb18_mri3', ...
 %           'bb02_mri6','bb04_mri6','bb05_mri6','bb07_mri6','bb08_mri6','bb11_mri5','bb12_mri6','bb14_mri6','bb15_mri6','bb19_mri6'} %,,c

subj = {'bb07_mri0', 'bb07_mri6' 'bb08_mri6' , 'bb11_mri3' 'bb11_mri5' , 'bb14_mri0'}

        hemisphere = {'lh','rh'};

atlasname = 'glasserAtlas'; % name of resulting annotation file
colorfile = '/biac2/kgs/anatomy/freesurferRecon/fsAverage/label/glasserAtlas/glasserColorLUT.txt';

for h = 1:length(hemisphere)
    cd('/biac2/kgs/anatomy/freesurferRecon/babySegmentations/fsAverage/label/glasserAtlas/')
    area = dir([hemisphere{h} '*']);

    % area collection for annotation file
    labels = [];
    for a = 1:length(area)
        labels = [labels, ' --l  '  area(a).name  ];    %hem{h} '.'
        la{a} = area(a).name;
    end
    
    for s = 1:length(subj)
        
        sourcesubject = subj{s};
        labelprefix = sourcesubject;
        
        % create atlas specific folders to save label and nifti ROIs
        rawlabeldir = ['/biac2/kgs/anatomy/freesurferRecon/babySegmentations/' subj{s} '/label/'];
        labeldir = ['/biac2/kgs/anatomy/freesurferRecon/babySegmentations/' subj{s} '/label/' atlasname '/'];
        mkdir(labeldir)
        niidir = ['/biac2/kgs/anatomy/freesurferRecon/babySegmentations/' subj{s} '/label/nii/' atlasname '/'];
        mkdir(niidir)
        
        for a = 1:length(area)
            
            % transform from fsaverage to individual baby
            command = [ 'mri_label2label ' ...
                '--srcsubject fsAverage ' ...
                '--srclabel /biac2/kgs/anatomy/freesurferRecon/babySegmentations/fsAverage/label/' atlasname '/' area(a).name ...
                ' --trgsubject ' subj{s} ...
                ' --trglabel  ' labeldir area(a).name  ...
                ' --regmethod surface --hemi ' hemisphere{h}];
           unix(command);
            
            copyfile([labeldir area(a).name],[rawlabeldir area(a).name])
            
            command =['mri_label2vol ' ...
                ' --label ' labeldir area(a).name  ...
                ' --temp /biac2/kgs/anatomy/freesurferRecon/babySegmentations/' subj{s} '/mri/orig.mgz ' ...
                ' --subject ' subj{s} ...
                ' --hemi ' hemisphere{h} ...
                ' --o '  niidir area(a).name(1:end-6) '.nii.gz'  ...
                ' --fillthresh .5 ' ...
                ' --proj frac 0 1 .1 ' ...
                ' --reg /biac2/kgs/anatomy/freesurferRecon/babySegmentations/',subj{s},'/label/register.dat'];
            unix(command)
            
        end
        % create annotation file
       cd(rawlabeldir)

        command = ['mris_label2annot --s ', subj{s}, ' --h ', hemisphere{h}, ' --ctab ' colorfile, labels, ' --a ', atlasname];
        unix(command)
         
        for l = 1:length(area)
            delete(la{l})
        end
           
                
    end
    
end