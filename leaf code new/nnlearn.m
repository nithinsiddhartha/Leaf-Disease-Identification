function netp = nnlearn

lda = waitbar(0,'Db Loading....');
for di=1:1:25
    
    fname = strcat(int2str(di),'.jpg');
    cd Trsamples    
       im = imread(fname);
    cd ..
     im=imresize(im,[256 256]);
    [r c p] = size(im);
if p==3
    hh  = rgb2hsv(im);
else
    hh = im;
end

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
gim = rgb2gray(im);
featt = w_feat(gim);
F2 = featt';

%%% Gemotrical features

%%% segmentation %%%

[AA1, AA2, AA3, AA4] = Lclustering(gim);
% [AA1, AA2] = Lclustering(gim);
AA3 = bwfill(AA3,'holes');

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

dfeatures(:,di) = [F1 F2 F3]';
waitbar(di/15,lda);

end
close(lda);

save dfeatures dfeatures;


%%%%%%%Assigning target values to each classes
M = 5; N =1;

for i = 1:1:size(dfeatures,2)
if M==0
N = N+1;
M = 5;
else
M = M-1;
end
tv(1:size(dfeatures,1),i) = N;

end
disp(tv);
%%%%% Initialize the backpropagation with feed forward network
pv = dfeatures;
netp = newff(pv,tv);   %%%%%%%%Creation of network with desired parameters

netp = train(netp,pv,tv); %%%%%%%training of network with training samples features

save netp netp;
