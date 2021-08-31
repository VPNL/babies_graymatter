%% T1
%% ANOVA ventral versus dorsal
%% intercept Y= (left ventral/right ventral/left dorsal/right dorsal)
Y = [1.9622    2.0725    2.1772    2.1876    2.2088    2.2101    2.1963    2.2208  2.0124    2.0794    2.1459    2.1504    2.2172    2.2267    2.1944    2.2179 2.0133    2.0875    2.1772    2.2088    2.1898    2.2611    2.2781    2.3083   2.0195    2.1265    2.1899    2.1868    2.2349    2.2390    2.2976    2.2703  ]
hierarchy = [1:8 1:8 1:8 1:8]
hemi = [ones(1,8) ones(1,8)*2  ones(1,8) ones(1,8)*2]
stream= [ones(1,16) ones(1,16)*2]
[p T stats] = anovan(Y, {hierarchy,hemi,stream}, 'model', 'interaction', 'varnames', {'hierarchy', 'HEMI', 'Stream'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);


%%SLOPE
Y = [-0.0015   -0.0022   -0.0026   -0.0026   -0.0027   -0.0027   -0.0025   -0.0023  -0.0019   -0.0021   -0.0024   -0.0024   -0.0027   -0.0028   -0.0026   -0.0025  -0.0020   -0.0023   -0.0026   -0.0027   -0.0023   -0.0029   -0.0028   -0.0026  -0.0020   -0.0023   -0.0027   -0.0027   -0.0029   -0.0029   -0.0030   -0.0025  ]
hierarchy = [1:8 1:8 1:8 1:8]
hemi = [ones(1,8) ones(1,8)*2  ones(1,8) ones(1,8)*2]
stream= [ones(1,16) ones(1,16)*2]
[p T stats] = anovan(Y, {hierarchy,hemi,stream}, 'model', 'interaction', 'varnames', {'hierarchy', 'HEMI', 'Stream'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);



%% MD
Y =[    0.001212490744798   0.001264836166254   0.001254662241128   0.001247003034179   0.001256381068080   0.001267084102847   0.001252911420984   0.001263977396727 ...
   0.001200091323479   0.001239706846578   0.001221244446736   0.001206595940548   0.001252636392518   0.001251920414862   0.001253507416197   0.001264419379614 ...
   0.001202536326500   0.001239591324920   0.001253337906256   0.001251428912233   0.001263002749711   0.001266544987167   0.001299938748858   0.001334818033160 ...
0.001185568798507   0.001211845804276   0.001239072474499   0.001255878461852   0.001264775949247   0.001281727207060   0.001290070495710   0.001321938850236]
hierarchy = [1:8 1:8 1:8 1:8]
hemi = [ones(1,8) ones(1,8)*2  ones(1,8) ones(1,8)*2]
stream= [ones(1,16) ones(1,16)*2]
[p T stats] = anovan(Y, {hierarchy,hemi,stream}, 'model', 'interaction', 'varnames', {'hierarchy', 'HEMI', 'Stream'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);


%%SLOPE
Y = 1.0e-05*[-0.1082   -0.1206   -0.1184   -0.1246   -0.1232   -0.1176   -0.1064   -0.1011  -0.1146   -0.0981   -0.1074   -0.1106   -0.1334   -0.1279   -0.1297   -0.1217 -0.1207   -0.1654   -0.1636   -0.1557   -0.1625   -0.1527   -0.1673   -0.1664      -0.1170   -0.1450   -0.1611   -0.1603   -0.1655   -0.1636   -0.1620   -0.1708  ]
hierarchy = [1:8 1:8 1:8 1:8]
hemi = [ones(1,8) ones(1,8)*2  ones(1,8) ones(1,8)*2]
stream= [ones(1,16) ones(1,16)*2]
[p T stats] = anovan(Y, {hierarchy,hemi,stream}, 'model', 'interaction', 'varnames', {'hierarchy', 'HEMI', 'Stream'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);



%% R1
Y=[0.5098    0.4815    0.4561    0.4553    0.4496    0.4475    0.4530    0.4483      0.4954    0.4790    0.4625    0.4620    0.4468    0.4437    0.4522    0.4468  0.4960    0.4802    0.4579    0.4494    0.4547    0.4388    0.4342    0.4289  0.4937    0.4691    0.4539    0.4528    0.4415    0.4412    0.4292    0.4358 ]
hierarchy = [1:8 1:8 1:8 1:8]
hemi = [ones(1,8) ones(1,8)*2  ones(1,8) ones(1,8)*2]
stream= [ones(1,16) ones(1,16)*2]
[p T stats] = anovan(Y, {hierarchy,hemi,stream}, 'model', 'interaction', 'varnames', {'hierarchy', 'HEMI', 'Stream'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);


%%SLOPE
Y = 1.0e-03 * [ 0.4576    0.6304    0.7204    0.6994    0.7131    0.7334    0.6415    0.5722 0.5557    0.5889    0.6689    0.6573    0.7281    0.7644    0.6999    0.6540  0.6166    0.6396    0.6858    0.7216    0.5970    0.7466    0.6990    0.6298  0.5903    0.6254    0.7259    0.7283    0.7843    0.7636    0.7707    0.6411]
hierarchy = [1:8 1:8 1:8 1:8]
hemi = [ones(1,8) ones(1,8)*2  ones(1,8) ones(1,8)*2]
stream= [ones(1,16) ones(1,16)*2]
[p T stats] = anovan(Y, {hierarchy,hemi,stream}, 'model', 'interaction', 'varnames', {'hierarchy', 'HEMI', 'Stream'});
set(gcf, {'DefaultAxesXColor','DefaultAxesYColor'}, {'k' 'k'})
multcompare(stats, 'dim', 1);
multcompare(stats, 'dim', 2);
multcompare(stats, 'dim', 3);


