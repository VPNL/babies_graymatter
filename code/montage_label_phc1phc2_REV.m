%% For visualization of the labels: PHC1, PHC2, Cos-places, and Collateral sulcus on each individual infant's brain using Freesurfer's Freeview visualization tool.
sessions = {'bb02_mri0','bb04_mri0','bb05_mri0','bb07_mri0','bb11_mri0','bb12_mri0','bb14_mri0','bb17_mri0','bb18_mri0','bb22_mri0' 'bb02_mri3','bb04_mri3','bb05_mri3','bb07_mri3','bb08_mri3','bb11_mri3','bb12_mri3','bb14_mri3','bb15_mri3','bb18_mri3' 'bb02_mri6','bb04_mri6','bb05_mri6','bb07_mri6','bb08_mri6','bb11_mri5','bb12_mri6','bb14_mri6','bb15_mri6','bb19_mri6'} 

for i=1:30
cd(['/share/kalanit/biac2/kgs/anatomy/freesurferRecon/babySegmentations/', sessions{i}, '/surf'])
%freeview -f lh.inflated:label=../label/wangAtlas/lh.PHC1.label:label=../label/wangAtlas/lh.PHC2.label:label=../label/lhlabels/lh.S_oc-temp_med_and_Lingual.label:label=../label/rosenke_visfAtlas/lh.CoS.label rh.inflated:label=../label/wangAtlas/rh.PHC1.label:label=../label/wangAtlas/rh.PHC2.label:label=../label/rhlabels/rh.S_oc-temp_med_and_Lingual.label:label=../label/rosenke_visfAtlas/rh.CoS.label
!freeview -f lh.inflated:label=../label/wangAtlas/lh.PHC1.label:label=../label/wangAtlas/lh.PHC2.label:label=../label/lhlabels/lh.S_oc-temp_med_and_Lingual.label:label=../label/rosenke_visfAtlas/lh.CoS.label rh.inflated:label=../label/wangAtlas/rh.PHC1.label:label=../label/wangAtlas/rh.PHC2.label:label=../label/rhlabels/rh.S_oc-temp_med_and_Lingual.label:label=../label/rosenke_visfAtlas/rh.CoS.label

end


