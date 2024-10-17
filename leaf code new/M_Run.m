clc;
clear all;
close all;

cd Input
    [filename, pathname] = uigetfile('*.jpg;*.bmp', 'Pick an Image file');
if isequal(filename,0) || isequal(pathname,0)
    warndlg('User pressed cancel');
    return;
else
    disp(['User selected ', fullfile(pathname, filename)]);
    inp = imread(filename);
    inp=imresize(inp,[256 256]);
    [r c p] = size(inp);
cd ..
if p==3
    hh = rgb2hsv(inp);
else
    hh = im;
end
figure;
imshow(inp);title('Test Image');
figure;
imshow(hh,[]);title('HSV Image');
end
%%% Plane Separation %%%
Rch = inp(:,:,1);
Gch = inp(:,:,2);
Bch = inp(:,:,3);

figure;
subplot(1,3,1); imshow(Rch);title('red channel');
subplot(1,3,2); imshow(Gch);title('green channel');
subplot(1,3,3); imshow(Bch);title('blue channel');
inp22=im2bw(inp);
figure;
imshow(inp22);
title('Segmentation Image');

inp22=double(inp22);

boundary = bwboundaries(inp22);
figure; 
imtool(inp); title('Abnormal  Localization');
hold on;
 for ii=1:1:length(boundary)
       btemp = boundary{ii};
       plot(btemp(:,2),btemp(:,1),'r','LineWidth',2);
   end
hold off;

%%% Feature Extraction %%%
%%% Color Features %%%
h = hh(:,:,1);
s = hh(:,:,2);
h = double(h);s = double(s);

%%%%%% Mean and Covariance features
HMn = mean(mean(h));
SMn = mean(mean(s));
HCv = sum(sum(cov(h)))./length(h).^2;
SCv = sum(sum(cov(s)))./length(s).^2;    
F1 = [HMn SMn HCv SCv];

%%% Texture Features %%%
gim = rgb2gray(inp);
featt = w_feat(gim);
F2 = featt';

%%% Gemotrical features
%%% segmentation %%%
[AA1, AA2, AA3, AA4] = Lclustering(gim);
AA3 = bwfill(AA3,'holes');

figure;
subplot(2,2,1);imshow(AA1,[]);title('1st Cluster');

subplot(2,2,2);imshow(AA2,[]);title('2nd Cluster');

subplot(2,2,3);imshow(AA3,[]);title('3rd Cluster');

subplot(2,2,4);imshow(AA4,[]);title('4th Cluster');

[Sout,Cnt] = bwlabel(AA3,8);
Gprops = regionprops(Sout,'all');

for Ci=1:1:Cnt
    Garea(Ci) = Gprops(Ci).Area;
end
[Amax,Aind] = max(Garea);

Gfeat(1) = Gprops(Aind).Area; 
Gfeat(2) = Gprops(Aind).EulerNumber;
Gfeat(3) = Gprops(Aind).Perimeter; 
Gfeat(4) = Gprops(Aind).Eccentricity;
Gfeat(5) = Gprops(Aind).Orientation; 
Gfeat(6) = Gprops(Aind).EquivDiameter;
Btemp = Gprops(Aind).BoundingBox; 
Gfeat(7) = Btemp(3); Gfeat(8) = Btemp(4);
F3 = Gfeat;
Qfeat = [F1 F2 F3]';

load netp;

%%%%%Classification by simulating trained network model

cout = sim(netp,Qfeat);
cout = round(mean2(cout));
fprintf('\n');
if isequal(cout,1)
    msgbox('CERCOSPORA','The Result: ');
    disp('Diseases and its CURE : CERCOSPORA');
    disp('      Half Ounce Copper with 1 Gallon Water');
elseif isequal(cout,2)
    msgbox('CERCOSPORIDIUM PERSONATUM','The Result: ');
    disp('Diseases and its CURE : CERCOSPORIDIUM PERSONATUM');
    disp('      0.97 Gllitre followed by Triazole');
elseif isequal(cout,3)
    msgbox('PHAEOISARIOPSIS PERSONATA','The Result: ');
    disp('Diseases and its CURE : PHAEOISARIOPSIS PERSONATA');
    disp('      neem leaf extracts (2-5)& for thrice  2weeks & 4 weeks after Planting');
elseif isequal(cout,4)

    msgbox('ALTERNARIS','The Result: ');
    disp('Diseases and its CURE : ALTERNARIS');
    disp('      Foliar application of Mancozeb 0.3%');
elseif isequal(cout,5)
    msgbox('NORMAL LEAF','The Result: ');
else
    msgbox('DB Updation Required');
end


