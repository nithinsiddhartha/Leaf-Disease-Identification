function Tfeat = w_feat(inp)

[LL LH HL HH] = dwt2(inp,'db1');

aa = [LL LH;HL HH];

% % % % 2nd level decomp
[LL1 LH1 HL1 HH1] = dwt2(LL,'db1');

% aa1 = [LL1 LH1;HL1 HH1];

% % % 3rd level Decomp

[LL2 LH2 HL2 HH2] = dwt2(LL1,'db1');

% % % 4th level Decomp

[LL3 LH3 HL3 HH3] = dwt2(LL2,'db1');

aa1 = [LL3 LH3;HL3 HH3];

aa2 = [aa1 LH2;HL2 HH2];

aa3 = [aa2 LH1;HL1 HH1];
 
aa4  = [aa3 LH;HL HH];

% figure('Name','4 Level Wavelet Decomposition')
% imshow(aa4,[]);

% % % Select the wavelet coefficients only LH3 and HL3
% % % GLCM features for LH3
LH3 = uint8(LH3);
Min_val = min(min(LH3));
Max_val = max(max(LH3));
level = round(Max_val - Min_val);
GLCM = graycomatrix(LH3,'GrayLimits',[Min_val Max_val],'NumLevels',level);
stat_feature = graycoprops(GLCM);
Energy_fet1 = stat_feature.Energy;
Contr_fet1 = stat_feature.Contrast;
Corrla_fet1 = stat_feature.Correlation;
Homogen_fet1 = stat_feature.Homogeneity;
% % % % % Entropy
        R = sum(sum(GLCM));
        Norm_GLCM_region = GLCM/R;
        
        Ent_int = 0;
        for k = 1:length(GLCM)^2
            if Norm_GLCM_region(k)~=0
                Ent_int = Ent_int + Norm_GLCM_region(k)*log2(Norm_GLCM_region(k));
            end
        end
        Entropy_fet1 = -Ent_int;
%%% Hl3
HL3 = uint8(HL3);
Min_val = min(min(HL3));
Max_val = max(max(HL3));
level = round(Max_val - Min_val);
GLCM = graycomatrix(HL3,'GrayLimits',[Min_val Max_val],'NumLevels',level);
stat_feature = graycoprops(GLCM);
Energy_fet2 = stat_feature.Energy;
Contr_fet2 = stat_feature.Contrast;
Corrla_fet2= stat_feature.Correlation;
Homogen_fet2 = stat_feature.Homogeneity;
% % % % % Entropy
        R = sum(sum(GLCM));
        Norm_GLCM_region = GLCM/R;
        
        Ent_int = 0;
        for k = 1:length(GLCM)^2
            if Norm_GLCM_region(k)~=0
                Ent_int = Ent_int + Norm_GLCM_region(k)*log2(Norm_GLCM_region(k));
            end
        end
% % % % % % Ent_int = entropy(GLCM);
        Entropy_fet2 = -Ent_int;

% % % % % Feature Sets

F1 = [Energy_fet1 Contr_fet1 Corrla_fet1 Homogen_fet1 Entropy_fet1];
F2 = [Energy_fet2 Contr_fet2 Corrla_fet2 Homogen_fet2 Entropy_fet2];

Tfeat = [F1 F2]';
