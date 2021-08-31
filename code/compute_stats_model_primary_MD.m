function []=compute_stats_model_primary_MD()
% this code is useful for generating figure 1 and Supplementary Fig 4. This produced Figures related to development in MD in the first 6 months of life in the primary sensory-motor regions.
%%%%%%%% models %%%%%%%%
cd('/share/kalanit/biac2/kgs/projects/babybrains/mri/results/density/scatter_plots');
prim_R= load('All_primary_MD_right');
prim_L= load('All_primary_MD_left');

%% these are the subjects and this is the order
%% subj= {'bb02_mri0'  'bb02_mri3' 'bb02_mri6' 'bb04_mri0' 'bb04_mri3' 'bb04_mri6' 'bb05_mri0' 'bb05_mri3' 'bb05_mri6' 'bb07_mri0' 'bb07_mri3' 'bb07_mri6'  'bb08_mri3' 'bb08_mri6'  'bb11_mri0' 'bb11_mri3' 'bb11_mri5' 'bb12_mri0' 'bb12_mri3' 'bb12_mri6' 'bb14_mri0' 'bb14_mri3' 'bb14_mri6', 'bb15_mri3' 'bb15_mri6' 'bb17_mri0' 'bb18_mri0' 'bb18_mri3' 'bb19_mri6'  'bb22_mri0'};
age = [ 85 185 23 101 189 24 91 189 37 95 179 83 181 24 78 167  104 181 31 79 174 104 195 18 22 106 177 30]

%% 1. GRAND ANOVA
%% %%%%%%%%%%%%%%%%%%% FOR ANOVA %%%%%%%%%%%%%%%%%%%%55
% % number of rois: 10 per hemi,
Y = [reshape(prim_L.All_MD, 1, 112) reshape(prim_R.All_MD, 1, 112)];
age_subj= [2 3  1 2 3  1 2 3  1 2 3 2 3 1 2 3  2 3 1 2 3 2 3 1 1 2 3 1];
AGE = [repmat(age_subj, 1, 8)];
roi =[ones(1,28)*1 ones(1,28)*2 ones(1,28)*3 ones(1,28)*4];
ROIS = [roi roi];
HEMI =[ones(1, 112)*1 ones(1, 112)*2];

%% do anova %%%%%%%%%%%%
[p T stats] = anovan(Y, {ROIS,AGE, HEMI}, 'model', 'interaction', 'varnames', {'ROIs', 'Ageofsubj', 'Hemi'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);

%% left hemisphere
%% MODE 1  %% random intercept and fixed slope
%gray to green (phc1, cos) to red (pfus/mfus)
color = [[255 153 51]/255; [51 153 255]/255; [255 255 51]/255; [153 255 51]/255];
color = [[255 178 102]/255; [153 204 255]/255; [255 102 102]/255; [178 255 102]/255];
roi_list={'V1_ROI' 'A1_ROI' '3b_ROI' '4_ROI'};


figure; set(gcf,'color','white'); 
inC1=[]; slP1=[];  inCSE1=[]; slPSE1=[]; RR=[]; pp=[]; Rsq=[];
%% build a table/model per roi
for roi =1:length(roi_list)
    MDmean= prim_L.All_MD(:,roi);
   
    tbl= table(age', MDmean, [ 1 1 2 2 2 3 3 3 4 4 4 5 5 6 6 6  7 7 8 8 8 9 9 10 11 11 12 13]','VariableNames',{'Age','MDmean','Baby'})
    
    lme1= fitlme(tbl,'MDmean~ Age +(1|Baby)')
    
    hA(roi) =subplot(1, length(roi_list),roi); hold; 
    %set(gca,'Position',[0 0+roi .5 1]); hold;
     
    x = 0:180; y = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*x;
    inC1(roi) = lme1.Coefficients.Estimate(1);
    slP1(roi) = lme1.Coefficients.Estimate(2);
    
    inCSE1(roi) = lme1.Coefficients.SE(1);
    slPSE1(roi) = lme1.Coefficients.SE(2);
    %% this plots the corr line
    plot(x,y, 'color', color(roi,:))
    %xlabel('Age [in days]', 'FontSize', 14, 'Fontweight', 'bold', 'Color', [0 0 0]);
    %ylabel('MD [s]', 'FontSize',14, 'Fontweight', 'bold', 'Color', [0 0 0]);
    axis([0 200 .0009 0.0015]);
    set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'white' 'white'}); grid on;
    h1=scatter([age],[MDmean], 150, [age], 'filled',  'MarkerFacecolor', color(roi,:),'MarkerEdgecolor', [.7 .7 .7]); colormap([color(roi,:); color(roi,:)]); % colorbar('eastoutside');
    [R p]= corrcoef(MDmean,age)
    RR(roi)=R(1,2)
    pp{roi}=p(1,2)
    Rsq(roi)=lme1.Rsquared.Ordinary
  title([' roi: ',roi_list{roi}, ' R = ', num2str(R(1,2)),  ' p = ', num2str(p(1,2))], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
    hold off;
    model1{roi} = lme1;
end


pos = get(hA(1),'position');
pos(1)=.1; set(hA(1),'position', pos)
pos = get(hA(2),'position');
pos(1)=.28; set(hA(2),'position', pos)
pos = get(hA(3),'position');
pos(1)=.46; set(hA(3),'position', pos)
pos = get(hA(4),'position');
pos(1)=.64; set(hA(4),'position', pos)



figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
axis([0 5 .0009 0.0015]); 
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[inC1(i)], 220, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', [.7 .7 .7]);
    errorbar([i], inC1(i), inCSE1(i), 'color', color(i,:));
end

figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
%axis([0 5 -0.0035 -0.001]); 
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[slP1(i)], 220, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', [.7 .7 .7]);
    errorbar([i], slP1(i), slPSE1(i), 'color', color(i,:));
end


%% RIGHT HEMI NOW
%% MODE 1  %% random intercept and fixed slope
figure; set(gcf,'color','white');
inC1=[]; slP1=[];  inCSE1=[]; slPSE1=[];
RR=[];
pp=[];
Rsq=[];
%% build a table/model per roi
for roi =1:length(roi_list)
    MDmean= prim_R.All_MD(:,roi);
    tbl= table(age', MDmean, [ 1 1 2 2 2 3 3 3 4 4 4 5 5 6 6 6  7 7 8 8 8 9 9 10 11 11 12 13]','VariableNames',{'Age','MDmean','Baby'})
    
    lme1= fitlme(tbl,'MDmean~ Age +(1|Baby)')
    
    hA(roi)=subplot(1, length(roi_list),roi); hold;
    x = 0:180; y = lme1.Coefficients.Estimate(1) + (lme1.Coefficients.Estimate(2))*x;
    inC1(roi) = lme1.Coefficients.Estimate(1);
    slP1(roi) = lme1.Coefficients.Estimate(2);
    
    inCSE1(roi) = lme1.Coefficients.SE(1);
    slPSE1(roi) = lme1.Coefficients.SE(2);
    %% this plots the corr line
    plot(x,y, 'color', color(roi,:))
    %xlabel('Age [in days]', 'FontSize', 14, 'Fontweight', 'bold', 'Color', [0 0 0]);
    %ylabel('MD [s]', 'FontSize',14, 'Fontweight', 'bold', 'Color', [0 0 0]);
    axis([0 200 .0009 0.0015]);
    set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'white' 'white'}); grid on;
    h1=scatter([age],[MDmean], 150, [age], 'filled',  'MarkerFacecolor', color(roi,:),'MarkerEdgecolor', [.7 .7 .7]); colormap([color(roi,:); color(roi,:)]); % colorbar('eastoutside');
    [R p]= corrcoef(MDmean,age)
    RR(roi)=R(1,2)
    pp{roi}=p(1,2)
     Rsq(roi)=lme1.Rsquared.Ordinary
    title([' roi: ',roi_list{roi}, ' R = ', num2str(R(1,2)),  ' p = ', num2str(p(1,2))], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
    hold off;
    model1{roi} = lme1;
end
keyboard
pos = get(hA(1),'position');
pos(1)=.1; set(hA(1),'position', pos)
pos = get(hA(2),'position');
pos(1)=.28; set(hA(2),'position', pos)
pos = get(hA(3),'position');
pos(1)=.46; set(hA(3),'position', pos)
pos = get(hA(4),'position');
pos(1)=.64; set(hA(4),'position', pos)




figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
axis([0 5 .0009 0.0015]); 
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[inC1(i)], 220, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', [.7 .7 .7]);
    errorbar([i], inC1(i), inCSE1(i), 'color', color(i,:));
end

figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
%axis([0 5 -0.0035 -0.001]); 
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[slP1(i)], 220, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', [.7 .7 .7]);
    errorbar([i], slP1(i), slPSE1(i), 'color', color(i,:));
end

end