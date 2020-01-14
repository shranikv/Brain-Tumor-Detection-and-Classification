function [Contrast, Correlation, Energy, Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM, area, major, minor, Eccentricity, Solidity, EquivDiameter, Perimeter, Circularity] = finalfeature(filename)

    %filename = imread("C:\Users\Personal\Desktop\BE Project\activeContoursSnakesDemo\activeContoursDemo\Segmented\Pituitary segmented\1.jpg");
    m = size(filename,1);
    n = size(filename,2);
    signal = filename(:,:);
    [cA1,cH1,cV1,cD1] = dwt2(signal,'db4'); 
    [cA2,cH2,cV2,cD2] = dwt2(cA1,'db4');
    [cA3,cH3,cV3,cD3] = dwt2(cA2,'db4');
    DWT_feat = [cA3,cH3,cV3,cD3];
    G = pca(DWT_feat);
    whos DWT_feat
    whos G
    g = graycomatrix(G);
   
    stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
    Contrast = stats.Contrast;
    %disp(Contrast)
    Correlation = stats.Correlation;
    Energy = stats.Energy;
    Homogeneity = stats.Homogeneity;
    Mean = mean2(G);
    Standard_Deviation = std2(G);
    Entropy = entropy(G);
    RMS = mean2(rms(G));
    %Skewness = skewness(img)
    Variance = mean2(var(double(G)));
    a = sum(double(G(:)));
    Smoothness = 1-(1/(1+a));
    Kurtosis = kurtosis(double(G(:)));
    Skewness = skewness(double(G(:)));
    % Inverse Difference Movement
    m = size(G,1);
    n = size(G,2);
    in_diff = 0;
    for i = 1:m
        for j = 1:n
            temp = G(i,j)./(1+(i-j).^2);
            in_diff = in_diff+temp;
        end
    end
    IDM = double(in_diff);
   
%coverting to binary mask
bin = imbinarize(filename);
    binary = imfill(bin,'holes');%use this binary variable as input to regionprops   
 h=regionprops(binary,'all');
 disp(h);
 major=h.MajorAxisLength;
 minor=h.MinorAxisLength;
 Eccentricity=h.Eccentricity;
 Solidity=h.Solidity;
 EquivDiameter=h.EquivDiameter;
 Perimeter=h.Perimeter;
 
 area=h.Area;
%     disp(area)
Circularity= (4*pi*sum([h.Area]))/(sum([h.Perimeter]).^2);
%disp('Circularity:');

value=[Contrast Correlation Energy Homogeneity Mean Standard_Deviation Entropy RMS Variance Smoothness Kurtosis Skewness IDM area major minor Eccentricity Solidity EquivDiameter Perimeter Circularity];
xlswrite("C:\Users\Personal\Desktop\BE Project\app.xlsx",value,1,'A1:U1');

