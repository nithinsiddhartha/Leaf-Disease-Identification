%% Result Analysis

Input=inp;
Output=AA3;

%%True Positive Value %%%
[m n]=size(Input);

Tp=1;

for i=1:m
for j=1:n
if (Input(i,j)==0 && Output(i,j)==1)    
    
    Tp=Tp+1;
end
end
end

disp('Tp value');
disp(Tp);

%%  True Negative Value %%
Tn=1;

for i=1:m
for j=1:n
if (Input(i,j)==0 && Output(i,j)==0 )    
    
    Tn=Tn+1;
end
end
end

disp('Tn value');
disp(Tn);


%% False Positive Value %%%
Fp=1;

for i=1:m
for j=1:n
if (Input(i,j)==1 && Output(i,j)==0 )    
    
    Fp=Fp+1;
end
end
end

disp('Fp value');
disp(Fp);

%% False Negative Value %%%
Fn=1;

for i=1:m
for j=1:n
if (Input(i,j)==1 && Output(i,j)==1 )    
    
    Fn=Fn+1;
end
end
end

disp('Fn value');
disp(Fn);
                      
Sensitivity = (Tp./(Tp+Fn)).*100;
Specificity = (Tn./(Tn+Fp)).*100;

Accuracy = ((Tp+Tn)./(Tp+Tn+Fp+Fn)).*100;

figure('Name','Performance Metrics','MenuBar','none'); 
bar3(1,Sensitivity,0.3,'m');
hold on;
bar3(2,Specificity,0.3,'r');
hold on;
bar3(3,Accuracy,0.3,'g');
hold off;

xlabel('Parametrics--->');
zlabel('Value--->');
legend('Sensitivity','Specificity','Accuracy');

disp('Sensitivity: '); disp(Sensitivity);
disp('Specificity: '); disp(Specificity);
disp('Accuracy:'); disp(Accuracy);