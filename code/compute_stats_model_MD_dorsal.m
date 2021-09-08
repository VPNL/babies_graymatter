function []=compute_stats_model_MD_dorsal()
% this code is useful for generating Supplementary Figure 6. This produces figures related to development in MD in the first 6 months of life in the dorsal visual stream
%%%%%%%% models %%%%%%%%
cd('/share/kalanit/biac2/kgs/projects/babybrains/mri/results/density/scatter_plots');
Dor_R= load('All_dorsal_MD_right');
Dor_L= load('All_dorsal_MD_left');

%% these are the subjects and this is the order
 sess= {  'bb02_mri3' 'bb02_mri6' 'bb04_mri0' 'bb04_mri3' 'bb04_mri6' 'bb05_mri0' 'bb05_mri3' 'bb05_mri6' 'bb07_mri0' 'bb07_mri3' 'bb07_mri6'  'bb08_mri3' 'bb08_mri6'  'bb11_mri0' 'bb11_mri3' 'bb11_mri5'  'bb12_mri3' 'bb12_mri6' 'bb14_mri0' 'bb14_mri3' 'bb14_mri6', 'bb15_mri3' 'bb15_mri6' 'bb17_mri0' 'bb18_mri0' 'bb18_mri3' 'bb19_mri6'  'bb22_mri0'};
 age = [ 85 185 23 101 189 24 91 189 37 95 179 83 181 24 78 167  104 181 31 79 174 104 195 18 22 106 177 30]
roi_list ={'V1d' 'V2d' 'V3d' 'V3a' 'V3b' 'IPS0' 'IPS1' 'IPS2' 'IPS3'}

%% without bb04 mri3 bad md maps
%%sess= { 'bb02_mri3' 'bb02_mri6' 'bb04_mri0'  'bb04_mri6' 'bb05_mri0' 'bb05_mri3' 'bb05_mri6' 'bb07_mri0' 'bb07_mri3' 'bb07_mri6'  'bb08_mri3' 'bb08_mri6'  'bb11_mri0' 'bb11_mri3' 'bb11_mri5'  'bb12_mri3' 'bb12_mri6' 'bb14_mri0' 'bb14_mri3' 'bb14_mri6', 'bb15_mri3' 'bb15_mri6' 'bb17_mri0' 'bb18_mri0' 'bb18_mri3' 'bb19_mri6'  'bb22_mri0'};
%age = [ 85 185 23  189 24 91 189 37 95 179 83 181 24 78 167  104 181 31 79 174 104 195 18 22 106 177 30]
%% 9 rois.
%% 1. GRAND ANOVA
%% %%%%%%%%%%%%%%%%%%% FOR ANOVA %%%%%%%%%%%%%%%%%%%%55
% % number of rois: 10 per hemi,
Y = [reshape(Dor_L.All_MD, 1, 252) reshape(Dor_R.All_MD, 1, 252)];
age_subj= [ 2 3  1 2 3  1 2 3  1 2 3 2 3 1 2 3   2 3 1 2 3 2 3 1 1 2 3 1];
AGE = [repmat(age_subj, 1, 18)];
roi =[ones(1,28)*1 ones(1,28)*2 ones(1,28)*3 ones(1,28)*4 ones(1,28)*5  ones(1,28)*6 ones(1,28)*7 ones(1,28)*8 ones(1,28)*9 ];
ROIS = [roi roi];
HEMI =[ones(1,252)*1 ones(1,252)*2];

%% do anova %%%%%%%%%%%%
[p T stats] = anovan(Y, {ROIS,AGE, HEMI}, 'model', 'interaction', 'varnames', {'ROIs', 'Ageofsubj', 'Hemi'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);

%% MODE 1  %% random intercept and fixed slope
color = [[32 32 32]/255; [64 64 64]/255;  [96 96 96]/255; [192 192 192]/255;  [204 229 255]/255 ; [153 204 255]/255 ;  [102  178  255]/255 ; [51 153  255]/255; [0 102 204]/255; [0 0 153]/255; [76 0 153]/255; [51 0 102]/255];
roi_list ={'V1d' 'V2d' 'V3d' 'V3a' 'V3b' 'IPS0' 'IPS1' 'IPS2' 'IPS3'}
figure; set(gcf,'color','white');
inC1=[]; slP1=[];  inCSE1=[]; slPSE1=[]; Rsq=[];
group=[ 1 1 2 2 2 3 3 3 4 4 4 5 5 6 6 6 7 7 8 8 8 9 9 10 11 11 12 13];
%% build a table/model per roi
for roi =1:length(roi_list)
    MDmean= Dor_L.All_MD(:,roi);
    tbl= table(age', MDmean, group','VariableNames',{'Age','MDmean','Baby'})
    
    lme1= fitlme(tbl,'MDmean~ Age +(1|Baby)')
    
    subplot(1, length(roi_list),roi); hold;
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
    h1=scatter([age],[MDmean], 30, [age], 'filled',  'MarkerFacecolor', color(roi,:),'MarkerEdgecolor', [.7 .7 .7]); colormap([color(roi,:); color(roi,:)]); % colorbar('eastoutside');
    [R p]= corrcoef(MDmean,age)
   title([' roi: ',roi_list{roi}, ' R = ', num2str(R(1,2)),  ' p = ', num2str(p(1,2))], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
    hold off;
    model1{roi} = lme1;
     Rsq(roi)=lme1.Rsquared.Ordinary
end

figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
%axis([0 11 1.8 2.4]); 
xlim([0 11]) 
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[inC1(i)], 150, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', color(i,:));
    errorbar([i], inC1(i), inCSE1(i), 'color', color(i,:),'Linewidth',3);
end



figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold; xlim([0 11]) 
axis([0 11 -0.0000019 -0.0000007]); 
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[slP1(i)], 150, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', color(i,:));
    errorbar([i], slP1(i), slPSE1(i), 'color', color(i,:),'Linewidth',3);
end

figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
%axis([-0.0033 -0.0012 1.8 2.4]); 
  scatter([slP1],[inC1], 150, [1:length(roi_list)], 'filled',  'MarkerFacecolor',[0 0 0],'MarkerEdgecolor',[1 1 1]); lsline
  [r p ]=corrcoef([slP1],[inC1]);
  ylabel({'intercept'});
 xlabel({'slope'});
 title(['R = ', num2str(r(1,2)), '  p=', num2str(p(1,2))])
  for i=1:length(roi_list)
    
    scatter([slP1(i)],[inC1(i)], 150, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor',  color(i,:));
    h=herrorbar([slP1(i)],inC1(i) , slPSE1(i));
    set(h, 'color',color(i,:),'Linewidth',3)
    
    errorbar([slP1(i)], inC1(i), inCSE1(i), 'color', color(i,:),'Linewidth',3);
  end


%% RIGHT HEMI NOW
%% MODE 1  %% random intercept and fixed slope
color = [[32 32 32]/255; [64 64 64]/255;  [96 96 96]/255; [192 192 192]/255;  [204 229 255]/255 ; [153 204 255]/255 ;  [102  178  255]/255 ; [51 153  255]/255; [0 102 204]/255; [0 0 153]/255; [76 0 153]/255; [51 0 102]/255];

figure; set(gcf,'color','white');
inC1=[]; slP1=[];  inCSE1=[]; slPSE1=[]; Rsq=[]
%% build a table/model per roi
for roi =1:length(roi_list)
    MDmean= Dor_R.All_MD(:,roi);
    tbl= table(age', MDmean, group','VariableNames',{'Age','MDmean','Baby'})
    
    lme1= fitlme(tbl,'MDmean~ Age +(1|Baby)')
    
    subplot(1, length(roi_list),roi); hold;
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
    h1=scatter([age],[MDmean], 30, [age], 'filled',  'MarkerFacecolor', color(roi,:),'MarkerEdgecolor', [.7 .7 .7]); colormap([color(roi,:); color(roi,:)]); % colorbar('eastoutside');
    [R p]= corrcoef(MDmean,age)
    title([' roi: ',roi_list{roi}, ' R = ', num2str(R(1,2)),  ' p = ', num2str(p(1,2))], 'FontSize', 6,'Fontweight', 'bold', 'Color', [0 0 0]);
    hold off;
    model1{roi} = lme1;
    Rsq(roi)=lme1.Rsquared.Ordinary
end

figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
xlim([0  11])
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[inC1(i)], 150, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', color(i,:));
    errorbar([i], inC1(i), inCSE1(i), 'color', color(i,:),'Linewidth',3);
end



figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
axis([0 11 -0.0000019 -0.0000007]); 
xlim([0 11])
title('random intercept/fixed Slope')
for i=1:length(roi_list)
    
    scatter([i],[slP1(i)], 150, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor', color(i,:));
    errorbar([i], slP1(i), slPSE1(i), 'color', color(i,:),'Linewidth',3);
end

figure;
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'});
set(gcf,'color','white'); hold;
%axis([-0.0033 -0.0012 1.8 2.4]); 
  scatter([slP1],[inC1], 150, [1:length(roi_list)], 'filled',  'MarkerFacecolor',[0 0 0],'MarkerEdgecolor',[1 1 1]); lsline
  [r p ]=corrcoef([slP1],[inC1]);
  ylabel({'intercept'});
 xlabel({'slope'});
 title(['R = ', num2str(r(1,2)), '  p=', num2str(p(1,2))])
  for i=1:length(roi_list)
    
    scatter([slP1(i)],[inC1(i)], 150, [i], 'filled',  'MarkerFacecolor', color(i,:),'MarkerEdgecolor',  color(i,:));
    h=herrorbar([slP1(i)],inC1(i) , slPSE1(i));
    set(h, 'color',color(i,:),'Linewidth',3)
    
    errorbar([slP1(i)], inC1(i), inCSE1(i), 'color', color(i,:),'Linewidth',3);
  end


end
