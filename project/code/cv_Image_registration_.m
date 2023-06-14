function []=cv_Image_registration_(num)
dmode=num;
orig0 = imread(strcat('input\new',num2str(dmode),'.png'));
dist0 = imread(strcat('input\old',num2str(dmode),'.png'));
figure,imshowpair(orig0,dist0,'montage');

original=im2gray(orig0);
distorted=im2gray(dist0);

%% 1  参数
d0=0.77;  %布沃斯特函数归一化的截止距离
p0=16;   %布沃斯特函数的阶数n*2
%% 2   SURF 匹配提取特征 构建仿射变换

if dmode==1
    ptsOriginal  = detectSURFFeatures(original);
    ptsDistorted = detectSURFFeatures(distorted);
elseif dmode==2
    ptsOriginal  = detectKAZEFeatures(original);
    ptsDistorted = detectKAZEFeatures(distorted);
elseif dmode==3
    ptsOriginal  = detectSURFFeatures(original);
    ptsDistorted = detectSURFFeatures(distorted);
end

% ptsOriginal  = detectKAZEFeatures(original);
% ptsDistorted = detectKAZEFeatures(distorted);
[featuresOriginal,  validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);

indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

if dmode==1
[tform, inlierIdx] = estimateGeometricTransform2D(...
    matchedDistorted, matchedOriginal,'similarity','Maxdistance',1.5,'Confidence',99,'MaxNumTrials',1000);
elseif dmode==2
        [tform, inlierIdx] = estimateGeometricTransform2D(...
    matchedDistorted, matchedOriginal,'affine','Maxdistance',1.5,'Confidence',99,'MaxNumTrials',1000);
elseif dmode==3
    [tform, inlierIdx] = estimateGeometricTransform2D(...
    matchedDistorted, matchedOriginal,'similarity','Maxdistance',1.5,'Confidence',99,'MaxNumTrials',1000);
end
%% 绘制特征点匹配图
% inlierDistorted = matchedDistorted(inlierIdx, :);
% inlierOriginal  = matchedOriginal(inlierIdx, :);
% figure;
% showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted);
% title('Matching points (inliers only)');
% legend('ptsOriginal','ptsDistorted');
%% 3   构建布特沃斯函数实现边缘渐变效果
f1=im2double(dist0);
t1=zeros(size(f1)); 
t2=t1;
LD=norm([d0-1/2,d0-1/2],2);
tx=size(t1,2);
ty=size(t1,1);
for k=1:3
for j=1:size(t1,1)
    for i=1:size(t1,2)
        d=norm([i/tx-0.5,j/ty-0.5],2);
        t2(j,i,k)=1-1/(1+(d/LD)^p0);
        t1(j,i,k)=1-t2(j,i,k);
    end
end
end
dist0=im2uint8(im2double(dist0).*t1);
t1=im2uint8(t1);
t2=im2uint8(t2);
outputView = imref2d(size(original));
recovered  = imwarp(dist0,tform,'OutputView',outputView);
re2=imwarp(t1,tform,'OutputView',outputView);
re2=255-re2;
orig0=im2uint8(im2double(orig0).*im2double(re2));
%%   展示结果
imwrite(orig0+recovered,strcat('result\result',num2str(dmode),'.png'))
figure, imshow(orig0+recovered,[]);
end
